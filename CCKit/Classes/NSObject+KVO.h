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

@interface NSObject (KVO)

- (void)cc_addObserveKeyPath:(NSString *)keyPath changeBlock:(kvoBlock)changeBlock;
- (void)cc_addObserveOnMainThreadKeyPath:(NSString *)keyPath changeBlock:(kvoBlock)changeBlock;
- (void)cc_removeObserveKeyPath:(NSString *)keyPath;
- (void)cc_removeObserveAll;

@end

NS_ASSUME_NONNULL_END
