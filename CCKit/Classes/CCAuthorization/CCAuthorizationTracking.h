//
//  CCAuthorizationTracking.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationInterface.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCAuthorizationTracking : NSObject<CCAuthorizationInterface>

+ (ATTrackingManagerAuthorizationStatus)authorizationStatus API_AVAILABLE(ios(14.0));

@end

NS_ASSUME_NONNULL_END
