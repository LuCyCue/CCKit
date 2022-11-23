//
//  CCGCDTimer.h
//  Pods
//
//  Created by Lucc on 2022/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCGCDTimer : NSObject

/// 创建定时器
/// @param timeInterval 定时器回调间隔（单位：毫秒）
/// @param repeats 是否循环
/// @param handler 定时事件回调
/// @discussion 回调在分线程，如果有刷新UI逻辑，需要自己回调到主线程
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats handler:(void(^)(void))handler;

/// 启动定时器
- (void)fire;

/// 销毁定时器
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
