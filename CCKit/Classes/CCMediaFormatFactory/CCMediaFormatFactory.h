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
               toGif:(NSString * _Nullable)outputUrl
          completion:(void(^)(NSString *, NSError *))completion;

/// 视频转成gif
/// @param videoUrl 视频地址
/// @param outputUrl gif输出路径
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 帧率
/// @param completion 回调
+ (void)convertVideo:(NSString *)videoUrl
               toGif:(NSString * _Nullable)outputUrl
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
               toGif:(NSString * _Nullable)outputUrl
           loopCount:(int32_t)loopCount
           delayTime:(CGFloat)delayTime
               scale:(CGFloat)scale
     framesPerSecond:(NSUInteger)framesPerSecond
          completion:(void(^)(NSString *, NSError *))completion;

/// gif 转 mp4
/// @param gifData gif数据
/// @param outputUrl 输出mp4路径（可以传空，内部生成输出路径）
/// @param speed 视频播放速度（1和gif一致，大于1, 加快， 小于1，变慢）
/// @param size 视频宽高
/// @param repeat 获取gif图片次数
/// @param completion 回调
+ (void)convertGif:(NSData *)gifData
           toVideo:(NSString * _Nullable)outputUrl
             speed:(CGFloat)speed
              size:(CGSize)size
            repeat:(int)repeat
        completion:(void(^)(NSString *, NSError *))completion;

@end


API_AVAILABLE_BEGIN(macos(10.15), ios(9.1), tvos(10))

@interface CCMediaFormatFactory (LivePhoto)

/// live photo convert to static photo
/// @param livePhoto livepho
/// @param outputUrl static photo output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
           toStaticPhoto:(NSString * _Nullable)outputUrl
              completion:(void(^)(NSString *, NSError *))completion;

/// live photo convert to video
/// @param livePhoto live photo
/// @param outputUrl video output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                 toVideo:(NSString * _Nullable)outputUrl
              completion:(void(^)(NSString *, NSError *))completion;

/// live photo 转成 gif
/// @param livePhoto live photo 实例
/// @param outputUrl gif输出路径
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                   toGif:(NSString * _Nullable)outputUrl
              completion:(void(^)(NSString *, NSError *))completion;

/// live photo 转成 gif
/// @param livePhoto live photo 实例
/// @param outputUrl gif输出路径
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 帧率
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                   toGif:(NSString * _Nullable)outputUrl
                   scale:(CGFloat)scale
         framesPerSecond:(NSUInteger)framesPerSecond
              completion:(void(^)(NSString *, NSError *))completion;

@end

API_AVAILABLE_END


NS_ASSUME_NONNULL_END
