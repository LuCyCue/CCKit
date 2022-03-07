//
//  CCPieChartViewModel.m
//  LCCKit
//
//  Created by chengchanglu on 2021/7/13.
//

#import "CCPieChartViewModel.h"

@implementation CCPieChartItem

- (instancetype)initWithNum:(NSUInteger)dataNum color:(UIColor *)color; {
    self = [super init];
    if (self) {
        _color = color;
        _dataNum = dataNum;
    }
    return self;
}

@end

@interface CCPieChartViewModel () {
    NSMutableArray *__strokeStartArray;
    NSMutableArray *__strokeEndArray;
}

@end

@implementation CCPieChartViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.innerRadius = 0.6;
        self.numberFont = [UIFont boldSystemFontOfSize:16];
        self.detailFont = [UIFont systemFontOfSize:12];
        self.numberTextColor = UIColor.blackColor;
        self.detailTextColor = UIColor.lightGrayColor;
        self.numberRoundType = CCPieChartNumberRoundNone;
        self.animationDuration = 2.f;
    }
    return self;
}

#pragma mark - Setter

- (void)setDataItems:(NSArray<CCPieChartItem *> *)dataItems {
    _dataItems = dataItems;
    NSMutableArray *startArray = [NSMutableArray array];
    NSMutableArray *endArray = [NSMutableArray array];
    //计算总count
    __block CGFloat count = 0;
    [dataItems enumerateObjectsUsingBlock:^(CCPieChartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count = count + obj.dataNum;
    }];
    //计算start比例
    __block CGFloat priorCount = 0;
    [dataItems enumerateObjectsUsingBlock:^(CCPieChartItem * _Nonnull obj, NSUInteger idx,
                                            BOOL* _Nonnull stop) {
        CGFloat sResult = priorCount / count;
        CGFloat eResult = (priorCount + obj.dataNum) / count;
        switch (self.numberRoundType) {
            case CCPieChartNumberRoundCeil:
                sResult = ceil(sResult * 100) / 100;
                eResult = ceil(eResult * 100) / 100;
                break;
            case CCPieChartNumberRoundFloor:
                sResult = floor(sResult * 100) / 100;
                eResult = floor(eResult * 100) / 100;
                break;
            case CCPieChartNumberRoundRound:
                sResult = round(sResult * 100) / 100;
                eResult = round(eResult * 100) / 100;
                break;

            default:
                break;
        }
        priorCount = priorCount + obj.dataNum;
        //添加到数组中
        [startArray addObject:@(sResult)];
        [endArray addObject:@(eResult)];
    }];
    __strokeStartArray = startArray;
    __strokeEndArray = endArray;
}

#pragma mark - Getter

- (NSArray<NSNumber *> *)strokeEndArray {
    return __strokeEndArray;
}

- (NSArray<NSNumber *> *)strokeStartArray {
    return __strokeStartArray;
}

@end
