//
//  CCNumberScrollViewConfig.h
//  LCCKit
//
//  Created by lucc on 2021/9/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCNumberScrollDirection) {
    CCNumberScrollDirectionUp,
    CCNumberScrollDirectionDown,
};

NS_ASSUME_NONNULL_BEGIN

@interface CCNumberScrollViewConfig : NSObject

//字体
@property (nonatomic, strong) UIFont *font;
//文字颜色
@property (nonatomic, strong) UIColor *textColor;
//动画时长
@property (nonatomic, assign) CGFloat animationDuration;
//最大展示位数，输入值超出的话，只截取高位作为数据
@property (nonatomic, assign) NSUInteger maxDigits;
//小于最大展示位数是否需要补0
@property (nonatomic, assign) BOOL needFillZero;
//滚动方向
@property (nonatomic, assign) CCNumberScrollDirection scrollDirection;

@end

NS_ASSUME_NONNULL_END
