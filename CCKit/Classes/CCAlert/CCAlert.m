//
//  CCAlert.m
//  LCCKit
//
//  Created by lucc on 2022/6/13.
//

#import "CCAlert.h"

@implementation CCAlert

+ (CCAlertView *)alertCustomView:(UIView *)customView {
    return [self alertCustomView:customView configuration:CCAlertConfiguration.new];
}

+ (CCAlertView *)alertCustomView:(UIView *)customView configuration:(CCAlertConfiguration *)configuration {
    return [self alertCustomView:customView superView:nil configuration:configuration];
}

+ (CCAlertView *)alertCustomView:(UIView *)customView superView:(UIView *_Nullable)superView configuration:(CCAlertConfiguration *)configuration {
    if (!superView) {
        superView = [self getKeyWindow];
    }
    configuration.superView = superView;
    CCAlertView *alertView = [[CCAlertView alloc] initWithFrame:superView.bounds configuration:configuration];
    alertView.customView = customView;
    [superView addSubview:alertView];
    [alertView show];
    return alertView;
}

/// 获取keywindow
+ (UIWindow *)getKeyWindow {
    UIWindow *keyWindow = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        keyWindow = [[UIApplication sharedApplication].delegate window];
    } else {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if (!window.hidden) {
                keyWindow = window;
                break;
            }
        }
    }
    return keyWindow;
}

@end
