//
//  CCNavigationController.h
//  LCCKit
//
//  Created by HuanZheng on 2021/11/26.
//

#import <UIKit/UIKit.h>
#import "CCNavigaitonEnablePopGestureInterface.h"

typedef NS_ENUM(NSInteger, CCNavigationTransitionDirection) {
    CCNavigationTransitionDirectionLeft,
    CCNavigationTransitionDirectionRight,
    CCNavigationTransitionDirectionTop,
    CCNavigationTransitionDirectionBottom,
};

NS_ASSUME_NONNULL_BEGIN

@interface CCNavigationController : UINavigationController

@property (nonatomic, assign) CCNavigationTransitionDirection pushDirection;
@property (nonatomic, assign) CCNavigationTransitionDirection popDirection;
//使用自定义动画
@property (nonatomic, assign) BOOL useCustomAnimation;

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerWithAnimationDirection:(CCNavigationTransitionDirection)direction;
- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animationDirection:(CCNavigationTransitionDirection)direction;
- (UIViewController *)popViewControllerWithAnimationDirection:(CCNavigationTransitionDirection)direction;
- (void)pushViewController:(UIViewController *)viewController animationDirection:(CCNavigationTransitionDirection)direction;

@end

NS_ASSUME_NONNULL_END
