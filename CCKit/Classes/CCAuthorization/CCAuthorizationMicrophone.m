//
//  CCAuthorizationMicrophone.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorizationMicrophone.h"
#import <AVFoundation/AVFoundation.h>

@implementation CCAuthorizationMicrophone

+ (BOOL)authorized {
    return [self authorizationStatus] == CCAuthorizationMicroPhoneStatusGranted;
}

+ (CCAuthorizationMicroPhoneStatus)authorizationStatus {
    if ( @available(iOS 8,*) ) {
        switch ([[AVAudioSession sharedInstance] recordPermission]) {
            case AVAudioSessionRecordPermissionUndetermined:
                return CCAuthorizationMicroPhoneStatusUndetermined;
                break;
            case AVAudioSessionRecordPermissionDenied:
                return CCAuthorizationMicroPhoneStatusDenied;
            default:
                return CCAuthorizationMicroPhoneStatusGranted;
                break;
        }
    }
    return CCAuthorizationMicroPhoneStatusGranted;
}

+ (void)authorizeWithCompletion:(CCAuthorizationHandler)completion {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (@available(iOS 8.0, *)) {
        AVAudioSessionRecordPermission permission = [audioSession recordPermission];
        switch (permission) {
            case AVAudioSessionRecordPermissionGranted: {
                if (completion) {
                    completion(YES, NO);
                }
            }
                break;
            case AVAudioSessionRecordPermissionDenied: {
                if (completion) {
                    completion(NO, NO);
                }
            }
                break;
            case AVAudioSessionRecordPermissionUndetermined: {
                AVAudioSession *session = [[AVAudioSession alloc] init];
                NSError *error;
                [session setCategory:@"AVAudioSessionCategoryPlayAndRecord" error:&error];
                [session requestRecordPermission:^(BOOL granted) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                }];
            }
                break;
            default: {
                completion(NO,YES);
            }
                break;
        }
    } else {
        completion(YES, NO);
    }
}

@end
