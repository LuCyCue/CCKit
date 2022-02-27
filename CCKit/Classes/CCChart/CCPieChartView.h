//
//  CCPieChartView.h
//  LCCKit
//
//  Created by chengchanglu on 2021/7/13.
//
// 饼状图
#import <UIKit/UIKit.h>
#import "CCPieChartViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCPieChartView : UIView
//viewModel
@property (nonatomic, strong) CCPieChartViewModel *model;

//刷新
- (void)refreshPieChart;

@end

NS_ASSUME_NONNULL_END
