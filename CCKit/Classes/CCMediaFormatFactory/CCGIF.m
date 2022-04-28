//
//  CCGIF.m
//  LCCKit
//
//  Created by lucc on 2022/4/22.
//

#import "CCGIF.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>

#define timeScale @(600)
#define tolerance    @(0.01)

@implementation CCGIF

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loopCount = 0;
        self.delayTime = 0;
        self.scale = 1.0;
        self.framesPerSecond = 10;
    }
    return self;
}

/// 视频生成gif
- (void)createFileWithAVAsset:(AVURLAsset *)asset {
    if (!asset || asset.duration.value == 0) {
        !self.completionHandler ?: self.completionHandler(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:503 userInfo:@{NSLocalizedDescriptionKey:@"input AVURLAsset invalid"}]);
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 视频时长
        float videoLength = (float)asset.duration.value / asset.duration.timescale;
        // 生成总帧数
        int frameCount = videoLength * self.framesPerSecond;
        // 取图片帧时，时间间隔（单位秒）
        float increment = (float)videoLength / frameCount;
        // Add frames to the buffer 将需要导出的帧对应的时间点，添加到数组中
        NSMutableArray *timePoints = [NSMutableArray array];
        for (int currentFrame = 0; currentFrame < frameCount; currentFrame++) {
            float seconds = (float)increment * currentFrame;
            CMTime time = CMTimeMakeWithSeconds(seconds, [timeScale intValue]);
            [timePoints addObject:[NSValue valueWithCMTime:time]];
        }
        //创建
        [self createForTimePoints:timePoints fromAVURLAsset:asset frameCount:frameCount];
    });
}

- (void)createForTimePoints:(NSArray *)timePoints fromAVURLAsset:(AVURLAsset *)asset frameCount:(int)frameCount {
    NSDictionary *fileProperties = [self fileProperties];
    NSDictionary *frameProperties = [self frameProperties];
    NSURL *fileUrl = [NSURL fileURLWithPath:self.outputUrl];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileUrl, kUTTypeGIF , frameCount, NULL);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime tol = CMTimeMakeWithSeconds([tolerance floatValue], [timeScale intValue]);
    generator.requestedTimeToleranceBefore = tol;
    generator.requestedTimeToleranceAfter = tol;
    
    NSError *error = nil;
    CGImageRef previousImageRefCopy = nil;
    CGFloat progress = 1.0;
    for (NSValue *time in timePoints) {
        CGImageRef imageRef = self.scale < 1 ? ImageWithScale([generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error], self.scale) : [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
        if (error) {
            NSLog(@"Error copying image: %@", error);
        }
        if (imageRef) {
            CGImageRelease(previousImageRefCopy);
            previousImageRefCopy = CGImageCreateCopy(imageRef);
        } else if (previousImageRefCopy) {
            imageRef = CGImageCreateCopy(previousImageRefCopy);
        } else {
            NSLog(@"Error copying image and no previous frames to duplicate");
            !self.completionHandler ?: self.completionHandler(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:501 userInfo:@{NSLocalizedDescriptionKey:@"Error copying image and no previous frames to duplicate"}]);
            return;
        }
        CGImageDestinationAddImage(destination, imageRef, (CFDictionaryRef)frameProperties);
        CGImageRelease(imageRef);
        !self.progressHandler ?: self.progressHandler(progress / (frameCount+1));
        progress += 1;
    }
    CGImageRelease(previousImageRefCopy);
    
//    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    // Finalize the GIF
    if (!CGImageDestinationFinalize(destination)) {
        NSString *errStr = [NSString stringWithFormat:@"Failed to finalize GIF destination: %@", error];
        !self.completionHandler ?: self.completionHandler(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:502 userInfo:@{NSLocalizedDescriptionKey: errStr}]);
        return;
    }
    CFRelease(destination);
    !self.progressHandler ?: self.progressHandler(1.0);
    !self.completionHandler ?: self.completionHandler(self.outputUrl, nil);
}

/// 等比缩放图片
CGImageRef ImageWithScale(CGImageRef imageRef, float scale) {
    
    CGSize newSize = CGSizeMake(CGImageGetWidth(imageRef)*scale, CGImageGetHeight(imageRef)*scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    //Release old image
    CFRelease(imageRef);
    // Get the resized image from the context and a UIImage
    imageRef = CGBitmapContextCreateImage(context);
    
    UIGraphicsEndImageContext();
    return imageRef;
}

- (NSDictionary *)fileProperties {
    return @{(NSString *)kCGImagePropertyGIFDictionary:
                @{(NSString *)kCGImagePropertyGIFLoopCount: @(self.loopCount)}
             };
}

- (NSDictionary *)frameProperties {
    return @{(NSString *)kCGImagePropertyGIFDictionary:
                @{(NSString *)kCGImagePropertyGIFDelayTime: @(self.delayTime)},
                (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB
            };
}

@end
