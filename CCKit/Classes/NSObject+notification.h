//
//  NSObject+notification.h
//  OCTest
//
//  Created by lucc on 2019/6/27.
//  Copyright © 2019年 lucc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (notification)

- (void)cc_addNotificationObserveName:(NSString *)name selector:(SEL)selector object:(id)object;
- (void)cc_addNotificationObserveName:(NSString *)name object:(id)object onMainThreadUsingBlock:(void(^)(NSNotification *))block;

@end

