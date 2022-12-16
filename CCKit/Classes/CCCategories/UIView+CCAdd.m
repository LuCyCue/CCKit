//
//  UIView+CCAdd.m
//  LCCKit
//
//  Created by lucc on 2022/12/12.
//

#import "UIView+CCAdd.h"
#import <objc/runtime.h>

@implementation UIView (CCAdd)

- (void)cc_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIViewController *)cc_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)cc_setGradientBgColor:(NSArray<UIColor *> *)colors
                 locations:(NSArray<NSNumber *> *)locations
                startPoint:(CGPoint)startPoint
                  endPoint:(CGPoint)endPoint {
    if (!self.superview) {
        return;
    }
    CAGradientLayer *gradientLayer = CAGradientLayer.layer;
    NSMutableArray *cfColors = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cfColors addObject:(id)obj.CGColor];
    }];
    gradientLayer.colors = cfColors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.zPosition = -1;
    gradientLayer.opacity = 1.0;
    gradientLayer.frame = self.frame;
    [self.superview.layer addSublayer:gradientLayer];
}

- (void)cc_setGradientBolder:(NSArray<UIColor *> *)colors
                   locations:(NSArray<NSNumber *> *)locations
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint
                cornerRadius:(CGFloat)cornerRadius
                  borderWidth:(CGFloat)borderWidth {
    CAGradientLayer *gradientLayer = CAGradientLayer.layer;
    NSMutableArray *cfColors = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cfColors addObject:(id)obj.CGColor];
    }];
    gradientLayer.colors = cfColors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.zPosition = -1;
    gradientLayer.frame = self.bounds;
    
    CGRect mapRect = CGRectMake(borderWidth/2, borderWidth/2, self.frame.size.width-borderWidth, self.frame.size.height-borderWidth);
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.lineWidth = borderWidth;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mapRect cornerRadius:cornerRadius];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    gradientLayer.mask = maskLayer;
    [self.layer addSublayer:gradientLayer];
    
    self.layer.cornerRadius = cornerRadius+borderWidth;
}

@end
