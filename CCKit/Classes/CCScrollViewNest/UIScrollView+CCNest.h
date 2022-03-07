//
//  UIScrollView+CCNest.h
//  Pods
//
//  Created by lucc on 2022/2/27.
//
// UIScrollView 相互嵌套方案

#import <UIKit/UIKit.h>

/// 嵌套方案中的角色
typedef NS_ENUM(NSUInteger, CCNestScrollRole) {
    CCNestScrollRoleNone,    //无
    CCNestScrollRoleChild,   //子scrollview
    CCNestScrollRoleFather,  //父scrollview
};


NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (CCNest)<UIGestureRecognizerDelegate>
//是否劫持手势代理
@property (nonatomic, assign) BOOL hookGestureDelegate;
//是否支持同时识别多手势
@property (nonatomic, assign) BOOL shouldRecognizeSimultaneously;
//嵌套模式下是否能滚动
@property (nonatomic, assign) BOOL canScroll;
//嵌套模式下角色
@property (nonatomic, assign) CCNestScrollRole role;
//临界偏移量（父scrollview为切换到子scrollview滚动的偏移值， 子scrollview 为切换到父scrollview滚动的偏移值）
@property (nonatomic, assign) CGFloat criticalOffset;
//子scrollview的父scrollview
@property (nonatomic, weak) UIScrollView *superSrcollView;
//父scrollview的子scrollview
@property (nonatomic, weak) UIScrollView *childScrollView;
@end

NS_ASSUME_NONNULL_END
