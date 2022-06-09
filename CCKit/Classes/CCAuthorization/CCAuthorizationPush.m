//
//  CCAuthorizationPush.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorizationPush.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@implementation CCAuthorizationPush

+ (BOOL)authorized {
    return [self authorizationStatus] >= 2;
}

+ (CCAuthorizationPushStatus)authorizationStatus {
    if (@available(iOS 10.0, *)) {
        dispatch_semaphore_t sem = dispatch_semaphore_create(0); // 创建信号量
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        __block UNAuthorizationStatus authorizationStatus;
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            authorizationStatus = settings.authorizationStatus;
            dispatch_semaphore_signal(sem); // 发送信号量
        }];
        dispatch_semaphore_wait(sem , DISPATCH_TIME_FOREVER); // 等待信号量
        return (CCAuthorizationPushStatus)authorizationStatus;
        
    } else {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            NSString *preRequest = [[NSUserDefaults standardUserDefaults] valueForKey:@"CCAuthorizationPush"];
            if (preRequest) {
                return CCAuthorizationPushStatusDenied;
            }
            return CCAuthorizationPushStatusNotDetermined;
        }
        return CCAuthorizationPushStatusAuthorized;
    }
    return CCAuthorizationPushStatusNotDetermined;
}

+ (void)authorizeWithCompletion:(CCAuthorizationHandler)completion {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        BOOL firstTime = [self authorizationStatus] == CCAuthorizationPushStatusNotDetermined;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(granted,firstTime);
            });
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] registerForRemoteNotifications];
                        });
                    }
                }];
            }
        }];
    } else {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            NSString *preRequest = [[NSUserDefaults standardUserDefaults]valueForKey:@"CCAuthorizationPush"];
            if (preRequest) {
                completion(NO,NO);
                return;
            }
        }
        //request
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"requested" forKey:@"CCAuthorizationPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
