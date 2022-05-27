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
#import "CCImage.h"
#import "CCPDFConvertView+Private.h"
#import "CCPDF.h"

@implementation CCMediaFormatFactory

#pragma mark - video->gif

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
          completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
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
    CGFloat delayTime = 0;
    if (frameRate > 0) {
        delayTime = 1.0 / frameRate;
    }
    CCGIF *gif = [[CCGIF alloc] init];
    gif.outputUrl = outputUrl;
    gif.loopCount = loopCount;
    gif.delayTime = delayTime < 0.05 ? 0.051 : delayTime;
    gif.scale = scale;
    gif.framesPerSecond = framesPerSecond;
    gif.completionHandler = ^(NSString * _Nullable outputUrl, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(outputUrl, error);
        });
    };
    gif.progressHandler = ^(CGFloat p) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !progress ?: progress(p);
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
/// @param progress 进度回调
/// @param completion 回调
+ (void)convertGif:(id)gif
           toVideo:(NSString * _Nullable)outputUrl
             speed:(CGFloat)speed
              size:(CGSize)size
            repeat:(int)repeat
          progress:(CCMediaFormatProgress)progress
        completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
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
    [video convertGIFToMP4:gifData speed:speed size:size repeat:repeat output:outputUrl progress:^(CGFloat p) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !progress ?: progress(p);
        });
    } completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(outputUrl, error);
        });
    }];
}

/// gif -> 图片组
/// @param gif gif数据(支持:NSData、NSURL、NSString(本地路径))
/// @param error 错误
+ (NSArray<UIImage *> *)convertGifToImages:(id)gif error:(NSError *_Nullable * _Nullable)error {
    if (![CCMediaFormatTool checkSDKValid]) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:800 userInfo:@{NSLocalizedDescriptionKey:@"Exception error happen"}];
        return nil;
    }
    NSData *gifData = nil;
    if ([gif isKindOfClass:NSData.class]) {
        gifData = gif;
    } else if ([gif isKindOfClass:NSURL.class]) {
        gifData = [NSData dataWithContentsOfURL:(NSURL *)gif];
    } else if ([gif isKindOfClass:NSString.class]) {
        gifData = [NSData dataWithContentsOfFile:(NSString *)gif];
    }
    if (!gif) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}];
        return nil;
    }
    return [CCImage imagesFromGif:gifData];
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
          completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
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

/// office 文档格式转化为pdf
/// @param pdfConvertView pdf渲染view
/// @param outputUrl 输出文件路径（可为空）
/// @param completion 回调
+ (void)convertOfficeDocument:(CCPDFConvertView *)pdfConvertView
                        toPdf:(NSString * _Nullable)outputUrl
                   completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"pdf"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isPPT = [pdfConvertView.fileUrl.pathExtension isEqualToString:@"ppt"];
        BOOL ret = NO;
        NSError *error = nil;
        if (isPPT) {
            CGRect pageRect = CGRectMake(0, 0, 425, 340);
            ret = [pdfConvertView convertToPdf:outputUrl pageRect:pageRect pageInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        } else {
            ret = [pdfConvertView convertToPdf:outputUrl];
        }
        if (!ret) {
            error = [NSError errorWithDomain:@"cc.mediaformat.com" code:600 userInfo:@{NSLocalizedDescriptionKey:@"Source file invalid"}];
        }
        !completion ?: completion(outputUrl, error);
    });
}

