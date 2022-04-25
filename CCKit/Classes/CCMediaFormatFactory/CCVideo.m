//
//  CCVideo.m
//  LCCKit
//
//  Created by lucc on 2022/4/23.
//

#import "CCVideo.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface CCVideo ()
@property (strong, nonatomic) AVAssetWriter *videoWriter;

@property(nonatomic, strong) dispatch_queue_t backgroundQueue;
@end

@implementation CCVideo

- (id)init {
    self = [super init];
    if(self) {
        self.backgroundQueue = dispatch_queue_create("com.cc.media.video", NULL);
    }
    return self;
}

- (void)convertGIFToMP4:(NSData *)gif speed:(float)speed size:(CGSize)size repeat:(int)repeat output:(NSString *)path completion:(void (^)(NSError *))completion {
    
    repeat++;
    __block float movie_speed = speed;
    
    dispatch_async(self.backgroundQueue, ^(void){
        if(movie_speed == 0.0)
            movie_speed = 1.0; // You can't have 0 speed stupid
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:path]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completion([[NSError alloc] initWithDomain:@"com.cc.media" code:405 userInfo:@{NSLocalizedDescriptionKey: @"Output file already exists"}]);
            });
            return;
        }
        
        NSDictionary *gifData = [self loadGIFData:gif resize:size repeat:repeat];
        
        UIImage *first = [[gifData objectForKey:@"frames"] objectAtIndex:0];
        CGSize frameSize = first.size;
        frameSize.width = round(frameSize.width / 16) * 16;
        frameSize.height = round(frameSize.height / 16) * 16;
        
        NSError *error = nil;
        self.videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path] fileType:AVFileTypeMPEG4 error:&error];
        
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completion(error);
            });
            return;
        }
        
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:frameSize.width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:frameSize.height], AVVideoHeightKey,
                                       nil];
        
        AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32ARGB] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
        [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.width] forKey:(NSString *)kCVPixelBufferWidthKey];
        [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.height] forKey:(NSString *)kCVPixelBufferHeightKey];
        
        AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:attributes];
        
        [self.videoWriter addInput:writerInput];
        
        writerInput.expectsMediaDataInRealTime = YES;
        
        [self.videoWriter startWriting];
        [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
        
        CVPixelBufferRef buffer = NULL;
        buffer = [self pixelBufferFromCGImage:[first CGImage] size:frameSize];
        BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
        if(result == NO)
            NSLog(@"Failed to append buffer");
        
        if(buffer)
            CVBufferRelease(buffer);
        
        int fps = ([[gifData objectForKey:@"frames"] count] / [[gifData valueForKey:@"animationTime"] floatValue]) * movie_speed;
        NSLog(@"FPS: %d", fps);
        
        int i = 0;
        while(i < [[gifData objectForKey:@"frames"] count]) {
            UIImage *image = [[gifData objectForKey:@"frames"] objectAtIndex:i];
            if(adaptor.assetWriterInput.readyForMoreMediaData) {
                i++;
                CMTime frameTime = CMTimeMake(1, fps);
                CMTime lastTime = CMTimeMake(i, fps);
                CMTime presentTime = CMTimeAdd(lastTime, frameTime);
                
                buffer = [self pixelBufferFromCGImage:[image CGImage] size:frameSize];
                
                BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
                if(result == NO)
                    NSLog(@"Failed to append buffer: %@", [self.videoWriter error]);
                
                if(buffer)
                    CVBufferRelease(buffer);
                
                [NSThread sleepForTimeInterval:0.1];
                
            } else {
                NSLog(@"Error: Adaptor is not ready");
                [NSThread sleepForTimeInterval:0.1];
                i--;
            }
        }
        
        [writerInput markAsFinished];
        [self.videoWriter finishWritingWithCompletionHandler:^(void){
            NSLog(@"Finished writing");
            CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
            self.videoWriter = nil;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completion(nil);
            });
        }];
    });
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)options, &pxbuffer);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaNoneSkipFirst);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}

