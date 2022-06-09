//
//  CCAuthorizationInterface.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CCAuthorizationInterface <NSObject>

/// 是否授权
+ (BOOL)authorized;

/// 异步获取授权状态，第一次会主动申请权限
+ (void)authorizeWithCompletion:(CCAuthorizationHandler)complection;

@end

NS_ASSUME_NONNULL_END
