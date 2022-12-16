//
//  UIView+CCAdd.h
//  LCCKit
//
//  Created by lucc on 2022/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CCAdd)

/// 设置阴影
- (void)cc_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/// 寻找所在的控制器
- (UIViewController *_Nullable)cc_viewController;

/// 设置渐变色背景
/// @discussion 取的是当前view frame 作为坐标，自动布局需要注意调用方法时机
/// layer是添加在当前view的superview上的，如果没有父view方法不会生效
- (void)cc_setGradientBgColor:(NSArray<UIColor *> *)colors
                 locations:(NSArray<NSNumber *> *)locations
                startPoint:(CGPoint)startPoint
                  endPoint:(CGPoint)endPoint;


/// 设置渐变色边框
/// @param colors 渐变色集合
/// @param locations 渐变色位置信息
/// @param startPoint 渐变色起始坐标
/// @param endPoint 渐变色结束坐标
/// @param cornerRadius 边框圆角
/// @param borderWidth 边框线宽
- (void)cc_setGradientBolder:(NSArray<UIColor *> *)colors
                   locations:(NSArray<NSNumber *> *)locations
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint
                cornerRadius:(CGFloat)cornerRadius
                 borderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
