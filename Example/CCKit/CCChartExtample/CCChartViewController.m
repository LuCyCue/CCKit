//
//  CCChartViewController.m
//  CCKit_Example
//
//  Created by chengchanglu on 2022/2/27.
//  Copyright © 2022 Lucyfa. All rights reserved.
//

#import "CCChartViewController.h"
#import "CCPieChartView.h"

@interface CCChartViewController ()
@property(nonatomic, strong) CCPieChartView *pieChart;
@end

@implementation CCChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    CCPieChartViewModel *viewModel = [[CCPieChartViewModel alloc] init];
    viewModel.enableAnimation = YES;
    viewModel.animationDuration = 5;
    CCPieChartItem *item1 = [[CCPieChartItem alloc] initWithNum:55 color:UIColor.greenColor];
    CCPieChartItem *item2 = [[CCPieChartItem alloc] initWithNum:24 color:UIColor.blueColor];
    CCPieChartItem *item3 = [[CCPieChartItem alloc] initWithNum:17 color:UIColor.redColor];
    viewModel.dataItems = @[item1, item2, item3];
    viewModel.numTitle = @"30%";
    viewModel.detail = @"测试饼图";
    self.pieChart.model = viewModel;
    [self.view addSubview:self.pieChart];
}

- (CCPieChartView *)pieChart {
    if (!_pieChart) {
        _pieChart = [[CCPieChartView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        _pieChart.backgroundColor = UIColor.lightTextColor;
    }
    return _pieChart;
}

@end
