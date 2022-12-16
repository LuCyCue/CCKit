//
//  CCDatePicker.h
//  LCCKit
//
//  Created by lucc on 2022/12/12.
//

#import <UIKit/UIKit.h>

/// 选择时间类型
typedef NS_ENUM(NSUInteger, CCDatePickerType) {
    CCDatePickerTypeMonth, // 年-月 选择
};

NS_ASSUME_NONNULL_BEGIN

@interface CCDatePicker : UIView
//类型
@property (nonatomic, assign) CCDatePickerType type;
//起始时间
@property (nonatomic, strong) NSDate *startDate;
//结束时间
@property (nonatomic, strong) NSDate *endDate;
//选中时间（默认选中结束时间）
@property (nonatomic, strong) NSDate *defaultSelectDate;
//标题
@property (nonatomic, strong) UILabel *titleLab;
//完成按钮
@property (nonatomic, strong) UIButton *doneBtn;

//选中时间（根据不同type 返回）
@property (nonatomic, copy) void(^doneHandler)(NSString *dateStr);


/// 配置数据（必须调用）
- (void)configData;

@end

NS_ASSUME_NONNULL_END
