//
//  CCPageControl.h
//  Pods
//
//  Created by lucc on 2022/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPageControl : UIView
/// 点大小 默认（3，3）
@property (nonatomic, assign) CGSize dotSize;
/// 点间距 默认为 5
@property (nonatomic, assign) CGFloat spacing;
/// 总页数
@property (nonatomic, assign) NSInteger numberOfPages;
///当前页码
@property (nonatomic, assign) NSInteger currentPage;
/// 只有一个页是否需要隐藏
@property (nonatomic) BOOL hidesForSinglePage;
/// 为选中点颜色 (lightGrayColor)
@property (nullable, nonatomic, strong) UIColor *pageIndicatorTintColor;
/// 选中点颜色（white）
@property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor;
/// 未选中点图片
@property (nonatomic, strong) UIImage *pageIndicatorImage;
/// 选中点图片
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;
@end

NS_ASSUME_NONNULL_END
