//
//  CCAuthorization.m
//  Pods
//
//  Created by lucc on 2022/6/9.
//

#import "CCAuthorization.h"
#import "CCAuthorizationInterface.h"

@implementation CCAuthorization

/**
 当前权限是否开启
 @param type 权限类型
 @return 开启-YES, 关闭-NO
 */
+ (BOOL)authorizedWithType:(CCAuthorizationType)type {
    Class<CCAuthorizationInterface> cls = [self authorizationWithType:type];
    return [cls authorized];
}

/**
 获取权限
 @param type 权限类型
 @param completion May be called immediately if permission has been requested
 granted: YES if permission has been obtained, firstTime: YES if first time to request permission
 */
+ (void)authorizeWithType:(CCAuthorizationType)type completion:(CCAuthorizationHandler)completion {
    Class<CCAuthorizationInterface> cls = [self authorizationWithType:type];
    return [cls authorizeWithCompletion:completion];
}

+ (Class<CCAuthorizationInterface>)authorizationWithType:(CCAuthorizationType)type {
    NSString *clsStr = @"";
    switch (type) {
        case CCAuthorizationTypePush:
            clsStr = @"CCAuthorizationPush";
            break;
        case CCAuthorizationTypeLocation:
            clsStr = @"CCAuthorizationLocation";
            break;
        case CCAuthorizationTypeCamera:
            clsStr = @"CCAuthorizationCamera";
            break;
        case CCAuthorizationTypePhotos:
            clsStr = @"CCAuthorizationPhotos";
            break;
        case CCAuthorizationTypeMicrophone:
            clsStr = @"CCAuthorizationMicrophone";
            break;
        case CCAuthorizationTypeMediaLibrary:
            clsStr = @"CCAuthorizationMedia";
            break;
        case CCAuthorizationTypeTracking:
            clsStr = @"CCAuthorizationTracking";
            break;
            
        default:
            break;
    }
    return NSClassFromString(clsStr);
}

@end
