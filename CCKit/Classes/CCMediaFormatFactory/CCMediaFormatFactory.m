//
//  CCMediaFormatFactory.m
//  LCCKit
//
//  Created by lucc on 2022/4/22.
//

#import "CCMediaFormatFactory.h"
#import "CCGIF.h"
#import <objc/runtime.h>

@implementation CCMediaFormatFactory

/// 视频转成gif
/// @param videoUrl 视频地址
/// @param outputUrl gif输出路径
/// @param completion 回调
+ (void)convertVideo:(NSString *)videoUrl
               toGif:(NSString *)outputUrl
          completion:(void(^)(NSString *, NSError *))completion {
    [self convertVideo:videoUrl toGif:outputUrl loopCount:0 delayTime:0 scale:1.0 framesPerSecond:4 completion:completion];
}

/// 视频转成gif
/// @param videoUrl 视频地址
/// @param outputUrl gif输出路径
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 帧率
/// @param completion 回调
+ (void)convertVideo:(NSString *)videoUrl
               toGif:(NSString *)outputUrl
               scale:(CGFloat)scale
     framesPerSecond:(NSUInteger)framesPerSecond
          completion:(void(^)(NSString *, NSError *))completion {
    [self convertVideo:videoUrl toGif:outputUrl loopCount:0 delayTime:0 scale:scale framesPerSecond:framesPerSecond completion:completion];
}

/// 视频转成gif
/// @param videoUrl 视频地址
/// @param outputUrl gif输出路径
/// @param loopCount 动画循环次数
/// @param delayTime 帧间隔延迟
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 帧率
/// @param completion 回调
+ (void)convertVideo:(NSString *)videoUrl
               toGif:(NSString *)outputUrl
           loopCount:(int32_t)loopCount
           delayTime:(CGFloat)delayTime
               scale:(CGFloat)scale
     framesPerSecond:(NSUInteger)framesPerSecond
          completion:(void(^)(NSString *, NSError *))completion {
    if (videoUrl.length == 0) {
        !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        return;
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoUrl]];
    CCGIF *gif = [[CCGIF alloc] init];
    gif.outputUrl = outputUrl;
    gif.loopCount = loopCount;
    gif.delayTime = delayTime;
    gif.scale = scale;
    gif.framesPerSecond = framesPerSecond;
    __weak typeof(self) weakSelf = self;
    __weak typeof(gif) weakGif = gif;
    gif.completionHandler = ^(NSString * _Nullable outputUrl, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(outputUrl, error);
        });
        objc_setAssociatedObject(weakSelf, &weakGif, nil, OBJC_ASSOCIATION_RETAIN);
    };
    [gif createFileWithAVAsset:asset];
    objc_setAssociatedObject(self, &gif, gif, OBJC_ASSOCIATION_RETAIN);
}

@end


@implementation CCMediaFormatFactory(LivePhoto)

/// live photo convert to static photo
/// @param livePhoto livepho
/// @param outputUrl static photo output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toStaticPhoto:(NSString *)outputUrl completion:(void(^)(NSString *, NSError *))completion {
    if (!livePhoto || outputUrl.length == 0) {
        !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        return;
    }
    NSArray *resourceArray = [PHAssetResource assetResourcesForLivePhoto:livePhoto];
    PHAssetResourceManager *resourceManager = [PHAssetResourceManager defaultManager];
    PHAssetResource *assetResource = resourceArray[0];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:outputUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputUrl error:nil];
    }
    [resourceManager writeDataForAssetResource:assetResource toFile:[NSURL URLWithString:outputUrl] options:nil completionHandler:^(NSError * _Nullable error) {
        !completion ?: completion(error ? nil : outputUrl, error);
    }];
}

/// live photo convert to video
/// @param livePhoto live photo
/// @param outputUrl video output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toVideo:(NSString *)outputUrl completion:(void(^)(NSString *, NSError *))completion {
    if (!livePhoto || outputUrl.length == 0) {
        !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        return;
    }
    NSArray *resourceArray = [PHAssetResource assetResourcesForLivePhoto:livePhoto];
    PHAssetResourceManager *resourceManager = [PHAssetResourceManager defaultManager];
    PHAssetResource *assetResource = resourceArray[1];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:outputUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputUrl error:nil];
    }
    [resourceManager writeDataForAssetResource:assetResource toFile:[NSURL URLWithString:outputUrl] options:nil completionHandler:^(NSError * _Nullable error) {
        !completion ?: completion(error ? nil : outputUrl, error);
    }];
}

/// live photo 转成 gif
/// @param livePhoto live photo 实例
/// @param outputUrl gif输出路径
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toGif:(NSString *)outputUrl completion:(void(^)(NSString *, NSError *))completion {
    if (!livePhoto || outputUrl.length == 0) {
        !completion ?: completion(nil, [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}]);
        return;
    }
    NSString *videoTmpUrl = @"";
    [self convertLivePhoto:livePhoto toVideo:videoTmpUrl completion:^(NSString * _Nonnull videoUrl, NSError * _Nonnull error) {
        if (error) {
            !completion ?: completion(videoUrl, error);
            return;
        }
        [self convertVideo:videoUrl toGif:outputUrl completion:completion];
    }];
}


@end
