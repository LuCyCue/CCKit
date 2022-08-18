//
//  CCFileTool.m
//  Pods
//
//  Created by lucc on 2022/2/26.
//

#import "CCFileTool.h"

@implementation CCFileTool

/// 获取某个模块下的bundle
/// @param moduleName 模块名称
/// @param currentClass 定义在模块中的class
+ (NSBundle *)bundleWithModuleName:(NSString *)moduleName currentClass:(Class)currentClass {
    NSBundle *bundle = [NSBundle bundleForClass:currentClass];
    NSURL *url = [bundle URLForResource:moduleName withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

/// 从PHAsset读取图片写入沙盒
/// @param asset PHAsset实例
/// @param path 沙盒路径
/// @param completion 回调
/// @discussion iclound上的PHAsset不支持
+ (void)writeImageWithAsset:(PHAsset *)asset targetPath:(NSString *)path completion:(void (^)(NSString *, UIImage *, NSData *, NSError *))completion {
    if (!asset || path.length == 0 || asset.mediaType != PHAssetMediaTypeImage) {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: @"输入参数错误"};
        !completion ?: completion(nil, nil, nil, [[NSError alloc] initWithDomain:@"com.lcckit.filetool" code:500 userInfo:userInfo]);
        return;
    }
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    PHAssetResourceRequestOptions *resourceOptions = [PHAssetResourceRequestOptions new];
    resourceOptions.networkAccessAllowed = YES;
    for (PHAssetResource *assetRes in assetResources) {
       if (assetRes.type == PHAssetResourceTypePhoto) {
           resource = assetRes;
       }
    }
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        NSError *error;
        UIImage *img = [UIImage imageWithData:imageData];
        NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
        [imgData writeToFile:path options:NSDataWritingAtomic error:&error];
        if (completion) {
            completion(path, img, imgData, error);
        }
    }];
}

/// 获取某一条文件路径的文件大小
/// @param path 路径
+ (NSInteger)getFileSizeWithPath:(NSString *)path {
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    NSInteger fileSize = 0;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            //文件夹
            NSArray *dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString *subPath = nil;
            for(NSString *str in dirArray) {
                subPath = [path stringByAppendingPathComponent:str];
                fileSize += [self getFileSizeWithPath:subPath];
            }
        } else {
            //文件
            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            NSInteger size = [dict[@"NSFileSize"] integerValue];
            fileSize = size;
        }
    }
    return fileSize;
}

/// 遍历某个文件夹文件名（不做递归处理）
+ (NSArray *_Nullable)listFileNamesWithDirPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isExist && isDir) {
        NSArray *filePaths = [fileManager contentsOfDirectoryAtPath:path error:nil];
        NSMutableArray *retArray = [NSMutableArray array];
        for (NSString *fp in filePaths) {
            NSString *name = [fp lastPathComponent];
            if (name.length) {
                [retArray addObject:name];
            }
        }
        return retArray;
    }
    return nil;
}

#pragma mark - Get Video

/// 获取视频
/// @param asset PHAsset
/// @param completion 成功回调
+ (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *, NSDictionary *))completion {
    [self getVideoWithAsset:asset progressHandler:nil completion:completion];
}

/// 通过PHAsset获取视频
/// @param asset phasset
/// @param progressHandler 进度回调
/// @param completion 成功回调
+ (void)getVideoWithAsset:(PHAsset *)asset
          progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
               completion:(void (^)(AVPlayerItem *, NSDictionary *))completion {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !progressHandler ?: progressHandler(progress, error, stop, info);
        });
    };
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        !completion ?: completion(playerItem, info);
    }];
}

/// 通过PHAsset获取视频URL
/// @param asset PHAsset
/// @param success 成功回调
/// @param failure 失败回调
+ (void)requestVideoURLWithAsset:(PHAsset *)asset
                         success:(void (^)(NSURL *videoURL))success
                         failure:(void (^)(NSDictionary* info))failure {
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                    options:[self getVideoRequestOptions]
                                              resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info) {
        if ([avasset isKindOfClass:[AVURLAsset class]]) {
            NSURL *url = [(AVURLAsset *)avasset URL];
            if (success) {
                success(url);
            }
        } else if (failure) {
            failure(info);
        }
    }];
}

#pragma mark - Export video

/// 从PHAsset中导出视频
/// @param asset PHAsset
/// @param outputPath 导出路径
/// @param success 成功回调
/// @param failure 失败回调
+ (void)exportVideoWithAsset:(PHAsset *)asset
                  outputPath:(NSString *)outputPath
                     success:(void (^)(NSString *outputPath))success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    [self exportVideoWithAsset:asset presetName:AVAssetExportPresetMediumQuality outputPath:outputPath success:success failure:failure];
}

/// 从PHAsset中导出视频
/// @param asset PHAsset
/// @param presetName 导出视频质量参数，默认为AVAssetExportPresetMediumQuality
/// @param outputPath 导出路径
/// @param success 成功回调
/// @param failure 失败回调
+ (void)exportVideoWithAsset:(PHAsset *)asset
                 presetName:(NSString *)presetName
                 outputPath:(NSString *)outputPath
                    success:(void (^)(NSString *outputPath))success
                    failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    [self exportVideoWithAsset:asset presetName:presetName timeRange:kCMTimeRangeZero outputPath:outputPath success:success failure:failure];
}