- (NSDictionary *)loadGIFData:(NSData *)data resize:(CGSize)size repeat:(int)repeat {
    NSMutableArray *frames = nil;
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if(src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for(size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if(img) {
                if(size.width != 0.0 && size.height != 0.0) {
                    UIGraphicsBeginImageContext(size);
                    CGFloat width = CGImageGetWidth(img);
                    CGFloat height = CGImageGetHeight(img);
                    if (CGSizeEqualToSize(size, CGSizeZero)) {
                        size = CGSizeMake(width, height);
                    }
                    int x = 0, y = 0;
                    if(height > width) {
                        CGFloat padding = size.height / height;
                        height = height * padding;
                        width = width * padding;
                        x = (size.width/2) - (width/2);
                        y = 0;
                    } else if(width > height) {
                        CGFloat padding = size.width / width;
                        height = height * padding;
                        width = width * padding;
                        x = 0;
                        y = (size.height/2) - (height/2);
                    } else {
                        width = size.width;
                        height = size.height;
                    }
                    
                    [[UIImage imageWithCGImage:img] drawInRect:CGRectMake(x, y, width, height) blendMode:kCGBlendModeNormal alpha:1.0];
                    [frames addObject:UIGraphicsGetImageFromCurrentImageContext()];
                    UIGraphicsEndImageContext();
                    CGImageRelease(img);

                } else {
                    [frames addObject:[UIImage imageWithCGImage:img]];
                    CGImageRelease(img);
                }
            }
        }
        CFRelease(src);
    }
    
    NSArray *framesCopy = [frames copy];
    for(int i = 1; i < repeat; i++) {
        [frames addObjectsFromArray:framesCopy];
    }
    
    return @{@"animationTime" : [NSNumber numberWithFloat:animationTime * repeat], @"frames":  frames};
}

#pragma mark -- Format Convert

/// 获取导出质量
+ (NSString * const)getAVAssetExportPresetQuality:(CCExportPresetType)presetType{
    switch (presetType) {
        case CCExportPresetTypeLowQuality:
            return AVAssetExportPresetLowQuality;
        case CCExportPresetTypeMediumQuality:
            return AVAssetExportPresetMediumQuality;
        case CCExportPresetTypeHighestQuality:
            return AVAssetExportPresetHighestQuality;
        case CCExportPresetType640x480:
            return AVAssetExportPreset640x480;
        case CCExportPresetType960x540:
            return AVAssetExportPreset960x540;
        case CCExportPresetType1280x720:
            return AVAssetExportPreset1280x720;
        case CCExportPresetType1920x1080:
            return AVAssetExportPreset1920x1080;
        case CCExportPresetType3840x2160:
            return AVAssetExportPreset3840x2160;
        default:
            return AVAssetExportPresetMediumQuality;
    }
}
/// 获取导出格式
+ (NSString * const)getVideoFileType:(CCVideoFileType)videoType{
    switch (videoType) {
        case CCVideoFileTypeMov:
            return AVFileTypeQuickTimeMovie;
        case CCVideoFileTypeMp4:
            return AVFileTypeMPEG4;
        case CCVideoFileTypeM4v:
            return AVFileTypeAppleM4V;
        default:
            return AVFileTypeMPEG4;
    }
}

/// 开始转码
- (void)startConvertFormat {
    NSString *presetName = [CCVideo getAVAssetExportPresetQuality:self.presetType];
    NSString *videoType  = [CCVideo getVideoFileType:self.outputFileType];
    NSString *suffix = CCVideoFileTypeMap[self.outputFileType];
    if (![self.outputUrl hasSuffix:suffix]) {
        self.outputUrl = [self.outputUrl stringByAppendingString:suffix];
    }
    if (!self.sourceVideo) {
        NSError *error = [CCVideo createError:1008 DescriptionKey:@"Lack of material"];
        !self.completionHandler ?: self.completionHandler(nil, error);
    } else if ([self.sourceVideo isKindOfClass:NSURL.class]) {
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.sourceVideo options:nil];
        [self convertAVURLAsset:avAsset outputPath:self.outputUrl fileType:videoType presetName:presetName];
    } else if ([self.sourceVideo isKindOfClass:AVURLAsset.class]) {
        [self convertAVURLAsset:self.sourceVideo outputPath:self.outputUrl fileType:videoType presetName:presetName];
    } else if ([self.sourceVideo isKindOfClass:PHAsset.class]) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = true;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:self.sourceVideo options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                [self convertAVURLAsset:(AVURLAsset *)asset outputPath:self.outputUrl fileType:videoType presetName:presetName];
            } else{
                NSError *error = [CCVideo createError:1008 DescriptionKey:@"PHAsset error"];
                !self.completionHandler ?: self.completionHandler(nil, error);
            }
        }];
    } else {
        NSError *error = [CCVideo createError:1009 DescriptionKey:@"not support sourceVideo input"];
        !self.completionHandler ?: self.completionHandler(nil, error);
    }
}