/// office 文档格式转化为图片
/// @param pdfConvertView pdf渲染view
/// @param error 错误
+ (NSArray<UIImage *> * _Nullable)convertOfficeDocumentToImages:(CCPDFConvertView *)pdfConvertView
                                                          error:(NSError *_Nullable * _Nullable)error {
    if (![CCMediaFormatTool checkSDKValid]) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:800 userInfo:@{NSLocalizedDescriptionKey:@"Exception error happen"}];
        return nil;
    }
    NSString *tmpUrl = [CCMediaFormatTool randPathWithExtendName:@"pdf"];
    
    BOOL isPPT = [pdfConvertView.fileUrl.pathExtension isEqualToString:@"ppt"];
    BOOL ret = NO;
    if (isPPT) {
        CGRect pageRect = CGRectMake(0, 0, 425, 340);
        ret = [pdfConvertView convertToPdf:tmpUrl pageRect:pageRect pageInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    } else {
        ret = [pdfConvertView convertToPdf:tmpUrl];
    }
    if (!ret) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:600 userInfo:@{NSLocalizedDescriptionKey:@"Source file invalid"}];
        return nil;
    }
    NSArray<UIImage *> *imgArray = [CCImage imagesFromPdf:[NSURL fileURLWithPath:tmpUrl]];
    if (imgArray.count == 0) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:601 userInfo:@{NSLocalizedDescriptionKey:@"Generate image fail"}];
        return nil;
    }
    return imgArray;
}

/// office文档转成图片数组
/// @param pdfConvertView pdf渲染view
/// @param outputPath 输出文件夹，请确认里面没有其他图片，避免文字相同无法得到正确结果（可空）
/// @param completion 回调
+ (void)convertOfficeDocument:(CCPDFConvertView *)pdfConvertView
                     toImages:(NSString * _Nullable)outputPath
                   completion:(void(^)(NSString *_Nullable outputFolder, NSArray *_Nullable outputPaths, NSError * _Nullable error))completion {
    if (outputPath.length == 0) {
        outputPath = [CCMediaFormatTool randFolderPath];
    }
    __block NSError *error = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![CCMediaFormatTool checkSDKValid]) {
            error = [NSError errorWithDomain:@"cc.mediaformat.com" code:800 userInfo:@{NSLocalizedDescriptionKey:@"Exception error happen"}];
            !completion ?: completion(nil, nil, error);
            return;
        }
        NSString *tmpUrl = [CCMediaFormatTool randPathWithExtendName:@"pdf"];
        BOOL isPPT = [pdfConvertView.fileUrl.pathExtension isEqualToString:@"ppt"];
        BOOL ret = NO;
        if (isPPT) {
            CGRect pageRect = CGRectMake(0, 0, 425, 340);
            ret = [pdfConvertView convertToPdf:tmpUrl pageRect:pageRect pageInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        } else {
            ret = [pdfConvertView convertToPdf:tmpUrl];
        }
        if (!ret) {
            error = [NSError errorWithDomain:@"cc.mediaformat.com" code:600 userInfo:@{NSLocalizedDescriptionKey:@"Source file invalid"}];
            !completion ?: completion(nil, nil, error);
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSArray<NSString *> *imgArray = [CCImage imagesFromPdf:[NSURL fileURLWithPath:tmpUrl] outputPath:outputPath];
            if (imgArray.count == 0) {
                error = [NSError errorWithDomain:@"cc.mediaformat.com" code:601 userInfo:@{NSLocalizedDescriptionKey:@"Generate image fail"}];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(outputPath, imgArray, error);
            });
        });
    });
}

/// office 文档格式转化为单张图片
/// @param pdfConvertView pdf渲染view
/// @param error 错误
+ (UIImage * _Nullable)convertOfficeDocumentToSingleImage:(CCPDFConvertView *)pdfConvertView
                                                    error:(NSError *_Nullable * _Nullable)error {
    if (![CCMediaFormatTool checkSDKValid]) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:800 userInfo:@{NSLocalizedDescriptionKey:@"Exception error happen"}];
        return nil;
    }
    NSString *tmpUrl = [CCMediaFormatTool randPathWithExtendName:@"pdf"];
    BOOL ret = [pdfConvertView convertToPdf:tmpUrl pageRect:CGRectZero pageInset:UIEdgeInsetsZero];
    if (!ret) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:600 userInfo:@{NSLocalizedDescriptionKey:@"Source file invalid"}];
        return nil;
    }
    NSArray<UIImage *> *imgArray = [CCImage imagesFromPdf:[NSURL fileURLWithPath:tmpUrl]];
    if (imgArray.count == 0) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:601 userInfo:@{NSLocalizedDescriptionKey:@"Generate image fail"}];
        return nil;
    }
    return imgArray.firstObject;
}

