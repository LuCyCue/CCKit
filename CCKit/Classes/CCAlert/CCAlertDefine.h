//
//  CCAlertDefine.h
//  Pods
//
//  Created by lucc on 2022/6/13.
//

#ifndef CCAlertDefine_h
#define CCAlertDefine_h

/// 弹窗位置
typedef NS_ENUM(NSUInteger, CCAlertPosition) {
    CCAlertPositionCenter,  //居中
    CCAlertPositionBottom,  //居底部
    CCAlertPositionTop,     //居顶部
};

/// 弹窗动画
typedef NS_ENUM(NSUInteger, CCAlertAnimation) {
    CCAlertAnimationFade,  //渐变
    CCAlertAnimationTop,   //从上面进入
    CCAlertAnimationLeft,  //从左边进入
    CCAlertAnimationBottom,//从底部进入
    CCAlertAnimationRight  //从右边进入
};

#endif /* CCAlertDefine_h */
