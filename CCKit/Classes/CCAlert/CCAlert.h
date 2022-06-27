//
//  CCAlert.h
//  LCCKit
//
//  Created by lucc on 2022/6/13.
//

#import <UIKit/UIKit.h>
#import "CCAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAlert : NSObject

+ (CCAlertView *)alertCustomView:(UIView *)customView;

+ (CCAlertView *)alertCustomView:(UIView *)customView configuration:(CCAlertConfiguration *)configuration;

+ (CCAlertView *)alertCustomView:(UIView *)customView superView:(UIView *_Nullable)superView configuration:(CCAlertConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
