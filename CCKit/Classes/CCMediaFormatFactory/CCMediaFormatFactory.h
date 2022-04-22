//
//  CCMediaFormatFactory.h
//  LCCKit
//
//  Created by lucc on 2022/4/22.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


NS_ASSUME_NONNULL_BEGIN

@interface CCMediaFormatFactory : NSObject

/// 视频转成gif
/// @param videoUrl 视频地址
/// @param outputUrl gif输出路径
/// @param completion 回调
+ (void)convertVideo:(NSString *)videoUrl
               toGif:(NSString *)outputUrl
          completion:(void(^)(NSString *, NSError *))completion;

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
          completion:(void(^)(NSString *, NSError *))completion;

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
          completion:(void(^)(NSString *, NSError *))completion;

@end


API_AVAILABLE_BEGIN(macos(10.15), ios(9.1), tvos(10))

@interface CCMediaFormatFactory (LivePhoto)

/// live photo convert to static photo
/// @param livePhoto livepho
/// @param outputUrl static photo output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
           toStaticPhoto:(NSString *)outputUrl
              completion:(void(^)(NSString *, NSError *))completion;

/// live photo convert to video
/// @param livePhoto live photo
/// @param outputUrl video output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                 toVideo:(NSString *)outputUrl
              completion:(void(^)(NSString *, NSError *))completion;

/// live photo 转成 gif
/// @param livePhoto live photo 实例
/// @param outputUrl gif输出路径
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                   toGif:(NSString *)outputUrl
              completion:(void(^)(NSString *, NSError *))completion;

@end

API_AVAILABLE_END


NS_ASSUME_NONNULL_END
