//
//  CCViewController.m
//  CCKit
//
//  Created by Lucyfa on 06/19/2021.
//  Copyright (c) 2021 Lucyfa. All rights reserved.
//

#import "CCViewController.h"
#import "NSArray+CCSafe.h"
#import "UIButton+CCLayout.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"album_growth_publish_text"] forState:UIControlStateNormal];
    [btn setTitle:@"Test" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    [btn cc_setEdgeInsetsStyle:CCButtonImageTitleStyleImageBottom imageTitleSpace:5];
    btn.backgroundColor = UIColor.grayColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
