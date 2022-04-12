//
//  CCFileTool.h
//  Pods
//
//  Created by lucc on 2022/2/26.
//

#import <Foundation/Foundation.h>
#import <Photos/photos.h>

@interface CCFileTool : NSObject

/// 获取某个模块下的bundle
/// @param moduleName 模块名称
/// @param currentClass 定义在模块中的class
+ (NSBundle *)bundleWithModuleName:(NSString *)moduleName currentClass:(Class)currentClass;

/// 从PHAsset读取图片写入沙盒
/// @param asset PHAsset实例
/// @param path 沙盒路径
/// @param completion 回调
/// @discussion iclound上的PHAsset不支持
+ (void)writeImageWithAsset:(PHAsset *)asset
                 targetPath:(NSString *)path
                 completion:(void (^)(NSString *, UIImage *, NSData *, NSError *))completion;

/// 获取某一条文件路径的文件大小(单位 byte)
/// @param path 路径
+ (NSInteger)getFileSizeWithPath:(NSString *)path;

#pragma mark - Get Video

/// 获取视频
/// @param asset PHAsset
/// @param completion 成功回调
+ (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *, NSDictionary *))completion;

/// 通过PHAsset获取视频
/// @param asset phasset
/// @param progressHandler 进度回调
/// @param completion 成功回调
+ (void)getVideoWithAsset:(PHAsset *)asset
          progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler
               completion:(void (^)(AVPlayerItem *, NSDictionary *))completion;

/// 通过PHAsset获取视频URL
/// @param asset PHAsset
/// @param success 成功回调
/// @param failure 失败回调
+ (void)requestVideoURLWithAsset:(PHAsset *)asset
                         success:(void (^)(NSURL *videoURL))success
                         failure:(void (^)(NSDictionary* info))failure;

#pragma mark - Export Video

/// 从PHAsset中导出视频
/// @param asset PHAsset
/// @param outputPath 导出路径(可以为空)
/// @param success 成功回调
/// @param failure 失败回调
+ (void)exportVideoWithAsset:(PHAsset *)asset
                  outputPath:(NSString *)outputPath
                     success:(void (^)(NSString *outputPath))success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure;

/// 从PHAsset中导出视频
/// @param asset PHAsset
/// @param presetName 导出视频质量参数，默认为AVAssetExportPresetMediumQuality
/// @param outputPath 导出路径(可以为空)
/// @param success 成功回调
/// @param failure 失败回调
+ (void)exportVideoWithAsset:(PHAsset *)asset
                  presetName:(NSString *)presetName
                  outputPath:(NSString *)outputPath
                     success:(void (^)(NSString *outputPath))success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure;

/// 从PHAsset中导出视频
/// @param asset PHAsset
/// @param presetName 导出视频质量参数，默认为AVAssetExportPresetMediumQuality
/// @param timeRange 视频导出的时间范围，导出整个视频传kCMTimeRangeZero
/// @param outputPath 导出路径(可以为空)
/// @param success 成功回调
/// @param failure 失败回调
+ (void)exportVideoWithAsset:(PHAsset *)asset
                  presetName:(NSString *)presetName
                   timeRange:(CMTimeRange)timeRange
                  outputPath:(NSString *)outputPath
                     success:(void (^)(NSString *outputPath))success
                     failure:(void (^)(NSString *errorMessage, NSError *error))failure;

@end

