//
//  CCLetterSelectIndicatorView.m
//
//  Created by Lucc on 2022/1/18.
//

#import "CCLetterSelectIndicatorView.h"


@interface CCLetterSelectIndicatorView ()
//底图
@property (nonatomic, strong) UIImageView *indicatorView;
//字母
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CCLetterSelectIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.indicatorView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

/// 设置坐标和文本
/// @param origin 坐标
/// @param title 文本
- (void)setOrigin:(CGPoint)origin title:(NSString *)title {
    self.frame = CGRectMake(origin.x-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    [self setCenterY:origin.y];
    self.titleLabel.text = title;
}

/// 设置centerY
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

#pragma mark - Getter

- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        _indicatorView.image = [GCIMModuleService imageNamed:@"friend_letter_indicator"];
        _indicatorView.transform = CGAffineTransformRotate(_indicatorView.transform, -90*M_PI / 180.0);
    }
    return _indicatorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
