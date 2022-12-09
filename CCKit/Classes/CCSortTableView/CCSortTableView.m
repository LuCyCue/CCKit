//
//  CCSortTableView.m
//  Pods
//
//  Created by lucc on 2022/11/29.
//

#import "CCSortTableView.h"

@interface CCSortTableView ()
@property (nonatomic, strong) UIView *snapView;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, assign) BOOL isCheckingScroll;
@end

@implementation CCSortTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.draggingCellAlpha = 0.8;
        self.draggingCellScale = 1.05;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

// cell长按拖动排序
- (void)longPressRecognizer:(UILongPressGestureRecognizer *)longPress{
    //获取长按的点及cell
    CGPoint location = [longPress locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    UIGestureRecognizerState state = longPress.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            if (indexPath) {
                self.lastIndexPath = indexPath;
                UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
                self.snapView = [self customViewWithTargetView:cell];
                __block CGPoint center = cell.center;
                self.snapView.center = center;
                self.snapView.alpha = 0.0;
                [self addSubview:self.snapView];
                [UIView animateWithDuration:0.1 animations:^{
                    center.y = location.y;
                    self.snapView.center = center;
                    self.snapView.transform = CGAffineTransformMakeScale(self.draggingCellScale, self.draggingCellScale);
                    self.snapView.alpha = self.draggingCellAlpha;
                    cell.alpha = 0.0;
                }];
            }
        }
        break;
        case UIGestureRecognizerStateChanged:{
            CGPoint center = self.snapView.center;
            center.y = location.y;
            self.snapView.center = center;
            UITableViewCell *cell = [self cellForRowAtIndexPath:self.lastIndexPath];
            cell.alpha = 0.0;
            if (indexPath && ![indexPath isEqual:self.lastIndexPath]) {
                if (self.cc_dataSource && [self.cc_dataSource respondsToSelector:@selector(CC_tableView:moveRowAtIndexPath:toIndexPath:)]) {
                    [self.cc_dataSource CC_tableView:self moveRowAtIndexPath:self.lastIndexPath toIndexPath:indexPath];
                }
                [self moveRowAtIndexPath:self.lastIndexPath toIndexPath:indexPath];
                self.lastIndexPath = indexPath;
            }
            if (!indexPath) {
                return;
            }
            NSDictionary *dic = @{
                @"locationY": @(location.y),
                @"indexPath": indexPath,
                @"cellHeight": @(cell.bounds.size.height)
            };
            if (!self.isCheckingScroll) {
                [self checkScroll:dic];
                self.isCheckingScroll = YES;
            }
           
        }
        break;
        default:{
            UITableViewCell *cell = [self cellForRowAtIndexPath:self.lastIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                self.snapView.center = cell.center;
                self.snapView.transform = CGAffineTransformIdentity;
                self.snapView.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self.snapView removeFromSuperview];
                self.snapView = nil;
            }];
            self.lastIndexPath = nil;
        }
        break;
    }
}

//截取选中cell
- (UIView *)customViewWithTargetView:(UIView *)target{
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, NO, 0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.6;
    return snapshot;
}

- (void)checkScroll:(NSDictionary *)param {
    NSNumber *y = [param objectForKey:@"locationY"];
    NSNumber *cellHeight = [param objectForKey:@"cellHeight"];
    NSIndexPath *indexPath = [param objectForKey:@"indexPath"];
    NSLog(@"%@", indexPath);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isCheckingScroll = NO;
    });
    if (y.floatValue + cellHeight.floatValue > self.bounds.size.height + self.contentOffset.y) {
        NSInteger allRows = [self.dataSource tableView:self numberOfRowsInSection:indexPath.section];
        if (indexPath.row >= allRows-1) {
            return;
        }
        [self setContentOffset:CGPointMake(0, self.contentOffset.y+cellHeight.floatValue) animated:YES];
    } else if (y.floatValue < self.contentOffset.y+cellHeight.floatValue    ) {
        if (indexPath.row == 0) {
            return;
        }
        [self setContentOffset:CGPointMake(0, self.contentOffset.y-cellHeight.floatValue) animated:YES];
    }
}

@end
