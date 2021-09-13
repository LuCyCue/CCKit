//
//  CCNumberScrollCell.m
//  LCCKit
//
//  Created by lucc on 2021/9/10.
//

#import "CCNumberScrollCell.h"

@interface CCNumberScrollCell()
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation CCNumberScrollCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.numberLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.numberLabel.frame = self.contentView.bounds;
}

- (void)reloadCellWithNum:(NSString *)num font:(UIFont *)font textColor:(UIColor *)textColor {
    self.numberLabel.text = num;
    self.numberLabel.font = font;
    self.numberLabel.textColor = textColor;
}

#pragma mark -Getter

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = UIColor.blackColor;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

@end
