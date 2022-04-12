//
//  CCUtil.h
//  Pods
//
//  Created by lucc on 2022/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCUtil : NSObject

/// 打开应用外URL
/// @param url url
/// @param completion 回调
+ (void)openURL:(NSString *)url completion:(void (^)(BOOL success))completion;

/// 打开app对应的设置
+ (void)openAppSetting;

/// 获取keywindow
+ (UIWindow *)getKeyWindow;

/// 拨打电话
/// @param phone 电话号码
/// @param completion 回调
+ (void)makeACallWithPhoneNumber:(NSString *)phone completion:(void (^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
