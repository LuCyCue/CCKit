//
//  NSObject+notification.m
//  OCTest
//
//  Created by lucc on 2019/6/27.
//  Copyright © 2019年 lucc. All rights reserved.
//

#import "NSObject+CCNotification.h"
#import "NSObject+CCDealloc.h"
#import <objc/runtime.h>

@implementation NSObject (CCNotification)

- (void)cc_addNotificationObserveName:(NSString *)name selector:(SEL)selector object:(id)object {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:object];
    if ([self _ifAddDeallocForNotification]) {
        return;
    }
    [self cc_addDeallocBlock:^(id owner) {
        [[NSNotificationCenter defaultCenter] removeObserver:owner];
        NSLog(@"notification remove success");
    }];
}

- (void)cc_addNotificationObserveName:(NSString *)name object:(id)object onMainThreadUsingBlock:(void(^)(NSNotification *))block {
    [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:[NSOperationQueue mainQueue] usingBlock:block];
    if ([self _ifAddDeallocForNotification]) {
        return;
    }
    [self cc_addDeallocBlock:^(id owner) {
        [[NSNotificationCenter defaultCenter] removeObserver:owner name:name object:object];
        NSLog(@"notification remove success");
    }];
}

- (BOOL)_ifAddDeallocForNotification {
    NSNumber *ret = objc_getAssociatedObject(self, _cmd);
    if (ret.boolValue) {
        return YES;
    }
    objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return NO;
}

@end
