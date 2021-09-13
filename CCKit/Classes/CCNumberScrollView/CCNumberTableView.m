//
//  CCNumberTableView.m
//  LCCKit
//
//  Created by HuanZheng on 2021/9/10.
//

#import "CCNumberTableView.h"
#import "CCNumberScrollCell.h"

@interface CCNumberTableView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CCNumberTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)scrollToIndex:(NSUInteger)index {
    CGFloat offsetY = index * CGRectGetHeight(self.bounds);
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentOffset = CGPointMake(0, offsetY);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark -Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CCNumberScrollCell class] forCellReuseIdentifier:NSStringFromClass(CCNumberScrollCell.class)];
    }
    return _tableView;
}

#pragma mark -UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCNumberScrollCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CCNumberScrollCell.class)];
    if (self.dataSource.count > indexPath.row) {
        NSString *title = self.dataSource[indexPath.row];
        [cell reloadCellWithNum:title font:self.font textColor:self.textColor];
    }
    return cell;
}

@end
