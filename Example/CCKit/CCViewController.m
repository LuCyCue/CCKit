//
//  CCViewController.m
//  CCKit
//
//  Created by Lucyfa on 06/19/2021.
//  Copyright (c) 2021 Lucyfa. All rights reserved.
//

#import "CCViewController.h"
#import "CCKit.h"
#import "CCNumberScrollView.h"
#import "CCNavigationController.h"
#import "CCTestViewController.h"
#import "CCLetterIndexViewController.h"
#import "CCChartViewController.h"
#import "NSObject+CCAdd.h"
#import "CCFileDownloadManager.h"
#import "CCStrokeLabel.h"

@interface CCViewController ()
@property (nonatomic, strong) CCNumberScrollView *numberScrollView;
@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"download" forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(resumeDownloadTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    for (int i = 0; i < 1; i++) {
        CCStrokeLabel *label = [[CCStrokeLabel alloc] initWithFrame:CGRectMake(100, 200, 200, 20)];
        label.strokeWidth = 6;
        label.backgroundColor = UIColor.clearColor;
        label.strokeColor = [UIColor colorWithRed:230/255.0 green:75/255.0 blue:248/255.0 alpha:0.7];
        label.textColor = UIColor.whiteColor;
        label.text = @"Do you like coding";
        label.layer.shadowRadius = 10;
        label.layer.shadowColor = [UIColor colorWithRed:230/255.0 green:75/255.0 blue:248/255.0 alpha:0.8].CGColor;
        label.layer.shadowOffset = CGSizeMake(0, 0);
        label.layer.shadowOpacity = 1.0;
        [self.view addSubview:label];
    }

}

- (void)resumeDownloadTest {
    [[CCFileDownloadManager manager] downloadFileWithUrl:@"http://qximg4.biaoliapp.cn/moment/0F349AD25126511B34A44DB877D9A881.mp4" progressHandler:^(CGFloat progress) {
        CCLog(@"k1 progress = %lf", progress);
    } completionHandler:^(NSString * _Nonnull url, NSError * _Nonnull err) {
        CCLog(@"k1 download complete");
    }];
    [[CCFileDownloadManager manager] downloadFileWithUrl:@"http://qximg8.biaoliapp.cn/moment/17113d9a45825c76ead4b02fc0ee988b.mp4" progressHandler:^(CGFloat progress) {
        CCLog(@"k2 progress = %lf", progress);
    } completionHandler:^(NSString * _Nonnull url, NSError * _Nonnull err) {
        CCLog(@"k2 download complete");
    }];
    [[CCFileDownloadManager manager] downloadFileWithUrl:@"http://qximg3.biaoliapp.cn/moment/1D4AC6DF4D95FA0DF8288392BBDC6818.mp4" progressHandler:^(CGFloat progress) {
        CCLog(@"k3 progress = %lf", progress);
    } completionHandler:^(NSString * _Nonnull url, NSError * _Nonnull err) {
        CCLog(@"k3 download complete");
    }];

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

- (void)numberScrollViewTest {
    CCNumberScrollViewConfig *config = [[CCNumberScrollViewConfig alloc] init];
    config.font = [UIFont boldSystemFontOfSize:20];
    config.maxDigits = 4;
    config.animationDuration = 0.3;
    config.needFillZero = true;
    self.numberScrollView = [[CCNumberScrollView alloc] initWithFrame:CGRectMake(100, 100, 100, 50) config:config];
    self.numberScrollView.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:self.numberScrollView];
    self.numberScrollView.num = 1003;
    [self changeNum:1002];

}

- (void)changeNum:(NSUInteger)num {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.numberScrollView.num = num;
        [self changeNum:num-8];
    });
}

- (void)jump2LetterIndexTest {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CCLetterIndexViewController *ctl = [CCLetterIndexViewController new];
        ctl.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:ctl animated:YES completion:nil];
    });
}

- (void)jump2ChatController {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CCChartViewController *ctl = [[CCChartViewController alloc] init];
        ctl.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:ctl animated:YES completion:nil];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
