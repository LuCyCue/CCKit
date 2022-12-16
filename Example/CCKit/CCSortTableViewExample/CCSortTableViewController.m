//
//  CCSortTableViewController.m
//  CCKit_Example
//
//  Created by HuanZheng on 2022/11/29.
//  Copyright © 2022 Lucyfa. All rights reserved.
//

#import "CCSortTableViewController.h"
#import "CCSortTableView.h"
#import "CCSortTableViewCell.h"

@interface CCSortTableViewController ()<UITableViewDelegate, UITableViewDataSource, CCSortTableViewDataSource>
@property (nonatomic, strong) CCSortTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CCSortTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-150);
    self.dataSource = [NSMutableArray array];
    for (int i = 0; i < 40; i++) {
        NSInteger data = arc4random_uniform(10000);
        [self.dataSource addObject:@(data)];
    }
    [self.tableView reloadData];
    
}

- (void)CC_tableView:(CCSortTableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CCSortTableViewCell.class)];
    cell.title = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CCSortTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CCSortTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.cc_dataSource = self;
        _tableView.sectionHeaderHeight = 0.001;
        _tableView.sectionFooterHeight = 0.001;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            if (@available(iOS 15.0, *)) {
                _tableView.sectionHeaderTopPadding = 0;
            }
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:CCSortTableViewCell.class forCellReuseIdentifier:NSStringFromClass(CCSortTableViewCell.class)];
    }
    return _tableView;
}

@end
