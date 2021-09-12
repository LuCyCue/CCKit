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
@property (nonatomic, strong) NSNumber *dataNumber;

- (instancetype)initWithNumber:(NSNumber *)number color:(UIColor *)color;

@end

@interface CCPieChartViewModel : NSObject

@property (nonatomic, copy) NSArray<CCPieChartItem *> *dataItems;
@property (nonatomic, copy) NSString *numTitle;
@property (nonatomic, copy) NSString *detail;
//是否通过加载动画绘制
@property (nonatomic, assign) BOOL enableAnimation;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, strong) UIColor *numberFontColor;
@property (nonatomic, strong) UIColor *detailFontColor;
@property (nonatomic, assign) CGFloat numberFontSize;
@property (nonatomic, assign) CGFloat detailFontSize;
/// 数字舍位类型
@property (nonatomic, assign) CCPieChartNumberRoundType numberRoundType;

@end

NS_ASSUME_NONNULL_END
