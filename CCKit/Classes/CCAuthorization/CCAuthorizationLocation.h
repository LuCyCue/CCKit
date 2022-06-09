//
//  CCAuthorizationLocation.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationInterface.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCAuthorizationLocation : NSObject<CCAuthorizationInterface>

/// 手机定位功能总开关状态
+ (BOOL)isServicesEnabled;

+ (CLAuthorizationStatus)authorizationStatus;

@end

NS_ASSUME_NONNULL_END
