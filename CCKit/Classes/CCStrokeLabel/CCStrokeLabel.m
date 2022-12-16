//
//  CCStrokeLabel.m
//  LCCKit
//
//  Created by lucc on 2022/4/12.
//

#import "CCStrokeLabel.h"

@interface CCStrokeLabel ()
@property (nonatomic, strong) UILabel *animationLab;
@property (nonatomic, strong) UIColor *flowingLightColor;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CALayer *animationLayer;
@end

@implementation CCStrokeLabel

- (void)dealloc {
    if (self.flowingLightColor) {
        [self stopAnimation];
    }
}

- (void)drawTextInRect:(CGRect)rect {
    if (self.strokeWidth) {
        CGSize shadowOffset = self.shadowOffset;
        UIColor *textColor = self.textColor;
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 描边
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        self.textColor = self.strokeColor;
        [super drawTextInRect:rect];
        // 文字
        self.textColor = textColor;
        CGContextSetTextDrawingMode(context, kCGTextFill);
        self.shadowOffset = CGSizeMake(0, 0);
        [super drawTextInRect:rect];
        self.shadowOffset = shadowOffset;
    } else {
        [super drawTextInRect:rect];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.animationLayer.frame = self.bounds;
    self.animationLab.frame = self.animationLayer.bounds;
    self.gradientLayer.frame = CGRectMake(-self.animationLayer.bounds.size.width, 0, self.animationLayer.bounds.size.width, self.animationLab.bounds.size.height);
    self.animationLayer.mask = self.animationLab.layer;
}

- (void)starFlowingLightAnimation:(UIColor *)flowingLightColor intervalTime:(CGFloat)intervalTime animationTime:(CGFloat)animationTime {
    [self stopAnimation];
    _flowingLightColor = flowingLightColor;
    self.animationLab.text = self.text;
    self.animationLab.font = self.font;
    self.animationLab.textAlignment = self.textAlignment;
    self.animationLab.lineBreakMode = self.lineBreakMode;
    self.animationLab.numberOfLines = self.numberOfLines;

    [self addSubview:self.animationLab];
    [self.layer addSublayer:self.animationLayer];
    self.gradientLayer.colors = @[(id)self.textColor.CGColor, (id)flowingLightColor.CGColor, (id)self.textColor.CGColor];
    
    CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CABasicAnimation *qTransition = [[CABasicAnimation alloc] init];
    qTransition.keyPath = @"position.x";
    qTransition.duration = intervalTime+animationTime;
    qTransition.byValue = @(size.width + intervalTime/animationTime*size.width);
    qTransition.repeatCount = CGFLOAT_MAX;
    qTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.gradientLayer addAnimation:qTransition forKey:@"flush"];
}

- (void)stopAnimation {
    self.flowingLightColor = nil;
    self.animationLab.text = @"";
    [self.gradientLayer removeAllAnimations];
    [self.animationLayer removeFromSuperlayer];
}

- (UILabel *)animationLab {
    if (!_animationLab) {
        _animationLab = UILabel.new;
        _animationLab.backgroundColor = UIColor.clearColor;
    }
    return _animationLab;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        _gradientLayer.locations = @[@0,@(0.5),@1];
    }
    return _gradientLayer;
}

- (CALayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CALayer layer];
        [_animationLayer addSublayer:self.gradientLayer];
    }
    return _animationLayer;
}

@end
