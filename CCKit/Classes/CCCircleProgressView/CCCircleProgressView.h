//
//  CCCircleProgressView.h
//  Pods
//
//  Created by lucc on 2022/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCCircleProgressView : UIView
@property (nonatomic, strong) UIColor          *progressColor;  //进度条颜色
@property (nonatomic, strong) UIColor          *progressBgColor;  //进度条背景颜色

@property (nonatomic, assign) CGFloat progress;  // 0.0 .. 1.0, default is

/// 初始化方法
/// @param frame 圆形环的绘制区域
/// @param trackWidth 圆形环的宽度
- (instancetype)initWithFrame:(CGRect)frame trackWidth:(CGFloat)trackWidth NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

/// 设置进度条
/// @param progress 进度条百分比
/// @param animated 是否开启动画
/// @param startAngle 起始角度
/// @param clockwise 进度条方向(是否顺时针)
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated startAngle:(CGFloat )startAngle clockwise:(BOOL)clockwise;

/// 自定义中间显示进度文案
- (void)textLableCustomStyle:(void(^)(UILabel *textLabel))styleBlock;

@end

NS_ASSUME_NONNULL_END
