//
//  CCTimer.h
//  Pods
//
//  Created by Lucc on 2022/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCTimer : NSObject

/// 创建定时器，并自动加入到当前的runloop中
/// @param timerInterval 定时器执行间隔
/// @param target target
/// @param aSelector 方法
/// @param userInfo 自定义参数
/// @param yesOrNo 是否开启循环
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timerInterval target:(id)target selector:(nonnull SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

/// 创建定时器
/// @param timerInterval 定时器执行间隔
/// @param target target
/// @param aSelector 方法
/// @param userInfo 自定义参数
/// @param yesOrNo 是否开启循环
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timerInterval target:(id)target selector:(nonnull SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

/// 添加定时器到runloop中
/// @param mode runloop模式
/// @param onNewThread 是否加入到新的线程
- (void)addToRunLoop:(NSRunLoopMode)mode onNewThread:(BOOL)onNewThread;

/// 销毁定时器
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
