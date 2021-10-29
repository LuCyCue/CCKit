//
//  CCNumberScrollViewConfig.m
//  LCCKit
//
//  Created by lucc on 2021/9/14.
//

#import "CCNumberScrollViewConfig.h"

@implementation CCNumberScrollViewConfig

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:15];
    }
    return _font;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = UIColor.blackColor;
    }
    return _textColor;
}

- (CGFloat)animationDuration {
    if (_animationDuration <= 0) {
        _animationDuration = 0.3;
    }
    return _animationDuration;
}

- (NSUInteger)maxDigits {
    if (_maxDigits <= 0) {
        _maxDigits = 2;
    }
    return _maxDigits;
}

@end
