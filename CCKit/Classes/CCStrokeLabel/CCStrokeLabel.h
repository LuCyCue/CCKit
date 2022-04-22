//
//  CCStrokeLabel.h
//  LCCKit
//
//  Created by lucc on 2022/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCStrokeLabel : UILabel

/// 描边颜色
@property (nonatomic, strong) UIColor *strokeColor;

/// 描边大小
@property (nonatomic, assign) CGFloat strokeWidth;
@end

NS_ASSUME_NONNULL_END
