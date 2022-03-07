//
//  CCFileTool.h
//  Pods
//
//  Created by HuanZheng on 2022/2/26.
//

#import <Foundation/Foundation.h>

@class AVURLAsset, PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface CCFileTool : NSObject

/// 获取某个模块下的bundle
/// @param moduleName 模块名称
/// @param currentClass 定义在模块中的class
+ (NSBundle *)bundleWithModuleName:(NSString *)moduleName currentClass:(Class)currentClass;

/// 将PHAsset写入沙盒
/// @param asset PHAsset实例
/// @param path 沙盒路径
/// @param completion 回调
/// @discussion iclound上的PHAsset不支持
+ (void)writePHAsset:(PHAsset *)asset targetPath:(NSString *)path completion:(void (^)(NSString *, UIImage *, NSData *, AVURLAsset *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
