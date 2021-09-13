//
//  CCNumberScrollView.h
//  LCCKit
//
//  Created by lucc on 2021/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCNumberScrollView : UIView
//字体
@property (nonatomic, strong) UIFont *font;
//文字颜色
@property (nonatomic, strong) UIColor *textColor;
//动画时长
@property (nonatomic, assign) CGFloat animationDuration;
//展示数值
@property (nonatomic, assign) NSInteger num;

@end

NS_ASSUME_NONNULL_END
