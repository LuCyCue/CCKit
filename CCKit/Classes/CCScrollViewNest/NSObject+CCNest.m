//
//  NSObject+CCNest.m
//  ScrollViewNestDemo
//
//  Created by lucc on 2022/3/1.
//

#import "NSObject+CCNest.h"
#import <UIKit/UIKit.h>
#import "UIScrollView+CCNest.h"

@implementation NSObject (CCNest)

- (void)cc_scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"cc_scrollViewDidScroll");
    if (scrollView.role == CCNestScrollRoleFather) {
        if (!scrollView.canScroll) {
            scrollView.contentOffset = CGPointMake(0, scrollView.criticalOffset);
            scrollView.childScrollView.canScroll = YES;
        } else {
            if (scrollView.contentOffset.y >= scrollView.criticalOffset) {
                scrollView.contentOffset = CGPointMake(0, scrollView.criticalOffset);
                if (scrollView.canScroll) {
                    scrollView.canScroll = NO;
                    scrollView.childScrollView.canScroll = YES;
                }
            }
        }
    } else if (scrollView.role == CCNestScrollRoleChild){
        if (!scrollView.canScroll) {
            scrollView.contentOffset = CGPointMake(0, scrollView.criticalOffset);
        } else {
            if (scrollView.contentOffset.y <= scrollView.criticalOffset-1) {
                scrollView.canScroll = NO;
                scrollView.superSrcollView.canScroll = YES;
            }
        }
    }
    if ([self respondsToSelector:@selector(cc_scrollViewDidScroll:)]) {
        [self cc_scrollViewDidScroll:scrollView];
    }
}

@end
