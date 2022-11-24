//
//  CCAlert.m
//  LCCKit
//
//  Created by lucc on 2022/6/13.
//

#import "CCAlert.h"

static NSMutableArray *_showingAlerters = nil;

@implementation CCAlert

+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _showingAlerters = [NSMutableArray array];
    });
}

#pragma mark - Public

+ (CCAlertView *)alertCustomView:(UIView *)customView {
    return [self alertCustomView:customView configuration:CCAlertConfiguration.new];
}

+ (CCAlertView *)alertCustomView:(UIView *)customView configuration:(CCAlertConfiguration *)configuration {
    return [self alertCustomView:customView superView:nil configuration:configuration];
}

+ (CCAlertView *)alertCustomView:(UIView *)customView superView:(UIView *_Nullable)superView configuration:(CCAlertConfiguration *)configuration {
    //去重
    if (configuration.alertId != 0) {
        for (CCAlertView *view in _showingAlerters) {
            if (view.configuration.alertId == configuration.alertId) {
                return view;
            }
        }
    }
    if (!superView) {
        superView = [self getKeyWindow];
    }
    configuration.superView = superView;
    CCAlertView *alertView = [[CCAlertView alloc] initWithFrame:superView.bounds configuration:configuration];
    alertView.customView = customView;
    alertView.viewDidDisappearHandler = ^(CCAlertView *alertView){
        [_showingAlerters removeObject:alertView];
    };
    alertView.viewDidAppearHandler = ^(CCAlertView * _Nonnull alertView) {
        [_showingAlerters addObject:alertView];
    };
    [superView addSubview:alertView];
    [alertView show];
    return alertView;
}

/// 清除所有弹窗
+ (void)clearAll {
    [_showingAlerters enumerateObjectsUsingBlock:^(CCAlertView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj hide];
    }];
    [_showingAlerters removeAllObjects];
}

/// 获取指定id的alertView
+ (CCAlertView *)getAlertView:(int64_t)alertId {
    __block CCAlertView *alertView = nil;
    [_showingAlerters enumerateObjectsUsingBlock:^(CCAlertView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.configuration.alertId == alertId) {
            alertView = obj;
            *stop = YES;
        }
    }];
    return alertView;
}

#pragma mark - Private

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
