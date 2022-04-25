//
//  CCMediaFormatFactory.m
//  LCCKit
//
//  Created by lucc on 2022/4/22.
//

#import "CCMediaFormatFactory.h"
#import "CCGIF.h"
#import <objc/runtime.h>
#import "CCMediaFormatTool.h"
#import "CCVideo.h"

@implementation CCMediaFormatFactory

#pragma mark - video->gif

/// 视频转成gif
/// @param videoUrl 视频地址(支持NSString(仅本地路径)、NSURL)
/// @param outputUrl gif输出路径
/// @param completion 回调
+ (void)convertVideo:(id)videoUrl
               toGif:(NSString *)outputUrl
          completion:(void(^)(NSString *, NSError *))completion {
    [self convertVideo:videoUrl toGif:outputUrl loopCount:0 delayTime:0 scale:1.0 framesPerSecond:4 completion:completion];
}

/// 视频转成gif
/// @param videoUrl 视频地址(支持NSString(仅本地路径)、NSURL)
/// @param outputUrl gif输出路径
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 帧率
/// @param completion 回调
+ (void)convertVideo:(id)videoUrl
               toGif:(NSString *)outputUrl
               scale:(CGFloat)scale
     framesPerSecond:(NSUInteger)framesPerSecond
          completion:(void(^)(NSString *, NSError *))completion {
    [self convertVideo:videoUrl toGif:outputUrl loopCount:0 delayTime:0 scale:scale framesPerSecond:framesPerSecond completion:completion];
}

/// 视频转成gif
/// @param videoUrl 视频地址(支持NSString(仅本地路径)、NSURL)
/// @param outputUrl gif输出路径
/// @param loopCount 动画循环次数
/// @param delayTime 帧间隔延迟
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 帧率
/// @param completion 回调
+ (void)convertVideo:(id)videoUrl
               toGif:(NSString *)outputUrl
           loopCount:(int32_t)loopCount
           delayTime:(CGFloat)delayTime
               scale:(CGFloat)scale
     framesPerSecond:(NSUInteger)framesPerSecond
          completion:(void(^)(NSString *, NSError *))completion {
    AVURLAsset *asset = nil;
    BOOL inputInvalid = NO;
    if ([videoUrl isKindOfClass:NSURL.class]) {
        if (((NSURL *)videoUrl).absoluteString.length == 0) {
            inputInvalid = YES;
        } else {
            asset = [AVURLAsset assetWithURL:(NSURL *)videoUrl];
        }
    } else if ([videoUrl isKindOfClass:NSString.class]) {
        if (((NSString *)videoUrl).length == 0) {
            inputInvalid = YES;
        } else {
            BOOL ret = [NSFileManager.defaultManager fileExistsAtPath:(NSString *)videoUrl];
            if (!ret) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:408 userInfo:@{NSLocalizedDescriptionKey:@"video is not exist"}]);
                });
                return;
            }
            asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:(NSString *)videoUrl]];
        }
    } else {
        inputInvalid = YES;
    }
    if (inputInvalid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        });
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"gif"];
    }
  
    CCGIF *gif = [[CCGIF alloc] init];
    gif.outputUrl = outputUrl;
    gif.loopCount = loopCount;
    gif.delayTime = delayTime;
    gif.scale = scale;
    gif.framesPerSecond = framesPerSecond;
    gif.completionHandler = ^(NSString * _Nullable outputUrl, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(outputUrl, error);
        });
    };
    [gif createFileWithAVAsset:asset];
}

#pragma mark - gif->video

/// gif 转 mp4
/// @param gif gif数据(支持:NSData、NSURL、NSString(本地路径))
/// @param outputUrl 输出mp4路径（可以传空，内部生成输出路径）
/// @param speed 视频播放速度（1和gif一致，大于1, 加快， 小于1，变慢）
/// @param size 视频宽高
/// @param repeat 获取gif图片次数
/// @param completion 回调
+ (void)convertGif:(id)gif
           toVideo:(NSString * _Nullable)outputUrl
             speed:(CGFloat)speed
              size:(CGSize)size
            repeat:(int)repeat
        completion:(void(^)(NSString *, NSError *))completion {
    NSData *gifData = nil;
    if ([gif isKindOfClass:NSData.class]) {
        gifData = gif;
    } else if ([gif isKindOfClass:NSURL.class]) {
        gifData = [NSData dataWithContentsOfURL:(NSURL *)gif];
    } else if ([gif isKindOfClass:NSString.class]) {
        gifData = [NSData dataWithContentsOfFile:(NSString *)gif];
    }
    if (!gif) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        });
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"mp4"];
    }
    CCVideo *video = [CCVideo new];
    [video convertGIFToMP4:gifData speed:speed size:size repeat:repeat output:outputUrl completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(outputUrl, error);
        });
    }];
}

