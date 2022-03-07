//
//  CCPieChartView.m
//  LCCKit
//
//  Created by chengchanglu on 2021/7/13.
//

#import "CCPieChartView.h"

@interface CCPieChartView ()

@property (nonatomic, strong) CAShapeLayer *pieLayer;
@property (nonatomic, strong) CAShapeLayer* pieCenterMaskLayer;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *numTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, assign) CGFloat outerRadius;
@property (nonatomic, assign) CGFloat innerRadius;

@end

@implementation CCPieChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        self.numTitleLabel = [[UILabel alloc] init];
        self.numTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numTitleLabel];
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.detailLabel];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(CCPieChartViewModel *)model {
    _model = model;
    self.numTitleLabel.font = _model.numberFont;
    self.numTitleLabel.textColor = _model.numberTextColor;
    self.detailLabel.font = _model.detailFont;
    self.detailLabel.textColor = _model.detailTextColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cleanPreDraw];
    [self strokePie];
    CGRect frame = self.bounds;
    self.numTitleLabel.frame = CGRectMake(0, frame.size.height/2 - 20, frame.size.width, 18);
    self.detailLabel.frame = CGRectMake(0, frame.size.height/2 + 2, frame.size.width, 18);
}

- (void)refreshPieChart {
    [self cleanPreDraw];
    [self strokePie];
}

- (void)cleanPreDraw {
    [self.pieLayer removeFromSuperlayer];
}

- (void)strokePie {
    CGFloat diameter = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    //外圆半径
    self.outerRadius = diameter / 2;
    //内圆半径
    self.innerRadius = diameter / 2 * self.model.innerRadius;
    self.numTitleLabel.text = self.model.numTitle;
    self.detailLabel.text = self.model.detail;
    
    //绘制基础饼
    self.pieLayer = [self newCircleLayerWithRadius:((self.outerRadius - self.innerRadius) / 2 + self.innerRadius)
                                       borderWidth:(self.outerRadius - self.innerRadius)
                                         fillColor:UIColor.whiteColor
                                       borderColor:UIColor.whiteColor
                                   startPercentage:0
                                     endPercentage:1];
    [self.contentView.layer addSublayer:self.pieLayer];
    
    //绘制各个部分,添加到pieLayer上
    for (int i = 0; i < self.model.dataItems.count; i++) {
        CGFloat startPercentage = self.model.strokeStartArray[i].doubleValue;
        CGFloat endPercentage = self.model.strokeEndArray[i].doubleValue;
        CAShapeLayer *layer = [self
                               newCircleLayerWithRadius:((self.outerRadius - self.innerRadius) / 2 +
                                                         self.innerRadius)
                               borderWidth:(self.outerRadius - self.innerRadius)
                               fillColor:[UIColor clearColor]
                               borderColor:self.model.dataItems[i].color
                               startPercentage:startPercentage
                               endPercentage:endPercentage];
        if (self.model.enableAnimation) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @0.0;
            animation.toValue = @1.0;
            layer.autoreverses = false;
            animation.duration = self.model.animationDuration;
            [layer addAnimation:animation forKey:nil];
        }
        [self.pieLayer addSublayer:layer];
    }
    
    //绘制中心空缺
    self.pieCenterMaskLayer = [self newCircleLayerWithRadius:self.innerRadius
                                                 borderWidth:0
                                                   fillColor:[UIColor whiteColor]
                                                 borderColor:[UIColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];
    [self.pieLayer addSublayer:self.pieCenterMaskLayer];
    if (self.model.enableAnimation) {
        self.numTitleLabel.alpha = 0;
        self.detailLabel.alpha = 0;
        [UIView animateWithDuration:self.model.animationDuration animations:^{
            self.numTitleLabel.alpha = 1;
            self.detailLabel.alpha = 1;
        }];
    }
}

//绘制圆圈
- (CAShapeLayer*)newCircleLayerWithRadius:(CGFloat)radius
                              borderWidth:(CGFloat)borderWidth
                                fillColor:(UIColor*)fillColor
                              borderColor:(UIColor*)borderColor
                          startPercentage:(CGFloat)startPercentage
                            endPercentage:(CGFloat)endPercentage {
    CAShapeLayer *circle = [CAShapeLayer layer];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    circle.fillColor = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd = endPercentage;
    circle.lineWidth = borderWidth;
    circle.path = path.CGPath;
    
    return circle;
}

@end
