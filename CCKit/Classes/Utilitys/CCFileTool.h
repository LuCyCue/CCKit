//
//  CCFileTool.h
//  Pods
//
//  Created by HuanZheng on 2022/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFileTool : NSObject

/// 获取某个模块下的bundle
/// @param moduleName 模块名称
/// @param currentClass 定义在模块中的class
+ (NSBundle *)bundleWithModuleName:(NSString *)moduleName currentClass:(Class)currentClass;

@end

NS_ASSUME_NONNULL_END
