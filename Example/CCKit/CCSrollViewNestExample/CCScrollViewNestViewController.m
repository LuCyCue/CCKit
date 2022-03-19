//
//  CCScrollViewNestViewController.m
//  CCKit_Example
//
//  Created by lucc on 2022/3/1.
//  Copyright © 2022 Lucyfa. All rights reserved.
//

#import "CCScrollViewNestViewController.h"
#import "UIScrollView+CCNest.h"

@interface CCScrollViewNestViewController ()<UIScrollViewDelegate>
//父UIScrollView
@property (nonatomic, strong) UIScrollView *fatherscrollView;
//头部区
@property (nonatomic, strong) UIView *headerView;
//子UIScrollView
@property (nonatomic, strong) UIScrollView *childScrollView;
@end

@implementation CCScrollViewNestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.fatherscrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.fatherscrollView.delegate = self;
    self.fatherscrollView.bounces = YES;
    self.fatherscrollView.backgroundColor = UIColor.grayColor;
    self.fatherscrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height+200);
    self.fatherscrollView.hookGestureDelegate = YES;
    self.fatherscrollView.shouldRecognizeSimultaneously = YES;
    self.fatherscrollView.role = CCNestScrollRoleFather;
    self.fatherscrollView.canScroll = YES;
    self.fatherscrollView.criticalOffset =  160 - [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.view addSubview:self.fatherscrollView];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.headerView.backgroundColor = UIColor.greenColor;
    [self.fatherscrollView addSubview:self.headerView];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"悬浮标题";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 160, self.view.bounds.size.width, 40);
    label.backgroundColor = UIColor.whiteColor;
    [self.headerView addSubview:label];
    
    self.childScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.childScrollView.delegate = self;
    self.childScrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height * 1.5);
    self.childScrollView.backgroundColor = UIColor.redColor;
    self.childScrollView.role = CCNestScrollRoleChild;
    self.childScrollView.superSrcollView = self.fatherscrollView;
    self.childScrollView.criticalOffset = 0;
    [self.fatherscrollView addSubview:self.childScrollView];
    self.fatherscrollView.childScrollView = self.childScrollView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:50];
    contentLabel.text = @"子滚动内容";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.childScrollView addSubview:contentLabel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"did scroll");
}

@end
