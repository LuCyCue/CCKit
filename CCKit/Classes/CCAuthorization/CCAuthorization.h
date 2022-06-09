//
//  CCAuthorization.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAuthorization : NSObject

/**
 当前权限是否开启
 @param type 权限类型
 @return 开启-YES, 关闭-NO
 */
+ (BOOL)authorizedWithType:(CCAuthorizationType)type;

/**
 获取权限
 @param type 权限类型
 @param completion May be called immediately if permission has been requested
 granted: YES if permission has been obtained, firstTime: YES if first time to request permission
 */
+ (void)authorizeWithType:(CCAuthorizationType)type completion:(CCAuthorizationHandler)completion;

@end

NS_ASSUME_NONNULL_END
