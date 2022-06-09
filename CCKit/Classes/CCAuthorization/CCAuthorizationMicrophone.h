//
//  CCAuthorizationMicrophone.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAuthorizationMicrophone : NSObject<CCAuthorizationInterface>

+ (CCAuthorizationMicroPhoneStatus)authorizationStatus;

@end

NS_ASSUME_NONNULL_END
