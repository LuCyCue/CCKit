//
//  CCNumberTableView.h
//  LCCKit
//
//  Created by HuanZheng on 2021/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCNumberTableView : UIView

@property (nonatomic, strong) NSMutableArray<NSString *> *dataSource;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

- (void)scrollToIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
