//
//  UIButton+CCLayout.h
//  LCCKit
//
//  Created by chengchanglu on 2021/7/6.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CCButtonImageTitleStyle) {
    CCButtonImageTitleStyleImageLeft,
    CCButtonImageTitleStyleImageRight,
    CCButtonImageTitleStyleImageTop,
    CCButtonImageTitleStyleImageBottom
};

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CCLayout)

/**
 调整布局时整个按钮和图文的间隙。
 @param style 样式
 @param imageTitleSpace 调整布局时整个按钮和图文的间隙
 */
- (void)cc_setEdgeInsetsStyle:(CCButtonImageTitleStyle)style imageTitleSpace:(CGFloat)imageTitleSpace;

@end

NS_ASSUME_NONNULL_END
