//
//  CCAuthorizationMedia.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorizationMedia.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation CCAuthorizationMedia

+ (BOOL)authorized {
    return [self authorizationStatus] == CCAuthorizationMediaStatusAuthorized;
}

+ (CCAuthorizationMediaStatus)authorizationStatus {
    // if (@available(iOS 9.3, *))
    if (@available(iOS 9.3, *)) {
        return (CCAuthorizationMediaStatus)[MPMediaLibrary authorizationStatus];
    }
    return CCAuthorizationMediaStatusAuthorized;
}

+ (void)authorizeWithCompletion:(CCAuthorizationHandler)complection {
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
        switch (status) {
            case MPMediaLibraryAuthorizationStatusAuthorized:{
                if (complection) {
                    complection(YES, NO);
                }
            }
                break;
            case MPMediaLibraryAuthorizationStatusRestricted:
            case MPMediaLibraryAuthorizationStatusDenied:{
                if (complection) {
                    complection(NO, NO);
                }
            }
                break;
            case MPMediaLibraryAuthorizationStatusNotDetermined:{
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (complection) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            complection(status == MPMediaLibraryAuthorizationStatusAuthorized, YES);
                        });
                    }
                }];
            }
                break;
            default:{
                if (complection) {
                    complection(NO, NO);
                }
            }
                break;
        }
    } else {
        complection(YES, NO);
    }
}

@end
