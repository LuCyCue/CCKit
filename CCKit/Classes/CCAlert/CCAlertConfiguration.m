//
//  CCAlertConfiguration.m
//  LCCKit
//
//  Created by lucc on 2022/6/13.
//

#import "CCAlertConfiguration.h"

@implementation CCAlertConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _posion = CCAlertPositionCenter;
        _cornerRadius = 18.f;
        _contentBgColor = UIColor.whiteColor;
        _maskColor = [UIColor colorWithWhite:0 alpha:0.6];
        _touchOutsideHide = YES;
    }
    return self;
}

- (CCAlertConfiguration *(^)(CCAlertPosition))configPosition {
    return ^CCAlertConfiguration* (CCAlertPosition position) {
        self.posion = position;
        return self;
    };
}

- (CCAlertConfiguration *(^)(CGFloat))configCornerRadius {
    return ^CCAlertConfiguration* (CGFloat cornerRadius) {
        self.cornerRadius = cornerRadius;
        return self;
    };
}

- (CCAlertConfiguration *(^)(UIColor *))configContentBgColor {
    return ^CCAlertConfiguration* (UIColor *color) {
        self.contentBgColor = color;
        return self;
    };
}

- (CCAlertConfiguration *(^)(UIColor *))configMaskColor {
    return ^CCAlertConfiguration* (UIColor *color) {
        self.maskColor = color;
        return self;
    };
}

- (CCAlertConfiguration *(^)(BOOL))configTouchOutsideHide {
    return ^CCAlertConfiguration* (BOOL touchOutsideHide) {
        self.touchOutsideHide = touchOutsideHide;
        return self;
    };
}

- (CCAlertConfiguration *(^)(UIView *))configSuperView {
    return ^CCAlertConfiguration* (UIView *view) {
        self.superView = view;
        return self;
    };
}

- (CCAlertConfiguration *(^)(NSArray<NSNumber *> *))configCornerRadiusArray {
    return ^CCAlertConfiguration* (NSArray<NSNumber *> *array) {
        self.cornerRadiusArray = array;
        return self;
    };
}

- (CCAlertConfiguration *(^)(int64_t))configAlertId {
    return ^CCAlertConfiguration* (int64_t alertId) {
        self.alertId = alertId;
        return self;
    };
}

- (CCAlertConfiguration *(^)(CCAlertAnimation))configAnimationType {
    return ^CCAlertConfiguration* (CCAlertAnimation animation) {
        self.animationType = animation;
        return self;
    };
}


@end
