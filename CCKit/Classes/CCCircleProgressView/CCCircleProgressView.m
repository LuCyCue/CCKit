//
//  CCCircleProgressView.m
//  Pods
//
//  Created by lucc on 2022/6/28.
//

#import "CCCircleProgressView.h"

@interface CCCircleProgressView()
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;      //背景图层
@property (nonatomic, strong) CAShapeLayer *frontFillLayer;       //用来填充的图层
@property (nonatomic, assign) CGFloat      trackWidth;    //导轨宽度
@property (nonatomic, assign) CGFloat      width;        //圆环宽度
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation CCCircleProgressView

#pragma mark - initialization 初始化
- (instancetype)initWithFrame:(CGRect)frame trackWidth:(CGFloat)trackWidth {
    if (self = [super initWithFrame:frame]) {
        _trackWidth = trackWidth;
        _width = frame.size.width;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    //创建背景图层
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = nil;

    //创建填充图层
    _frontFillLayer = [CAShapeLayer layer];
    _frontFillLayer.fillColor = nil;
    _frontFillLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_frontFillLayer];
    
    //设置颜色
    _frontFillLayer.strokeColor = UIColor.blueColor.CGColor;
    _backgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont boldSystemFontOfSize:15];
    self.textLabel.textColor = UIColor.blackColor;
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width;
    UIBezierPath *backgroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                                                        radius:(CGRectGetWidth(self.bounds)- self.trackWidth)/2.f
                                                                    startAngle:0
                                                                      endAngle:M_PI*2
                                                                     clockwise:YES];
    _backgroundLayer.path = backgroundBezierPath.CGPath;
    //设置线宽
    _frontFillLayer.lineWidth = self.trackWidth;
    _backgroundLayer.lineWidth = self.trackWidth;
    self.textLabel.frame = self.bounds;
}

#pragma mark -- setter方法
- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _frontFillLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressBgColor:(UIColor *)progressBgColor {
    
    _progressBgColor = progressBgColor;
    _backgroundLayer.strokeColor = progressBgColor.CGColor;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO startAngle:-M_PI_2 clockwise:YES];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setProgress:progress animated:animated startAngle:-M_PI_2 clockwise:YES];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated startAngle:(CGFloat )startAngle clockwise:(BOOL)clockwise {
    progress = MAX(MIN(progress, 1.0), 0.0);
    _progress = progress;
    self.textLabel.text = [NSString stringWithFormat:@"%.1f%@", progress * 100, @"%"];
    CGFloat width = self.width;
    CGFloat endAngle = startAngle + (clockwise ? (2*M_PI)*progress : (-2*M_PI)*progress);
    UIBezierPath *frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                                                       radius:(CGRectGetWidth(self.bounds)-self.trackWidth)/2.f
                                                                   startAngle:startAngle
                                                                     endAngle:endAngle
                                                                    clockwise:clockwise];
    _frontFillLayer.path = frontFillBezierPath.CGPath;
    if (animated) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basicAnimation.duration = 0.3;//动画时间
        basicAnimation.fromValue = [NSNumber numberWithInteger:0];
        basicAnimation.toValue = [NSNumber numberWithInteger:1];
        [_frontFillLayer addAnimation:basicAnimation forKey:@"strokeKey"];
    }
}

- (void)textLableCustomStyle:(void(^)(UILabel *textLabel))styleBlock {
    !styleBlock ?: styleBlock(self.textLabel);
}

@end
