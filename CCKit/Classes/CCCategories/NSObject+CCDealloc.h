//
//  NSObject+dealloc.h
//  OCTest
//
//  Created by lucc on 2019/6/24.
//  Copyright © 2019年 lucc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CCDeallocBlock)(id owner);

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CCDealloc)

- (void)cc_addDeallocBlock:(CCDeallocBlock)callBack;

@end

NS_ASSUME_NONNULL_END
