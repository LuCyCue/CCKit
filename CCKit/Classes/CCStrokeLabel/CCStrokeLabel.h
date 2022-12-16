//
//  CCStrokeLabel.h
//  LCCKit
//
//  Created by lucc on 2022/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCStrokeLabel : UILabel

/// 描边颜色
@property (nonatomic, strong) UIColor *strokeColor;

/// 描边大小
@property (nonatomic, assign) CGFloat strokeWidth;


/// 开启动画
/// @param flowingLightColor 流光颜色
/// @param intervalTime 流光动画间隔（s）
/// @param animationTime 流光动画时长（s）
- (void)starFlowingLightAnimation:(UIColor *)flowingLightColor intervalTime:(CGFloat)intervalTime animationTime:(CGFloat)animationTime;

/// 停止动画
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
