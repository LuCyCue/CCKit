//
//  CCMediaFormatFactory.h
//  LCCKit
//
//  Created by lucc on 2022/4/22.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "CCMediaFormatDefine.h"
#import "CCPDFConvertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCMediaFormatFactory : NSObject

#pragma mark - 视频->GIF

/// 视频转成gif
/// @param videoUrl 视频地址(支持NSString(仅本地路径)、NSURL)
/// @param outputUrl gif输出路径
/// @param loopCount 动画循环次数
/// @param frameRate gif帧率 （0.0-20.0）
/// @param scale 像素缩放比（0.0-1.0]
/// @param framesPerSecond 视频每秒被截取帧数
/// @param progress 进度回调(0.0-1.0)
/// @param completion 回调
+ (void)convertVideo:(id)videoUrl
               toGif:(NSString *_Nullable)outputUrl
           loopCount:(int32_t)loopCount
           frameRate:(CGFloat)frameRate
               scale:(CGFloat)scale
     framesPerSecond:(NSUInteger)framesPerSecond
            progress:(CCMediaFormatProgress)progress
          completion:(CCMediaFormatCompletion)completion;

#pragma mark - GIF->视频

/// gif 转 mp4
/// @param gif gif数据(支持:NSData、NSURL、NSString(本地路径))
/// @param outputUrl 输出mp4路径（可以传空，内部生成输出路径）
/// @param speed 视频播放速度（1和gif一致，大于1, 加快， 小于1，变慢）
/// @param size 视频宽高
/// @param repeat 获取gif图片次数
/// @param progress 进度回调
/// @param completion 回调
+ (void)convertGif:(id)gif
           toVideo:(NSString * _Nullable)outputUrl
             speed:(CGFloat)speed
              size:(CGSize)size
            repeat:(int)repeat
          progress:(CCMediaFormatProgress)progress
        completion:(CCMediaFormatCompletion)completion;

#pragma mark - GIF->图片组

/// gif -> 图片组
/// @param gif gif数据(支持:NSData、NSURL、NSString(本地路径))
/// @param error 错误
+ (NSArray<UIImage *> *)convertGifToImages:(id)gif error:(NSError *_Nullable * _Nullable)error;

#pragma mark - 视频格式转换

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
          completion:(CCMediaFormatCompletion)completion;

#pragma mark - PDF

/// office 文档格式转化为pdf
/// @param pdfConvertView pdf渲染view
/// @param outputUrl 输出文件路径（可为空）
/// @param error 错误
+ (NSString *)convertOfficeDocument:(CCPDFConvertView *)pdfConvertView
                              toPdf:(NSString * _Nullable)outputUrl
                              error:(NSError *_Nullable * _Nullable)error;

/// office 文档格式转化为图片
/// @param pdfConvertView pdf渲染view
/// @param outputUrl 输出文件路径（可为空）
/// @param error 错误
+ (NSString *)convertOfficeDocument:(CCPDFConvertView *)pdfConvertView
                            toImage:(NSString * _Nullable)outputUrl
                              error:(NSError *_Nullable * _Nullable)error;

/// 图片数组转换为pdf格式
/// @param images 图片数组
/// @param outputUrl 输出路径（可为空）
/// @param error 错误信息
+ (NSString *)convertImages:(NSArray<UIImage *> *)images
                      toPdf:(NSString * _Nullable)outputUrl
                      error:(NSError *_Nullable * _Nullable)error;

@end


API_AVAILABLE_BEGIN(macos(10.15), ios(9.1), tvos(10))

@interface CCMediaFormatFactory (LivePhoto)

/// live photo 转为静态图
/// @param livePhoto livepho
/// @param outputUrl static photo output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
           toStaticPhoto:(NSString * _Nullable)outputUrl
              completion:(CCMediaFormatCompletion)completion;

/// live photo 转为MOV视频
/// @param livePhoto live photo
/// @param outputUrl video output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                 toVideo:(NSString * _Nullable)outputUrl
              completion:(CCMediaFormatCompletion)completion;

/// live photo 转成 mp4
/// @param livePhoto 实况图片实例
/// @param outputUrl 输出路径
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                   toMP4:(NSString * _Nullable)outputUrl
              completion:(CCMediaFormatCompletion)completion;

/// live photo 转成 gif
/// @param livePhoto live photo 实例
/// @param outputUrl gif输出路径
/// @param scale 像素缩放比（0.0-1.0）
/// @param framesPerSecond 视频每秒被截取帧数
/// @param frameRate gif帧率
/// @param progress 进度回调
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto
                   toGif:(NSString * _Nullable)outputUrl
                   scale:(CGFloat)scale
         framesPerSecond:(NSUInteger)framesPerSecond
               frameRate:(CGFloat)frameRate
                progress:(CCMediaFormatProgress)progress
              completion:(CCMediaFormatCompletion)completion;

@end

API_AVAILABLE_END


NS_ASSUME_NONNULL_END
