//
//  CCLetterSelectIndicatorView.h
//
//  Created by Lucc on 2022/1/18.
//
// 索引被选中时显示的view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCLetterSelectIndicatorView : UIView

/// 设置坐标和文本
/// @param origin 坐标
/// @param title 文本
- (void)setOrigin:(CGPoint)origin title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
