//
//  CCLetterIndexViewController.m
//  CCKit_Example
//
//  Created by Lucc on 2022/2/23.
//  Copyright © 2022 Lucyfa. All rights reserved.
//

#import "CCLetterIndexViewController.h"
#import "CCLetterIndexView.h"
#import "CCKit.h"
#import "NSString+CCAdd.h"

@interface CCLetterIndexViewController ()<UITableViewDelegate, UITableViewDataSource, CCLetterIndexViewDataSource, CCLetterIndexViewDelegate>
@property (nonatomic, strong) CCLetterIndexView *letterIndexView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CCLetterIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindData];
}

- (void)setupViews {
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.letterIndexView];
}

- (void)bindData {
    self.dataSource = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *srcString = @"2月22日，《中共中央 国务院关于做好2022年全面推进乡村振兴重点工作的意见》，即2022年中央一号文件发布。这是21世纪以来第19个指导“三农”工作的中央一号文件。文件指出，牢牢守住保障国家粮食安全和不发生规模性返贫两条底线，突出年度性任务、针对性举措、实效性导向，充分发挥农村基层党组织领导作用，扎实有序做好乡村发展、乡村建设、乡村治理重点工作，推动乡村振兴取得新进展、农业农村现代化迈出新步伐。";
    for (int i = 0; i < 1000; i++) {
        NSString *randStr1 = [srcString substringWithRange:NSMakeRange(arc4random_uniform((uint32_t)srcString.length), 1)];
        NSString *randStr2 =  [srcString substringWithRange:NSMakeRange(arc4random_uniform((uint32_t)srcString.length), 1)];
        NSString *title = [NSString stringWithFormat:@"%@%@", randStr1, randStr2];
        NSString *firstLetter = [title cc_getFirstLetter];
        NSMutableArray *array = [dict objectForKey:firstLetter];
        if (!array) {
            array = [NSMutableArray array];
            [dict setObject:array forKey:firstLetter];
        }
        [array addObject:title];
    }
    for (int i = 'A'; i <= 'Z'; i++) {
        NSString *firstLetter = [NSString stringWithUTF8String:(const char *)&i];
        [self orderDataWithDict:dict firstLetter:firstLetter];
    }
    [self orderDataWithDict:dict firstLetter:@"#"];
    [self.tableView reloadData];
    [self.letterIndexView reload];
}

/// 对指定首字母数据内容进行处理
- (void)orderDataWithDict:(NSMutableDictionary *)dict firstLetter:(NSString *)firstLetter {
    if (firstLetter.length == 0) {
        return;
    }
    NSMutableArray *array = [dict objectForKey:firstLetter];
    if ([array count]) {
        [array sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
            return [obj1 localizedCompare:obj2];
        }];
        [self.titleArray addObject:firstLetter];
        [self.dataSource addObject:array];
    }
}

#pragma mark - UITableViewDataSource  && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = [self.dataSource objectAtIndex:section];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = [self.dataSource objectAtIndex:indexPath.section];
    NSString *title = [items objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.text = title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.letterIndexView tableView:tableView willDisplayHeaderView:view forSection:section];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.letterIndexView tableView:tableView didEndDisplayingHeaderView:view forSection:section];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.letterIndexView scrollViewDidScroll:scrollView];
}

#pragma mark - CCLetterIndexViewDataSource && CCLetterIndexViewDelegate

- (NSArray<NSString *> *)sectionIndexTitles {
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self.titleArray];
    return resultArray;
}

//当前选中组
- (void)selectedSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//将指示器视图添加到当前视图上
- (void)addIndicatorView:(UIView *)view {
    [self.view addSubview:view];
}

#pragma mark - Getter

- (CCLetterIndexView *)letterIndexView {
    if (!_letterIndexView) {
        _letterIndexView = [[CCLetterIndexView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-60, 60, 30, UIScreen.mainScreen.bounds.size.height-60)];
        _letterIndexView.dataSource = self;
        _letterIndexView.delegate = self;
        _letterIndexView.vibrationOn = YES;
        _letterIndexView.searchOn = NO;
        _letterIndexView.titleColor = UIColor.redColor;
        _letterIndexView.titleFontSize = 10;
    }
    return _letterIndexView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)) style:UITableViewStylePlain];
        _tableView.separatorColor = UIColor.lightGrayColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.001;
        _tableView.sectionFooterHeight = 0.001;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
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
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

@end
