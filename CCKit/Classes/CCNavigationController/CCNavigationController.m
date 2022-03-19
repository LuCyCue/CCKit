//
//  CCNavigationController.m
//  LCCKit
//
//  Created by lucc on 2021/11/26.
//

#import "CCNavigationController.h"

@interface CCNavigationController ()

@end

@implementation CCNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.popDirection = CCNavigationTransitionDirectionLeft;
        self.pushDirection = CCNavigationTransitionDirectionRight;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.popDirection = CCNavigationTransitionDirectionLeft;
        self.pushDirection = CCNavigationTransitionDirectionRight;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //侧滑手势
    __weak typeof(self) weakself = self;
     if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
         self.interactivePopGestureRecognizer.delegate = (id)weakself;
     }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.useCustomAnimation) {
        //customize animation
        if (animated) {
            [self.view.layer addAnimation:[self pushAnimation] forKey:nil];
        }
        [super pushViewController:viewController animated:NO];
        return;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.useCustomAnimation) {
        //customize animation
        if (animated) {
            [self.view.layer addAnimation:[self popAnimation] forKey:nil];
        }
        return [super popViewControllerAnimated:NO];
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.useCustomAnimation) {
        if (animated) {
            [self.view.layer addAnimation:[self popAnimation] forKey:nil];
        }
        return [super popToViewController:viewController animated:NO];
    }
    return [super popToViewController:viewController animated:animated];;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (animated) {
        [self.view.layer addAnimation:[self popAnimation] forKey:nil];
    }
    return [super popToRootViewControllerAnimated:NO];
}

#pragma mark -Public

- (void)pushViewController:(UIViewController *)viewController animationDirection:(CCNavigationTransitionDirection)direction {
    self.useCustomAnimation = YES;
    self.pushDirection = direction;
    [self pushViewController:viewController animated:YES];
    self.useCustomAnimation = NO;
}

- (UIViewController *)popViewControllerWithAnimationDirection:(CCNavigationTransitionDirection)direction {
    self.useCustomAnimation = YES;
    self.popDirection = direction;
    UIViewController *viewController = [self popViewControllerAnimated:YES];
    self.useCustomAnimation = NO;
    return viewController;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animationDirection:(CCNavigationTransitionDirection)direction {
    self.useCustomAnimation = YES;
    self.popDirection = direction;
    NSArray *viewControllers = [self popToViewController:viewController animated:YES];
    self.useCustomAnimation = NO;
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerWithAnimationDirection:(CCNavigationTransitionDirection)direction {
    self.useCustomAnimation = YES;
    self.popDirection = direction;
    NSArray *viewControllers = [self popToRootViewControllerAnimated:YES];
    self.useCustomAnimation = NO;
    return viewControllers;
}

#pragma mark -Private

- (CATransition *)popAnimation {
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    transition.type = kCATransitionPush;
    transition.subtype = [self getTransitionSubtypeWithDirection:self.popDirection];
    return transition;
}

- (CATransition *)pushAnimation {
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    transition.type = kCATransitionPush;
    transition.subtype = [self getTransitionSubtypeWithDirection:self.pushDirection];
    return transition;
}

- (CATransitionSubtype)getTransitionSubtypeWithDirection:(CCNavigationTransitionDirection)direction {
    CATransitionSubtype subtype;
    switch (direction) {
        case CCNavigationTransitionDirectionLeft:
            subtype = kCATransitionFromLeft;
            break;
        case CCNavigationTransitionDirectionRight:
            subtype = kCATransitionFromRight;
            break;
        case CCNavigationTransitionDirectionTop:
            subtype = kCATransitionFromTop;
            break;
        case CCNavigationTransitionDirectionBottom:
            subtype = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    return subtype;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //自定义手势开关
    UIViewController *topCtl = self.topViewController;
    if ([topCtl conformsToProtocol:@protocol(CCNavigaitonEnablePopGestureInterface)] &&
        [topCtl respondsToSelector:@selector(enableInteractivePopGesture)]) {
        UIViewController<CCNavigaitonEnablePopGestureInterface> *currentCtl = (UIViewController<CCNavigaitonEnablePopGestureInterface> *)topCtl;
        BOOL enable = [currentCtl enableInteractivePopGesture];
        return enable;
    }
    return YES;
}

@end
