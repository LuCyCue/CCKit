//
//  UIButton+CCLayout.m
//  LCCKit
//
//  Created by lucc on 2021/7/6.
//

#import "UIButton+CCLayout.h"
#import <objc/runtime.h>

@implementation UIButton (CCLayout)

- (void)cc_setEdgeInsetsStyle:(CCButtonImageTitleStyle)style imageTitleSpace:(CGFloat)imageTitleSpace {
    
    // 1. 得到imageView和titleLabel的宽和高
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    }
    else{
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space设置imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case CCButtonImageTitleStyleImageTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-imageTitleSpace, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-imageTitleSpace, 0);
        }
            break;
        case CCButtonImageTitleStyleImageLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -imageTitleSpace, 0, imageTitleSpace);
            labelEdgeInsets = UIEdgeInsetsMake(0, imageTitleSpace, 0, -imageTitleSpace);
        }
            break;
        case CCButtonImageTitleStyleImageBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-imageTitleSpace, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-imageTitleSpace, -imageWidth, 0, 0);
        }
            break;
        case CCButtonImageTitleStyleImageRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+imageTitleSpace, 0, -labelWidth-imageTitleSpace);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-imageTitleSpace, 0, imageWidth+imageTitleSpace);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
