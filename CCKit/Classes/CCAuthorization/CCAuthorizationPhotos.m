//
//  CCAuthorizationPhotos.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorizationPhotos.h"
#import <Photos/Photos.h>

@implementation CCAuthorizationPhotos

+ (BOOL)authorized {
    return  [self authorizedReadWritePermission];
}

+ (CCAuthorizationPhotoStatus)authorizationStatus {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
    if (@available(iOS 14.0, *)) {
        return  [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    }
#endif
    PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
    return status;
}

+ (CCAuthorizationPhotoStatus)authorizationStatusOnlyWrite {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
    if (@available(iOS 14.0, *)) return [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
#endif
    return [self authorizationStatus];
}

/// 写入权限
+ (BOOL)authorizedWritePermission {
    if (@available(iOS 14.0, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
        return status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited;
    } else {
        PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
        return status == PHAuthorizationStatusAuthorized;
    }
}

///读写权限
+ (BOOL)authorizedReadWritePermission {
    if (@available(iOS 14.0, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        return status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited;
#endif
    }
    PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
    return status == PHAuthorizationStatusAuthorized;
}

+ (void)authorizeWithCompletion:(CCAuthorizationHandler)completion {
    if (@available(iOS 8.0, *)) {
        PHAuthorizationStatus status = [self authorizationStatus];
        switch (status) {
            case PHAuthorizationStatusAuthorized:
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
            case PHAuthorizationStatusLimited:
#endif
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied: {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined: {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
                if (@available(iOS 14.0, *)) {
                    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited ,YES);
                            });
                        }
                    }];
                    break;
                }
#endif
                //iOS14 PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == PHAuthorizationStatusAuthorized,YES);
                        });
                    }
                }];
                
            }
                break;
                
            default:{
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
        }
        
    }
}


/// 仅仅获取写权限,iOS14+有效
/// @param completion 返回
+ (void)authorizeOnlyWriteWithCompletion:(CCAuthorizationHandler)completion
{
    if (@available(iOS 8.0, *)) {
        PHAuthorizationStatus status = [self authorizationStatusOnlyWrite];
        switch (status) {
            case PHAuthorizationStatusAuthorized:
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
            case PHAuthorizationStatusLimited:
#endif
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied: {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined: {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
                if (@available(iOS 14.0, *)) {
                    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited ,YES);
                            });
                        }
                    }];
                    break;
                }
#endif
                //iOS14 PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == PHAuthorizationStatusAuthorized,YES);
                        });
                    }
                }];
            }
                break;
                
            default: {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
        }
    } else {
        completion(YES, NO);
    }
}

@end
