//
//  CCViewController.m
//  CCKit
//
//  Created by Lucyfa on 06/19/2021.
//  Copyright (c) 2021 Lucyfa. All rights reserved.
//

#import "CCViewController.h"
#import "NSArray+CCSafe.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *mArray = [NSMutableArray array];
    [mArray cc_safeAddObject:@(1)];
    [mArray cc_safeAddObject:nil];
    id x = [mArray cc_safeObjectAtIndex:3];
    NSLog(@"%@",x);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
