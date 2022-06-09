//
//  CCAuthorizationTracking.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorizationTracking.h"
#import <AdSupport/AdSupport.h>

@implementation CCAuthorizationTracking

+ (BOOL)authorized {
    if (@available(iOS 14.0, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        return status == ATTrackingManagerAuthorizationStatusAuthorized;
#endif
    } else{
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            return YES;
        }
    }
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
+ (ATTrackingManagerAuthorizationStatus)authorizationStatus API_AVAILABLE(ios(14.0)) {
    return [ATTrackingManager trackingAuthorizationStatus];
}
#endif

+ (void)authorizeWithCompletion:(CCAuthorizationHandler)completion {
    if (@available(iOS 14.0, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        switch (status) {
            case ATTrackingManagerAuthorizationStatusNotDetermined: {
                // 未提示用户
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                            completion(YES,YES);
                        } else {
                            completion(NO,YES);
                        }
                    });
                }];
            }
                break;
            case ATTrackingManagerAuthorizationStatusRestricted:
            case ATTrackingManagerAuthorizationStatusDenied: {
                completion(NO,NO);
            }
                break;
            case ATTrackingManagerAuthorizationStatusAuthorized: {
                completion(YES,NO);
            }
                
            default:
                break;
        }
#endif
    } else {
        //iOS 14以下请求idfa权限
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            completion(YES,NO);
        } else {
            completion(NO,NO);
        }
    }
}
@end
