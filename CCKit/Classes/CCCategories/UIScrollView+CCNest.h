//
//  UIScrollView+CCNest.h
//  Pods
//
//  Created by lucc on 2022/2/27.
//
// UIScrollView 相互嵌套方案

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (CCNest)
@property (nonatomic, assign) BOOL hookGestureDelegate;
@property (nonatomic, assign) BOOL shouldRecognizeSimultaneously;
@end

NS_ASSUME_NONNULL_END
