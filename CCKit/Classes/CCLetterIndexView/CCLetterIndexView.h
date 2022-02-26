//
//  CCLetterIndexView.h
//
//  Created by Lucc on 2022/1/18.
//
// 首字母索引控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 代理方法 */
@protocol CCLetterIndexViewDelegate <NSObject>

@required
/** 当前选中下标 */
- (void)selectedSectionIndexTitle:(NSString *_Nullable)title atIndex:(NSInteger)index;
/** 添加指示器视图 */
- (void)addIndicatorView:(UIView *_Nullable)view;

@end

/** 数据源方法 */
@protocol  CCLetterIndexViewDataSource <NSObject>

/** 组标题数组 */
- (NSArray<NSString *> *_Nullable)sectionIndexTitles;

@end

@interface CCLetterIndexView : UIControl
//代理
@property (nonatomic, weak, nullable) id<CCLetterIndexViewDelegate> delegate;
//数据源
@property (nonatomic, weak, nullable) id<CCLetterIndexViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat titleFontSize;                                    /**< 字体大小 */
@property (nonatomic, strong, nullable) UIColor * titleColor;                           /**< 字体颜色 */
@property (nonatomic, assign) CGFloat marginRight;                                      /**< 右边距 */
@property (nonatomic, assign) CGFloat titleSpace;                                       /**< 文字间距 */
@property (nonatomic, assign) CGFloat indicatorMarginRight;                             /**< 指示器视图距离右侧的偏移量 */
//设置 --> 声音与触感 --> 系统触感反馈打开
@property (nonatomic, assign) BOOL vibrationOn;                                         /**< 开启震动反馈 (iOS10及以上) */
@property (nonatomic, assign) BOOL searchOn;                                            /**< 开启搜索功能  */

/// 设置当前选中组
- (void)setSelectionIndex:(NSInteger)index;

/// 以下方法同 tableviewdelegate 的方法
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/// 重新加载
- (void)reload;

@end

NS_ASSUME_NONNULL_END
