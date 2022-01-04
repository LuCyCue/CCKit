//
//  CCNavigaitonEnablePopGestureInterface.h
//  LCCKit
//
//  Created by HuanZheng on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CCNavigaitonEnablePopGestureInterface <NSObject>

/// 开启/关闭 侧滑返回手势
- (BOOL)enableInteractivePopGesture;

@end

NS_ASSUME_NONNULL_END
