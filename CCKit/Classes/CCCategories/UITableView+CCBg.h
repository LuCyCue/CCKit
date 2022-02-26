//
//  UITableView+CCBg.h
//  LCCKit
//
//  Created by lucc on 2021/9/18.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UITableView (CCBg)

/// 基于图片，图片不够长则平铺，添加跟随滚动的背景
/// @param image 图片
- (void)cc_addLongBgWithImage:(UIImage *)image;
/// 清除添加的背景
- (void)cc_removeLongBg;

@end

NS_ASSUME_NONNULL_END
