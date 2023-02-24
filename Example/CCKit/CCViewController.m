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
#import "CCMeidaFormatFactoryTestController.h"
#import "CCAlert.h"
#import "CCSortTableViewController.h"
#import <Masonry/Masonry.h>
#import "CCChainNode.h"
#import "UIView+CCAdd.h"
#import "CCRefreshTimer.h"

@interface CCViewController ()
@property (nonatomic, strong) CCNumberScrollView *numberScrollView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) CCRefreshTimer *refreshTimer;
@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [btn setTitle:@"download" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jump2MediaFormatFactoryController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.top.mas_equalTo(100);
    }];
    self.btn = btn;
    

    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 50)];
    [testBtn setTitle:@"Test" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    testBtn.backgroundColor = UIColor.redColor;
    [self.view addSubview:testBtn];
    [testBtn cc_setGradientBolder:@[UIColor.yellowColor, UIColor.greenColor] locations:@[@0,@1] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:8 borderWidth:2];
    
    self.refreshTimer = CCRefreshTimer.new;
    self.refreshTimer.refreshInterval = 0.4;
    [self.refreshTimer addRefreshHandler:^{
        NSLog(@"refresh done");
    }];
    
}

- (void)testAction {
    for (int i = 0; i < 10; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"send task %d", i);
            [self.refreshTimer refresh];
        });
        
    }
    return;
    CCChainNode *rootNode = [[CCChainNode alloc] init];
    rootNode.doHandler = ^(CCChainNode*  _Nonnull sender) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            NSLog(@"root done");
            sender.data = @"root";
            [sender sendNext:sender];
        });
    };
    rootNode.completionHandler = ^(id  _Nonnull sender) {
        NSLog(@"root completion");
    };
    rootNode.errorHandler = ^(NSError * _Nonnull error) {
        
    };
    CCChainNode *secondNode = CCChainNode.new;
    secondNode.doHandler = ^(id  _Nonnull sender) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(3);
            NSLog(@"second done");
            [sender sendNext:sender];
        });
    };
    secondNode.completionHandler = ^(id  _Nonnull sender) {
        NSLog(@"second completion");
    };
    secondNode.errorHandler = ^(NSError * _Nonnull error) {
        
    };
    CCChainNode *thirdNode = CCChainNode.new;
    thirdNode.doHandler = ^(id  _Nonnull sender) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(4);
            NSLog(@"third done");
            [sender sendNext:sender];
        });
    };
    thirdNode.completionHandler = ^(id  _Nonnull sender) {
        NSLog(@"third completion");
    };
    rootNode.addNextNode(secondNode);
    secondNode.addNextNode(thirdNode);
    [rootNode start:nil];
}

- (void)alertTest {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = UIColor.greenColor;
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"中华人湄公河看到房价乐山大佛的点点滴滴打断点,中华人湄公河看到房价乐山大佛的点点滴滴打断点";
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = UIColor.blackColor;
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByTruncatingTail;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(16);
        make.right.bottom.mas_equalTo(-16);
        make.width.mas_equalTo(SCREEN_WIDTH-50);
    }];
    CCAlertAnimation type = arc4random_uniform(5);
    CCAlertConfiguration *configuration = CCAlertConfiguration.new
                                                              .configPosition(CCAlertPositionCenter)
                                                              .configCornerRadiusArray(@[@16,@0,@0,@16])
                                                              .configAlertId(1000)
                                                              .configMaskColor([UIColor colorWithWhite:0.0 alpha:0.2])
                                                              .configAnimationType(type);
    [CCAlert alertCustomView:view configuration:configuration];
}

- (void)jump2MediaFormatFactoryController {
    CCMeidaFormatFactoryTestController *ctl = [[CCMeidaFormatFactoryTestController alloc] init];
//    ctl.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ctl animated:YES completion:nil];
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
