//
//  CCDatePicker.m
//  LCCKit
//
//  Created by lucc on 2022/12/12.
//

#import "CCDatePicker.h"
#import <Masonry/Masonry.h>
#import "CCDatePickerTool.h"

@interface CCDatePicker ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger componentsNum;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CCDatePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(22);
            make.centerX.mas_equalTo(0);
        }];
        [self addSubview:self.doneBtn];
        [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.right.mas_equalTo(-17);
            make.size.mas_equalTo(CGSizeMake(48, 30));
        }];
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(100);
            make.bottom.mas_equalTo(-38);
        }];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

/// 配置数据（必须调用）
- (void)configData {
    if (!self.startDate) {
        self.startDate = [NSDate date];
    }
    if (!self.endDate) {
        self.endDate = [NSDate date];
    }
    if ([self.endDate compare:self.startDate] == NSOrderedAscending) {
        self.startDate = self.endDate;
    }
    if (self.type == CCDatePickerTypeMonth) {
        self.componentsNum = 2;
        NSArray *months = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
        NSInteger startYear = [CCDatePickerTool year:self.startDate];
        NSInteger endYear = [CCDatePickerTool year:self.endDate];
        if (!self.defaultSelectDate ||
            [self.defaultSelectDate compare:self.endDate] == NSOrderedDescending ||
            [self.defaultSelectDate compare:self.startDate] == NSOrderedAscending) {
            self.defaultSelectDate = self.endDate;
        }
        NSInteger selectYear = [CCDatePickerTool year:self.defaultSelectDate];
        NSInteger selectMonth = [CCDatePickerTool month:self.defaultSelectDate];
        NSMutableArray *years = [NSMutableArray array];
        for (NSInteger i = startYear; i <= endYear; i++) {
            [years addObject:@(i).stringValue];
        }
        NSInteger selectRowM = 0;
        NSInteger selectRowY = 0;
        if (selectYear == startYear) {
            NSInteger startMonth = [CCDatePickerTool month:self.startDate];
            NSInteger endMonth = [CCDatePickerTool month:self.endDate];
            if (startYear == endYear) {
                months = [months subarrayWithRange:NSMakeRange(startMonth-1, endMonth-startMonth+1)];
            } else {
                months = [months subarrayWithRange:NSMakeRange(startMonth-1, 13-startMonth)];
            }
            selectRowM = selectMonth- [CCDatePickerTool month:self.startDate];
            selectRowY = 0;
        } else if (selectYear == endYear) {
            months = [months subarrayWithRange:NSMakeRange(0, [CCDatePickerTool month:self.endDate])];
            selectRowM = selectMonth-1;
            selectRowY = years.count-1;
        } else {
            selectRowM = selectMonth-1;
            selectRowY = selectYear-startYear;
        }
        
        [self.dataSource addObjectsFromArray:@[months, years]];
        [self.pickerView selectRow:selectRowM inComponent:0 animated:YES];
        [self.pickerView selectRow:selectRowY inComponent:1 animated:YES];
    }
}

- (void)doneBtnAction:(UIButton *)sender {
    if (self.type == CCDatePickerTypeMonth) {
        NSInteger month = [self.pickerView selectedRowInComponent:0];
        NSInteger year = [self.pickerView selectedRowInComponent:1];
        NSString *y = self.dataSource[1][year];
        NSInteger m = month + 1;
        NSString *ret = @"";
        NSInteger startMonth = [CCDatePickerTool month:self.startDate];
        if (y.integerValue == [CCDatePickerTool year:self.startDate]) {
            ret = [NSString stringWithFormat:@"%@-%.2d",y, (int)(m+startMonth-1)];
        } else {
            ret = [NSString stringWithFormat:@"%@-%.2d",y, (int)m];
        }
        !self.doneHandler ?: self.doneHandler(ret);
    }
    
}

#pragma mark -- UIPickerViewDataSource,UIPickerViewDelegate

//显示列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.componentsNum;
}

//每列显示行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *array = self.dataSource[component];
    return array.count;
}

// 每列宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = self.bounds.size.width / self.componentsNum;
    return width;
}

// 每行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

// 数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *array = self.dataSource[component];
    NSString *name = array[row];
    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.type == CCDatePickerTypeMonth) {
        if (component == 1) {
            NSInteger startMonth = [CCDatePickerTool month:self.startDate];
            NSInteger endMonth = [CCDatePickerTool month:self.endDate];
            NSArray *years = self.dataSource[1];
            NSArray *months = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
            if (row == 0) {
                months = [months subarrayWithRange:NSMakeRange(startMonth-1, 13-startMonth)];
            } else if (row == years.count-1) {
                months = [months subarrayWithRange:NSMakeRange(0, endMonth)];
            }
            [self.dataSource replaceObjectAtIndex:0 withObject:months];
            [self.pickerView reloadComponent:0];
        }
    }
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:14];
        _titleLab.textColor = UIColor.blackColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"请选择时间";
    }
    return _titleLab;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _doneBtn.backgroundColor = UIColor.redColor;
        _doneBtn.layer.cornerRadius = 8.0f;
        [_doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
