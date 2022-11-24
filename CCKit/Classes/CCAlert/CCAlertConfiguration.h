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
//圆角集合（左上，左下，右下，右上）
@property (nonatomic, copy) NSArray<NSNumber *> *cornerRadiusArray;
//显示区域背景色
@property (nonatomic, strong) UIColor *contentBgColor;
//背景遮罩颜色
@property (nonatomic, strong) UIColor *maskColor;
//点击外部关闭弹窗
@property (nonatomic, assign) BOOL touchOutsideHide;
//父view
@property (nonatomic, weak) UIView *superView;
//id
@property (nonatomic, assign) int64_t alertId;
//进场动画类型
@property (nonatomic, assign) CCAlertAnimation animationType;

#pragma mark - 链式配置
- (CCAlertConfiguration *(^)(CGFloat))configCornerRadius;
- (CCAlertConfiguration *(^)(CCAlertPosition))configPosition;
- (CCAlertConfiguration *(^)(UIColor *))configContentBgColor;
- (CCAlertConfiguration *(^)(UIColor *))configMaskColor;
- (CCAlertConfiguration *(^)(BOOL))configTouchOutsideHide;
- (CCAlertConfiguration *(^)(UIView *))configSuperView;
- (CCAlertConfiguration *(^)(NSArray<NSNumber *> *))configCornerRadiusArray;
- (CCAlertConfiguration *(^)(int64_t))configAlertId;
- (CCAlertConfiguration *(^)(CCAlertAnimation))configAnimationType;

@end

NS_ASSUME_NONNULL_END
