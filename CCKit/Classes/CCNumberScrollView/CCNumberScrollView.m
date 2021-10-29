//
//  CCNumberScrollView.m
//  LCCKit
//
//  Created by lucc on 2021/9/10.
//

#import "CCNumberScrollView.h"
#import "CCNumberTableView.h"

@interface CCNumberScrollView()
@property (nonatomic, strong) NSMutableArray<CCNumberTableView *> *numberViews;
@property (nonatomic, copy) NSArray *oldNumArray;
@property (nonatomic, copy) NSArray *refreshNumArray;
@end

@implementation CCNumberScrollView

- (instancetype)initWithFrame:(CGRect)frame config:(CCNumberScrollViewConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
    }
    return self;
}

- (void)setNum:(NSInteger)num {
    if (_num == num) {
        return;
    }
    [self.numberViews enumerateObjectsUsingBlock:^(CCNumberTableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.numberViews removeAllObjects];
    NSMutableArray *newNumArray = [NSMutableArray array];
    NSString *tempStr = @(num).stringValue;
    [tempStr enumerateSubstringsInRange:NSMakeRange(0, tempStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [newNumArray addObject:substring];
        if (newNumArray.count >= self.config.maxDigits) {
            *stop = YES;
        }
    }];
    if (self.config.needFillZero && newNumArray.count < self.config.maxDigits) {
        NSInteger fillNum = self.config.maxDigits - newNumArray.count;
        for (int i = 0; i < fillNum; i++) {
            [newNumArray insertObject:@"0" atIndex:0];
        }
    }
    self.refreshNumArray = [newNumArray copy];
    NSUInteger numbersViewCount = MAX(self.oldNumArray.count, self.refreshNumArray.count);
    CGFloat width = self.bounds.size.width / numbersViewCount;
    CGFloat height = CGRectGetHeight(self.bounds);
    if (self.oldNumArray.count == 0) {
        self.oldNumArray = [newNumArray copy];
        for (int j = 0; j < numbersViewCount; j++) {
            CCNumberTableView *tableView = [[CCNumberTableView alloc] initWithFrame:CGRectMake(j * width, 0, width, height)];
            tableView.font = self.config.font;
            tableView.textColor = self.config.textColor;
            NSString *newValue = @"";
            if (j < self.refreshNumArray.count) {
                newValue = [self.refreshNumArray objectAtIndex:j];
            }
            tableView.dataSource = @[newValue];
            [self.numberViews addObject:tableView];
            [self addSubview:tableView];
            [tableView reloadData];
        }
        return;
    }
    [self doChangeNumAnimation];
    self.oldNumArray = [newNumArray copy];
    _num = num;
}

- (void)doChangeNumAnimation {
    NSUInteger numbersViewCount = MAX(self.oldNumArray.count, self.refreshNumArray.count);
    CGFloat width = self.bounds.size.width / numbersViewCount;
    CGFloat height = CGRectGetHeight(self.bounds);
    for (int j = 0; j < numbersViewCount; j++) {
        CCNumberTableView *tableView = [[CCNumberTableView alloc] initWithFrame:CGRectMake(j * width, 0, width, height)];
        tableView.font = self.config.font;
        tableView.textColor = self.config.textColor;
        NSString *oldValue = @"";
        if (j < self.oldNumArray.count) {
            oldValue = [self.oldNumArray objectAtIndex:j];
        }
        NSString *newValue = @"";
        if (j < self.refreshNumArray.count) {
            newValue = [self.refreshNumArray objectAtIndex:j];
        }
        tableView.dataSource = @[oldValue, newValue];
        tableView.animationDuration = self.config.animationDuration;
        [self.numberViews addObject:tableView];
        [self addSubview:tableView];
        [tableView reloadData];
    }
    for (int x = 0; x < numbersViewCount; x++) {
        NSString *oldValue = @"";
        if (x < self.oldNumArray.count) {
            oldValue = [self.oldNumArray objectAtIndex:x];
        }
        NSString *newValue = @"";
        if (x < self.refreshNumArray.count) {
            newValue = [self.refreshNumArray objectAtIndex:x];
        }
        if (![oldValue isEqualToString:newValue]) {
            CCNumberTableView *tableView = [self.numberViews objectAtIndex:x];
            [tableView layoutIfNeeded];
            [tableView scrollToIndex:1];
        }
    }
}

#pragma mark -Getter

- (NSMutableArray<CCNumberTableView *> *)numberViews {
    if (!_numberViews) {
        _numberViews = [NSMutableArray array];
    }
    return _numberViews;
}

@end
