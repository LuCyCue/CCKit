//
//  CCNumberScrollCell.h
//  LCCKit
//
//  Created by lucc on 2021/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCNumberScrollCell : UITableViewCell

- (void)reloadCellWithNum:(NSString *)num font:(UIFont *)font textColor:(UIColor *)textColor;

@end

NS_ASSUME_NONNULL_END
