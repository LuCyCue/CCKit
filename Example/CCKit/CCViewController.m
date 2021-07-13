//
//  CCViewController.m
//  CCKit
//
//  Created by Lucyfa on 06/19/2021.
//  Copyright (c) 2021 Lucyfa. All rights reserved.
//

#import "CCViewController.h"
#import "CCKit.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testImage];
}

- (void)macroTest {
    CCLog(@"%lf", SYSTEM_VERSION);
    CCLog(@"%@", BUILD_VERSION);
    CCLog(@"%@", PROJECT_NAME);
    CCLog(@"%@", APP_NAME);
}

- (void)testImage {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    [self.view addSubview:imageView];
    UIImage *image = [UIImage cc_qrImageWithContent:@"http://www.baidu.com" size:100];
    imageView.image = image;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 210, 100, 100)];
    [self.view addSubview:imageView1];
    UIImage *image1 = [UIImage cc_qrImageWithContent:@"http://www.baidu.com" size:100 red:230 green:123 blue:100];
    imageView1.image = image1;
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 330, 100, 100)];
    [self.view addSubview:imageView2];
    UIImage *image2 = [UIImage cc_qrImageWithContent:@"http://www.baidu.com" logo:[UIImage imageNamed:@"icon1"] size:100 red:100 green:100 blue:100];
    imageView2.image = image2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
