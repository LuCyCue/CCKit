//
//  CCAuthorizationPush.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAuthorizationPush : NSObject<CCAuthorizationInterface>

+ (CCAuthorizationPushStatus)authorizationStatus;

@end

NS_ASSUME_NONNULL_END
