//
//  CCAuthorizationPhotos.h
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import "CCAuthorizationInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAuthorizationPhotos : NSObject<CCAuthorizationInterface>

+ (CCAuthorizationPhotoStatus)authorizationStatusOnlyWrite;

/// 仅仅获取写权限,iOS14+有效
/// @param completion 返回
+ (void)authorizeOnlyWriteWithCompletion:(CCAuthorizationHandler)completion;

@end

NS_ASSUME_NONNULL_END
