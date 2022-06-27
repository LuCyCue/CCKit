//
//  CCAlertConfiguration.h
//  LCCKit
//
//  Created by lucc on 2022/6/13.
//

#import <Foundation/Foundation.h>
#import "CCAlertDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAlertConfiguration : NSObject
//位置
@property (nonatomic, assign) CCAlertPosition posion;
//圆角
@property (nonatomic, assign) CGFloat cornerRadius;
//显示区域背景色
@property (nonatomic, strong) UIColor *contentBgColor;
//背景遮罩颜色
@property (nonatomic, strong) UIColor *maskColor;
//点击外部关闭弹窗
@property (nonatomic, assign) BOOL touchOutsideHide;
//父view
@property (nonatomic, weak) UIView *superView;

#pragma mark - 链式配置
- (CCAlertConfiguration *(^)(CGFloat))configCornerRadius;
- (CCAlertConfiguration *(^)(CCAlertPosition))configPosition;
- (CCAlertConfiguration *(^)(UIColor *))configContentBgColor;
- (CCAlertConfiguration *(^)(UIColor *))configMaskColor;
- (CCAlertConfiguration *(^)(BOOL))configTouchOutsideHide;
- (CCAlertConfiguration *(^)(UIView *))configSuperView;

@end

NS_ASSUME_NONNULL_END
