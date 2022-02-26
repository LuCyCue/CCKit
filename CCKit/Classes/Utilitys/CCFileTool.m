//
//  CCFileTool.m
//  Pods
//
//  Created by HuanZheng on 2022/2/26.
//

#import "CCFileTool.h"

@implementation CCFileTool

/// 获取某个模块下的bundle
/// @param moduleName 模块名称
/// @param currentClass 定义在模块中的class
+ (NSBundle *)bundleWithModuleName:(NSString *)moduleName currentClass:(Class)currentClass {
    NSBundle *bundle = [NSBundle bundleForClass:currentClass];
    NSURL *url = [bundle URLForResource:moduleName withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

@end
