//
//  CCNumberScrollView.h
//  LCCKit
//
//  Created by lucc on 2021/9/10.
//

#import <UIKit/UIKit.h>
#import "CCNumberScrollViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCNumberScrollView : UIView
//基本配置
@property (nonatomic, strong) CCNumberScrollViewConfig *config;
//展示数值
@property (nonatomic, assign) NSInteger num;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame config:(CCNumberScrollViewConfig *)config;

@end

NS_ASSUME_NONNULL_END