#pragma mark - Video format convert

/// 视频格式转换
/// @param srcVideo 视频数据（支持传入 PHAsset、NSURL、AVURLAsset 任意一种）
/// @param outputUrl 输出文件路径
/// @param outputFileType 输出文件格式
/// @param presetType 输出文件质量类型
/// @param completion 回调
+ (void)convertVideo:(id)srcVideo
                  to:(NSString * _Nullable)outputUrl
      outputFileType:(CCVideoFileType)outputFileType
          presetType:(CCExportPresetType)presetType
          completion:(void(^)(NSString * _Nullable, NSError * _Nullable))completion {
    if (!srcVideo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        });
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@""];
    }
    CCVideo *video = CCVideo.new;
    video.sourceVideo = srcVideo;
    video.outputUrl = outputUrl;
    video.outputFileType = outputFileType;
    video.presetType = presetType;
    video.completionHandler = ^(NSString *outputUrl, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(outputUrl, error);
        });
    };
    [video startConvertFormat];
}

@end


@implementation CCMediaFormatFactory(LivePhoto)

/// live photo convert to static photo
/// @param livePhoto livepho
/// @param outputUrl static photo output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toStaticPhoto:(NSString *)outputUrl completion:(void(^)(NSString *, NSError *))completion {
    if (!livePhoto) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        });
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"jpeg"];
    }
    NSArray *resourceArray = [PHAssetResource assetResourcesForLivePhoto:livePhoto];
    PHAssetResourceManager *resourceManager = [PHAssetResourceManager defaultManager];
    PHAssetResource *assetResource = resourceArray[0];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:outputUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputUrl error:nil];
    }
    [resourceManager writeDataForAssetResource:assetResource toFile:[[NSURL alloc] initFileURLWithPath:outputUrl] options:nil completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(error ? nil : outputUrl, error);
        });
    }];
}

/// live photo convert to video
/// @param livePhoto live photo
/// @param outputUrl video output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toVideo:(NSString *)outputUrl completion:(void(^)(NSString *, NSError *))completion {
    if (!livePhoto) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        });
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"mov"];
    }
    NSArray *resourceArray = [PHAssetResource assetResourcesForLivePhoto:livePhoto];
    PHAssetResourceManager *resourceManager = [PHAssetResourceManager defaultManager];
    PHAssetResource *assetResource = resourceArray[1];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:outputUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputUrl error:nil];
    }
    [resourceManager writeDataForAssetResource:assetResource toFile: [[NSURL alloc] initFileURLWithPath:outputUrl] options:nil completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(error ? nil : outputUrl, error);
        });
    }];
}

/// live photo 转成 gif
/// @param livePhoto live photo 实例
/// @param outputUrl gif输出路径
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toGif:(NSString *)outputUrl completion:(void(^)(NSString *, NSError *))completion {
    [self convertLivePhoto:livePhoto toGif:outputUrl scale:1.0 framesPerSecond:4 completion:completion];
}

/// live photo 转成 gif
/// @param livePhoto live photo 实例
/// @param outputUrl gif输出路径
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 帧率
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                   toGif:(NSString *)outputUrl
                   scale:(CGFloat)scale
         framesPerSecond:(NSUInteger)framesPerSecond
              completion:(void(^)(NSString *, NSError *))completion {
    if (!livePhoto) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        });
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"gif"];
    }
    NSString *videoTmpUrl = [CCMediaFormatTool randPathWithExtendName:@"mov"];
    [self convertLivePhoto:livePhoto toVideo:videoTmpUrl completion:^(NSString * _Nonnull videoUrl, NSError * _Nonnull error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(videoUrl, error);
            });
            return;
        }
        [self convertVideo:videoUrl toGif:outputUrl scale:scale framesPerSecond:framesPerSecond completion:completion];
    }];
}

@end
