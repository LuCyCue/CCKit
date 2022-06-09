//
//  CCAuthorizationCamera.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorizationCamera.h"

@implementation CCAuthorizationCamera

+ (BOOL)authorized {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return permission == AVAuthorizationStatusAuthorized;
    } else {
        // Prior to iOS 7 all apps were authorized.
        return YES;
    }
}

+ (AVAuthorizationStatus)authorizationStatus {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    } else {
        // Prior to iOS 7 all apps were authorized.
        return AVAuthorizationStatusAuthorized;
    }
}

+ (void)authorizeWithCompletion:(CCAuthorizationHandler)completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES,NO);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO,NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                }];
                
            }
                break;
        }
    } else {
        // Prior to iOS 7 all apps were authorized.
        completion(YES,NO);
    }
}
@end
