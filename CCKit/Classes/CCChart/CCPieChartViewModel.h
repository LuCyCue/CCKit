//
//  CCPieChartViewModel.h
//  LCCKit
//
//  Created by chengchanglu on 2021/7/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCPieChartNumberRoundType) {
    /// 不舍位
    CCPieChartNumberRoundNone,
    /// 四舍五入
    CCPieChartNumberRoundRound,
    /// 向下取整
    CCPieChartNumberRoundFloor,
    /// 向上取整
    CCPieChartNumberRoundCeil,
};

NS_ASSUME_NONNULL_BEGIN


@interface CCPieChartItem : NSObject
//颜色
@property (nonatomic, strong) UIColor *color;
//数值
@property (nonatomic, assign) NSUInteger dataNum;

- (instancetype)initWithNum:(NSUInteger)dataNum color:(UIColor *)color;

@end

@interface CCPieChartViewModel : NSObject
//数据源
@property (nonatomic, copy) NSArray<CCPieChartItem *> *dataItems;
//是否通过加载动画绘制
@property (nonatomic, assign) BOOL enableAnimation;
//内部空心圆所占比率（0-1）
@property (nonatomic, assign) CGFloat innerRadius;
//中间统计数据文本
@property (nonatomic, copy) NSString *numTitle;
//中间描述文本
@property (nonatomic, copy) NSString *detail;
//中间统计数据颜色
@property (nonatomic, strong) UIColor *numberTextColor;
//中间描述数据颜色
@property (nonatomic, strong) UIColor *detailTextColor;
//中间统计数据字体
@property (nonatomic, strong) UIFont *numberFont;
//中间描述数据字体
@property (nonatomic, strong) UIFont *detailFont;
//数字舍位类型
@property (nonatomic, assign) CCPieChartNumberRoundType numberRoundType;
//绘图起始位置
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *strokeStartArray;
//绘图终点位置
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *strokeEndArray;
@end

NS_ASSUME_NONNULL_END
