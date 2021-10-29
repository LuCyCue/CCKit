//
//  CCNumberTableView.h
//  LCCKit
//
//  Created by lucc on 2021/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCNumberTableView : UIView

@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat animationDuration;

- (void)scrollToIndex:(NSUInteger)index;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
