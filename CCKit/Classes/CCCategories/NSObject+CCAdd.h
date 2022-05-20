//
//  NSObject+CCAdd.h
//  Pods
//
//  Created by lucc on 2022/3/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CCAdd)

/// 交互实例方法
/// @param originalSel 被替换的SEL
/// @param newSel 新的SEL
+ (BOOL)cc_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/// 交互类方法
/// @param originalSel 被替换的SEL
/// @param newSel 新的SEL
+ (BOOL)cc_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

/// 获取类的所有实例方法
+ (NSArray<NSString *> *)cc_getMethodNames;

/// 获取类的所有类方法（不显示父类）
+ (NSArray<NSString *> *)cc_getStaticMethodNames;

/// 获取类的是有成员变量
+ (NSArray<NSString *> *)cc_getAllIVars;

/// 在主线程执行代码块
/// @param block 代码块
/// @discussion 会先判断当前线程是否为主线程，是的话直接执行。不是的话，则会异步添加到主线程
+ (void)cc_runInMainThread:(dispatch_block_t)block;

/// 在新的线程异步执行代码块
/// @param block 代码块
+ (void)cc_runInNewThread:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
