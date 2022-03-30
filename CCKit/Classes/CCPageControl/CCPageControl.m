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
    [self.dotsArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    CGFloat width = [self dotsWidth];
    CGFloat x = MAX((self.frame.size.width - width) / 2, 0);
    CGFloat y = MAX((self.frame.size.height - self.dotSize.height) / 2, 0);
    for (int i = 0; i < numberOfPages; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(x + i * (self.dotSize.width + self.spacing), y, self.dotSize.width, self.dotSize.height);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = self.dotSize.width / 2;
        btn.backgroundColor = (i == self.currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor);
        [btn setImage:(i == self.currentPage ? self.currentPageIndicatorImage : self.pageIndicatorImage) forState:UIControlStateNormal];
        [self addSubview:btn];
        [self.dotsArray addObject:btn];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.dotsArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = (idx == self.currentPage ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor);
        [obj setImage:(idx == self.currentPage ? self.currentPageIndicatorImage : self.pageIndicatorImage) forState:UIControlStateNormal];
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
