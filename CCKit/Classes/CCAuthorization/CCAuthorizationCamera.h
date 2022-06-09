//
//  CCAuthorizationCamera.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationInterface.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCAuthorizationCamera : NSObject<CCAuthorizationInterface>

+ (AVAuthorizationStatus)authorizationStatus;

@end

NS_ASSUME_NONNULL_END
