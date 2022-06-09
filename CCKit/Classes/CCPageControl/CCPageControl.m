//
//  CCPageControl.m
//  Pods
//
//  Created by lucc on 2022/3/30.
//

#import "CCPageControl.h"

@interface CCPageControl ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *dotsArray;
@end

@implementation CCPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dotSize = CGSizeMake(3, 3);
        self.spacing = 5;
        self.pageIndicatorTintColor = UIColor.lightGrayColor;
        self.currentPageIndicatorTintColor = UIColor.whiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = [self dotsWidth];
    CGFloat x = MAX((self.frame.size.width - width) / 2, 0);
    CGFloat y = MAX((self.frame.size.height - self.dotSize.height) / 2, 0);
    if (self.alignment == CCPageControlAlignmentRight) {
        x = MAX((self.frame.size.width - width), 0);
    }
    [self.dotsArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(x + idx * (self.dotSize.width + self.spacing), y, self.dotSize.width, self.dotSize.height);
    }];
}

- (CGFloat)dotsWidth {
    CGFloat width = 0;
    if (self.numberOfPages <= 1) {
        width = self.dotSize.width;
    } else {
        width = self.numberOfPages * self.dotSize.width + self.spacing * (self.numberOfPages - 1);
    }
    return width;
}

#pragma mark - Setter

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    if (numberOfPages == 1 && self.hidesForSinglePage) {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    [self.dotsArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.dotsArray removeAllObjects];
    CGFloat width = [self dotsWidth];
    CGFloat x = MAX((self.frame.size.width - width) / 2, 0);
    CGFloat y = MAX((self.frame.size.height - self.dotSize.height) / 2, 0);
    if (self.alignment == CCPageControlAlignmentRight) {
        x = MAX((self.frame.size.width - width), 0);
    }
    for (int i = 0; i < numberOfPages; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(x + i * (self.dotSize.width + self.spacing), y, self.dotSize.width, self.dotSize.height);
        if (!self.useImage) {
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = self.dotSize.width / 2;
            if (i == self.currentPage) {
                btn.backgroundColor = self.currentPageIndicatorTintColor;
            } else {
                btn.backgroundColor = self.pageIndicatorTintColor;
            }
        } else {
            btn.backgroundColor = UIColor.clearColor;
            btn.imageView.contentMode = UIViewContentModeCenter;
            [btn setImage:self.currentDotImage forState:UIControlStateSelected];
            [btn setImage:self.dotImage forState:UIControlStateNormal];
            btn.selected = i == self.currentPage;
        }
        [self addSubview:btn];
        [self.dotsArray addObject:btn];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.dotsArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.useImage) {
            obj.selected = idx == currentPage;
        } else {
            obj.backgroundColor = idx == currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
        }
    }];
}

#pragma mark - Getter

- (NSMutableArray<UIButton *> *)dotsArray {
    if (!_dotsArray) {
        _dotsArray = [NSMutableArray array];
    }
    return _dotsArray;
}

@end