/// 从PHAsset中导出视频
/// @param asset PHAsset
/// @param presetName 导出视频质量参数，默认为AVAssetExportPresetMediumQuality
/// @param timeRange 视频导出的时间范围，导出整个视频传kCMTimeRangeZero
/// @param outputPath 导出路径
/// @param success 成功回调
/// @param failure 失败回调
+ (void)exportVideoWithAsset:(PHAsset *)asset
                  presetName:(NSString *)presetName
                   timeRange:(CMTimeRange)timeRange
                  outputPath:(NSString *)outputPath
                     success:(void (^)(NSString *outputPath))success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    if (@available(iOS 14.0, *)) {
        [self requestVideoOutputPathWithAsset:asset presetName:presetName timeRange:timeRange outputPath:outputPath success:success failure:failure];
        return;
    }
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:[self getVideoRequestOptions] resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        [self startExportVideoWithVideoAsset:videoAsset timeRange:timeRange presetName:presetName outputPath:outputPath success:success failure:failure];
    }];
}

/// 导出视频（适用iOS14以下）
+ (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset
                             timeRange:(CMTimeRange)timeRange
                            presetName:(NSString *)presetName
                            outputPath:(NSString *)outputPath
                               success:(void (^)(NSString *outputPath))success
                               failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    if (!presetName) {
        presetName = AVAssetExportPresetMediumQuality;
    }
    if (!outputPath) {
        outputPath = [self getVideoOutputPath];
    }
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];
        session.shouldOptimizeForNetworkUse = true;
        if (!CMTimeRangeEqual(timeRange, kCMTimeRangeZero)) {
            session.timeRange = timeRange;
        }
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            !failure ?: failure(@"该视频类型暂不支持导出", nil);
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
            if (videoAsset.URL && videoAsset.URL.lastPathComponent) {
                outputPath = [outputPath stringByReplacingOccurrencesOfString:@".mp4" withString:[NSString stringWithFormat:@"-%@", videoAsset.URL.lastPathComponent]];
            }
        }
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        
        AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
        if (videoComposition.renderSize.width) {
            // 修正视频转向
            session.videoComposition = videoComposition;
        }
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            [self handleVideoExportResult:session outputPath:outputPath success:success failure:failure];
        }];
    } else {
        if (failure) {
            NSString *errorMessage = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            failure(errorMessage, nil);
        }
    }
}

/// 导出视频（适用iOS14及以上）
+ (void)requestVideoOutputPathWithAsset:(PHAsset *)asset
                             presetName:(NSString *)presetName
                              timeRange:(CMTimeRange)timeRange
                             outputPath:(NSString *)outputPath
                                success:(void (^)(NSString *outputPath))success
                                failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    if (!presetName) {
        presetName = AVAssetExportPresetMediumQuality;
    }
    if (!outputPath) {
        outputPath = [self getVideoOutputPath];
    }
    [[PHImageManager defaultManager] requestExportSessionForVideo:asset
                                                          options:[self getVideoRequestOptions]
                                                     exportPreset:presetName
                                                    resultHandler:^(AVAssetExportSession *_Nullable exportSession, NSDictionary *_Nullable info) {
        exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
        exportSession.shouldOptimizeForNetworkUse = NO;
        exportSession.outputFileType = AVFileTypeMPEG4;
        if (!CMTimeRangeEqual(timeRange, kCMTimeRangeZero)) {
            exportSession.timeRange = timeRange;
        }
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            [self handleVideoExportResult:exportSession outputPath:outputPath success:success failure:failure];
        }];
    }];
}

+ (void)handleVideoExportResult:(AVAssetExportSession *)session outputPath:(NSString *)outputPath success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (session.status) {
            case AVAssetExportSessionStatusUnknown: {
                NSLog(@"AVAssetExportSessionStatusUnknown");
            }
                break;
            case AVAssetExportSessionStatusWaiting: {
                NSLog(@"AVAssetExportSessionStatusWaiting");
            }
                break;
            case AVAssetExportSessionStatusExporting: {
                NSLog(@"AVAssetExportSessionStatusExporting");
            }
                break;
            case AVAssetExportSessionStatusCompleted: {
                NSLog(@"AVAssetExportSessionStatusCompleted");
                !success ?: success(outputPath);
            }
                break;
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"AVAssetExportSessionStatusFailed");
                !failure ?: failure(@"视频导出失败", session.error);
            }
                break;
            case AVAssetExportSessionStatusCancelled: {
                NSLog(@"AVAssetExportSessionStatusCancelled");
                !failure ?: failure(@"导出任务已被取消", nil);
            }
                break;
            default:
                break;
        }
    });
}

+ (PHVideoRequestOptions *)getVideoRequestOptions {
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    return options;
}

+ (NSString *)getVideoOutputPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/video-%@-%d.mp4", [formater stringFromDate:[NSDate date]], arc4random_uniform(10000000)];
    return outputPath;
}

/// 获取优化后的视频转向信息
+ (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

/// 获取视频角度
+ (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end
