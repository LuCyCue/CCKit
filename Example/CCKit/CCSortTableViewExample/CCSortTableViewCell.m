//
//  CCSortTableViewCell.m
//  CCKit_Example
//
//  Created by HuanZheng on 2022/12/12.
//  Copyright © 2022 Lucyfa. All rights reserved.
//

#import "CCSortTableViewCell.h"
#import "CCStrokeLabel.h"
#import <Masonry/Masonry.h>

@interface CCSortTableViewCell ()
@property (nonatomic, strong) CCStrokeLabel *titleLab;
@end

@implementation CCSortTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLab = [[CCStrokeLabel alloc] init];
        self.titleLab.strokeWidth = 1.5;
        self.titleLab.strokeColor = UIColor.blackColor;
        self.titleLab.textColor = UIColor.redColor;
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(16);
            make.right.mas_lessThanOrEqualTo(-16);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
    [self.titleLab starFlowingLightAnimation:UIColor.whiteColor intervalTime:2.0 animationTime:1.0];
}

@end
