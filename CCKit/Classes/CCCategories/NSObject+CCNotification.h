//
//  NSObject+notification.h
//  OCTest
//
//  Created by lucc on 2019/6/27.
//  Copyright © 2019年 lucc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CCNotification)

/// 监听通知
/// @param name 通知名称
/// @param selector 响应方法
/// @param object 通知obj
- (void)cc_addNotificationObserveName:(NSString *)name selector:(SEL)selector object:(id)object;

/// 监听通知，并且必定在主线程回调
/// @param name 通知名称
/// @param object 通知obj
/// @param block 回调
- (void)cc_addNotificationObserveName:(NSString *)name object:(id)object onMainThreadUsingBlock:(void(^)(NSNotification *))block;

@end

