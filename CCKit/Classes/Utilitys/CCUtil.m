//
//  CCUtil.m
//  Pods
//
//  Created by lucc on 2022/4/2.
//

#import "CCUtil.h"

@implementation CCUtil

/// 打开应用外URL
/// @param url url
/// @param completion 回调
+ (void)openURL:(NSString *)url completion:(void (^)(BOOL success))completion {
    // 判断是否能打开URL
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    // iOS10以上 -- 使用新方法
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            if (completion) completion(success);
        }];
    } else {
        // iOS10一下 -- 使用旧方法
        BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        if (completion) completion(success);
    }
}

/// 打开app对应的设置
+ (void)openAppSetting {
    [self openURL:UIApplicationOpenSettingsURLString completion:^(BOOL success) {
        
    }];
}

/// 拨打电话
/// @param phone 电话号码
/// @param completion 回调
+ (void)makeACallWithPhoneNumber:(NSString *)phone completion:(void (^)(BOOL success))completion {
   [self openURL:[NSString stringWithFormat:@"tel:%@", phone] completion:completion];
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
