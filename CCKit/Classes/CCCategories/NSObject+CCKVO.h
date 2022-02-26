//
//  NSObject+KVO.h
//  OCTest
//
//  Created by lucc on 2019/6/28.
//  Copyright © 2019年 lucc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kvoBlock)(id target, id newVal, id oldVal);

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CCKVO)

/**
 添加kvo

 @param keyPath 监听路径
 @param changeBlock 回调
 */
- (void)cc_addObserveKeyPath:(NSString *)keyPath changeBlock:(kvoBlock)changeBlock;

/**
 添加回调在主线程kvo

 @param keyPath 监听路径
 @param changeBlock 回调
 */
- (void)cc_addObserveOnMainThreadKeyPath:(NSString *)keyPath changeBlock:(kvoBlock)changeBlock;

/**
 移除kvo

 @param keyPath 监听路径
 */
- (void)cc_removeObserveKeyPath:(NSString *)keyPath;

/**
 移除所有的kvo
 */
- (void)cc_removeObserveAll;

@end

NS_ASSUME_NONNULL_END
