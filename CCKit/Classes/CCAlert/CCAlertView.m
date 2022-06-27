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
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.customView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:(NSLayoutAttributeBottom) multiplier:1 constant:0];
//     NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.customView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:(NSLayoutAttributeLeft) multiplier:1 constant:0];
//     NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.customView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
//     NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.customView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
//    [self.contentView addConstraints:@[constraint, constraint1, constraint2, constraint3]];
}

- (void)tapAction {
    [self hide];
}

- (void)show {
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        !self.viewDidAppearHandler ?: self.viewDidAppearHandler();
    }];
}

- (void)hide {
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        !self.viewDidDisappearHandler ?: self.viewDidDisappearHandler();
        [self removeFromSuperview];
    }];
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
