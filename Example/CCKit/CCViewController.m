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

@interface CCViewController ()
@property (nonatomic, strong) CCNumberScrollView *numberScrollView;
@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self jump2LetterIndexTest];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
