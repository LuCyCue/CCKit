//
//  CCTestViewController.m
//  CCKit_Example
//
//  Created by lucc on 2021/11/29.
//  Copyright © 2021 Lucyfa. All rights reserved.
//

#import "CCTestViewController.h"
#import "CCKit.h"
#import "CCNavigationController.h"

@interface CCTestViewController ()<CCNavigaitonEnablePopGestureInterface>

@end

@implementation CCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 50, 30);
    [btn setTitle:@"Next" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)nextAction {
    CCTestViewController *ctl = [[CCTestViewController alloc] init];
    ctl.title = @(arc4random_uniform(100)).stringValue;
    int random = arc4random_uniform(2);
    if (random) {
        CCNavigationController *nav = CCDynamicCast(self.navigationController, CCNavigationController);
        if (nav) {
            [nav pushViewController:ctl animationDirection:CCNavigationTransitionDirectionTop];
        }
    } else {
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (BOOL)enableInteractivePopGesture {
    return NO;
}

@end