#pragma mark - 转码

- (void)convertAVURLAsset:(AVURLAsset*)asset
               outputPath:(NSString *)outputPath
                 fileType:(NSString*)fileType
               presetName:(NSString*)presetName {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:asset.URL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:presetName]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:presetName];
        exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
        exportSession.shouldOptimizeForNetworkUse = YES;
        NSArray *supportedTypeArray = exportSession.supportedFileTypes;
        if (![supportedTypeArray containsObject:fileType]) {
            NSError *error = [CCVideo createError:1010 DescriptionKey:@"AVAssetExportSession format is not support"];
            !self.completionHandler ?: self.completionHandler(nil, error);
            return;
        }
        exportSession.outputFileType = fileType;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown:
                case AVAssetExportSessionStatusWaiting:
                case AVAssetExportSessionStatusExporting:
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCancelled:{
                    NSString *key  = [CCVideo getStatusDescriptionKey:exportSession.status];
                    NSError *error = [CCVideo createError:exportSession.status+1001 DescriptionKey:key];
                    !self.completionHandler ?: self.completionHandler(nil, error);
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                    !self.completionHandler ?: self.completionHandler(exportSession.outputURL.absoluteString, nil);
                    break;
            }
        }];
    } else{
        NSError *error = [CCVideo createError:1007 DescriptionKey:@"AVAssetExportSessionStatusNoPreset"];
        !self.completionHandler ?: self.completionHandler(nil, error);
    }
}

+ (NSString*)getStatusDescriptionKey:(AVAssetExportSessionStatus)status {
    switch (status) {
        case AVAssetExportSessionStatusUnknown:
            return @"AVAssetExportSessionStatusUnknown";
        case AVAssetExportSessionStatusWaiting:
            return @"AVAssetExportSessionStatusWaiting";
        case AVAssetExportSessionStatusExporting:
            return @"AVAssetExportSessionStatusExporting";
        case AVAssetExportSessionStatusCompleted:
            return @"AVAssetExportSessionStatusCompleted";
        case AVAssetExportSessionStatusFailed:
            return @"AVAssetExportSessionStatusFailed";
        case AVAssetExportSessionStatusCancelled:
            return @"AVAssetExportSessionStatusCancelled";
        default:
            return @"AVAssetExportSessionStatusExceptionError";
            
    }
}

+ (NSError*)createError:(NSInteger)code DescriptionKey:(NSString*)key{
    return [NSError errorWithDomain:@"ConvertErrorDomain" code:code userInfo:@{NSLocalizedDescriptionKey:key}];
}

+ (NSDictionary*)getVideoInfo:(PHAsset*)asset {
    PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: asset] firstObject];
    NSMutableArray *resourceArray = nil;
    if (@available(iOS 13.0, *)) {
        NSString *string1 = [resource.description stringByReplacingOccurrencesOfString:@" - " withString:@" "];
        NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@": " withString:@"="];
        NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"{" withString:@""];
        NSString *string4 = [string3 stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSString *string5 = [string4 stringByReplacingOccurrencesOfString:@", " withString:@" "];
        resourceArray = [NSMutableArray arrayWithArray:[string5 componentsSeparatedByString:@" "]];
        [resourceArray removeObjectAtIndex:0];
        [resourceArray removeObjectAtIndex:0];
    }else {
        NSString *string1 = [resource.description stringByReplacingOccurrencesOfString:@"{" withString:@""];
        NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@", " withString:@","];
        resourceArray = [NSMutableArray arrayWithArray:[string3 componentsSeparatedByString:@" "]];
        [resourceArray removeObjectAtIndex:0];
        [resourceArray removeObjectAtIndex:0];
    }
    NSMutableDictionary *videoInfo = [[NSMutableDictionary alloc] init];
    for (NSString *string in resourceArray) {
        NSArray *array = [string componentsSeparatedByString:@"="];
        videoInfo[array[0]] = array[1];
    }
    videoInfo[@"duration"] = @(asset.duration).description;
    return videoInfo;
}

@end