/// office 文档格式转化为单张图片
/// @param pdfConvertView pdf渲染view
/// @param outputUrl 图片存储路径
/// @param completion 回调
+ (void)convertOfficeDocument:(CCPDFConvertView *)pdfConvertView
                toSingleImage:(NSString * _Nullable)outputUrl
                    comletion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
    NSString *tmpUrl = [CCMediaFormatTool randPathWithExtendName:@"pdf"];
    __block BOOL ret = [pdfConvertView convertToPdf:tmpUrl pageRect:CGRectZero pageInset:UIEdgeInsetsZero];
    if (!ret) {
        NSError *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:600 userInfo:@{NSLocalizedDescriptionKey:@"Source file invalid"}];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(nil, error);
        });
        return;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"png"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray<UIImage *> *imgArray = [CCImage imagesFromPdf:[NSURL fileURLWithPath:tmpUrl]];
        if (imgArray.count == 0) {
            NSError *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:601 userInfo:@{NSLocalizedDescriptionKey:@"Generate image fail"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(nil, error);
            });
            return;
        }
        NSData *imgData = UIImagePNGRepresentation(imgArray.firstObject);
        ret = [imgData writeToFile:outputUrl atomically:YES];
        if (!ret) {
            NSError *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:602 userInfo:@{NSLocalizedDescriptionKey:@"Output fail"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(nil, error);
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(outputUrl, nil);
        });
    });
}

/// 图片数组转换为pdf格式
/// @param images 图片数组
/// @param outputUrl 输出路径（可为空）
/// @param error 错误信息
+ (NSString *)convertImages:(NSArray<UIImage *> *)images
                      toPdf:(NSString * _Nullable)outputUrl
                      error:(NSError *_Nullable * _Nullable)error {
    if (![CCMediaFormatTool checkSDKValid]) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:800 userInfo:@{NSLocalizedDescriptionKey:@"Exception error happen"}];
        return nil;
    }
    if (images.count == 0) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:400 userInfo:@{NSLocalizedDescriptionKey:@"input invalid"}];
        return nil;
    }
    if (outputUrl.length == 0) {
        outputUrl = [CCMediaFormatTool randPathWithExtendName:@"pdf"];
    }
    BOOL ret = [CCPDF convertPDFWithImages:images outputPath:outputUrl];
    if (!ret) {
        *error = [NSError errorWithDomain:@"cc.mediaformat.com" code:600 userInfo:@{NSLocalizedDescriptionKey:@"Source file invalid"}];
    }
    return ret ? outputUrl : @"";
}


@end


@implementation CCMediaFormatFactory(LivePhoto)

/// live photo convert to static photo
/// @param livePhoto livepho
/// @param outputUrl static photo output url
/// @param completion callback
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toStaticPhoto:(NSString *)outputUrl completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
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
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toVideo:(NSString *)outputUrl completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
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

/// live photo 转成 mp4
/// @param livePhoto 实况图片实例
/// @param outputUrl 输出路径
/// @param completion 回调
+ (void)convertLivePhoto:(PHLivePhoto *)livePhoto toMP4:(NSString * _Nullable)outputUrl completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
    [self convertLivePhoto:livePhoto toVideo:nil completion:^(NSString * _Nullable url, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(nil, error);
            });
            return;
        }
        [self convertVideo:[NSURL fileURLWithPath:url] to:nil outputFileType:CCVideoFileTypeMp4 presetType:CCExportPresetTypeHighestQuality completion:completion];
    }];
}

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
              completion:(CCMediaFormatCompletion)completion {
    if (![CCMediaFormatTool checkSDKValid:completion]) {
        return;
    }
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
        [self convertVideo:videoUrl toGif:outputUrl loopCount:0 frameRate:frameRate scale:scale framesPerSecond:framesPerSecond progress:progress completion:completion];
    }];
}

@end
