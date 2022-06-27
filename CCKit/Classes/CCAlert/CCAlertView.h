//
//  CCAlertView.h
//  LCCKit
//
//  Created by lucc on 2022/6/13.
//

#import <UIKit/UIKit.h>
#import "CCAlertConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAlertView : UIView
@property (nonatomic, strong, readonly) CCAlertConfiguration *configuration;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) void(^viewDidAppearHandler)(void);
@property (nonatomic, copy) void(^viewDidDisappearHandler)(void);



- (instancetype)initWithFrame:(CGRect)frame configuration:(CCAlertConfiguration *)configuration;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
