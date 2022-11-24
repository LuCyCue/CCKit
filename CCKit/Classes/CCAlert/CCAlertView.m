//
//  CCAlertView.m
//  LCCKit
//
//  Created by lucc on 2022/6/13.
//

#import "CCAlertView.h"


@implementation CCAlertView

- (instancetype)initWithFrame:(CGRect)frame configuration:(CCAlertConfiguration *)configuration {
    self = [super initWithFrame:frame];
    if (self) {
        _configuration = configuration;
        [self addSubview:self.maskView];
        [self addSubview:self.contentView];
        self.maskView.frame = configuration.superView.bounds;
        self.maskView.backgroundColor = configuration.maskColor;
        self.contentView.backgroundColor = configuration.contentBgColor;
        self.contentView.layer.cornerRadius = configuration.cornerRadius;
        self.contentView.layer.masksToBounds = YES;
        if (configuration.touchOutsideHide) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [self.maskView addGestureRecognizer:tapGesture];
        }
    }
    return self;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    CGSize size = [customView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = size.height;
    customView.frame = CGRectMake(0, 0, customView.bounds.size.width, height);
    _customView.frame = customView.bounds;
    [self.contentView addSubview:customView];
    CGFloat x = (self.bounds.size.width - customView.bounds.size.width) / 2;
    CGFloat y = (self.bounds.size.height - customView.bounds.size.height) / 2;
    switch (self.configuration.posion) {
        case CCAlertPositionTop:
            self.contentView.frame = CGRectMake(x, 0, customView.bounds.size.width, customView.bounds.size.height);
            break;
        case CCAlertPositionCenter:
            self.contentView.frame = CGRectMake(x, y, customView.bounds.size.width, customView.bounds.size.height);
            break;
        case CCAlertPositionBottom:
            self.contentView.frame = CGRectMake(x, self.bounds.size.height-customView.bounds.size.height, customView.bounds.size.width, customView.bounds.size.height);
            break;
        default:
            break;
    }
    if (self.configuration.cornerRadiusArray.count > 0) {
        UIBezierPath *path = [self bezierPathWithRoundedRect:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) cornerRadiusArray:self.configuration.cornerRadiusArray lineWidth:0];
        [path addClip];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = path.CGPath;
        self.contentView.layer.mask = maskLayer;
    } else if (self.configuration.cornerRadius > 0) {
        self.customView.layer.masksToBounds = YES;
        self.customView.layer.cornerRadius = self.configuration.cornerRadius;
    }
}

- (UIBezierPath *)bezierPathWithRoundedRect:(CGRect)rect cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius lineWidth:(CGFloat)lineWidth {
    CGFloat topLeftCornerRadius = cornerRadius[0].floatValue;
    CGFloat bottomLeftCornerRadius = cornerRadius[1].floatValue;
    CGFloat bottomRightCornerRadius = cornerRadius[2].floatValue;
    CGFloat topRightCornerRadius = cornerRadius[3].floatValue;
    CGFloat lineCenter = lineWidth / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(topLeftCornerRadius, lineCenter)];
    [path addArcWithCenter:CGPointMake(topLeftCornerRadius, topLeftCornerRadius) radius:topLeftCornerRadius - lineCenter startAngle:M_PI * 1.5 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(lineCenter, CGRectGetHeight(rect) - bottomLeftCornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomLeftCornerRadius, CGRectGetHeight(rect) - bottomLeftCornerRadius) radius:bottomLeftCornerRadius - lineCenter startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - bottomRightCornerRadius, CGRectGetHeight(rect) - lineCenter)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - bottomRightCornerRadius, CGRectGetHeight(rect) - bottomRightCornerRadius) radius:bottomRightCornerRadius - lineCenter startAngle:M_PI * 0.5 endAngle:0.0 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - lineCenter, topRightCornerRadius)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - topRightCornerRadius, topRightCornerRadius) radius:topRightCornerRadius - lineCenter startAngle:0.0 endAngle:M_PI * 1.5 clockwise:NO];
    [path closePath];
    
    return path;
}

- (void)tapAction {
    [self hide];
}

- (void)show {
    if (self.configuration.animationType == CCAlertAnimationFade) {
        self.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
           
        }];
    } else {
        CGRect originRect = self.contentView.frame;
        CGRect targetRect = CGRectZero;
        switch (self.configuration.animationType) {
            case CCAlertAnimationBottom:
                targetRect = CGRectMake(originRect.origin.x, self.bounds.size.height, originRect.size.width, originRect.size.height);
                break;
            case CCAlertAnimationTop:
                targetRect = CGRectMake(originRect.origin.x, -originRect.size.height, originRect.size.width, originRect.size.height);
                break;
            case CCAlertAnimationLeft:
                targetRect = CGRectMake(-originRect.size.width, originRect.origin.y, originRect.size.width, originRect.size.height);
                break;
            case CCAlertAnimationRight:
                targetRect = CGRectMake(originRect.size.width+self.bounds.size.width, originRect.origin.y, originRect.size.width, originRect.size.height);
                break;

            default:
                break;
        }
        self.contentView.frame = targetRect;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = originRect;
        } completion:^(BOOL finished) {
           
        }];
    }

}

- (void)hide {
    if (self.configuration.animationType == CCAlertAnimationFade) {
        self.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
        }];
    } else {
        CGRect originRect = self.contentView.frame;
        CGRect targetRect = CGRectZero;
        switch (self.configuration.animationType) {
            case CCAlertAnimationBottom:
                targetRect = CGRectMake(originRect.origin.x, self.bounds.size.height, originRect.size.width, originRect.size.height);
                break;
            case CCAlertAnimationTop:
                targetRect = CGRectMake(originRect.origin.x, -originRect.size.height, originRect.size.width, originRect.size.height);
                break;
            case CCAlertAnimationLeft:
                targetRect = CGRectMake(-originRect.size.width, originRect.origin.y, originRect.size.width, originRect.size.height);
                break;
            case CCAlertAnimationRight:
                targetRect = CGRectMake(originRect.size.width+self.bounds.size.width, originRect.origin.y, originRect.size.width, originRect.size.height);
                break;

            default:
                break;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = targetRect;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        !self.viewDidAppearHandler ?: self.viewDidAppearHandler(self);
    } else {
        !self.viewDidDisappearHandler ?: self.viewDidDisappearHandler(self);
    }
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
    }
    return _maskView;
}

@end
