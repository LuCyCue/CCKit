//
//  NSArray+CCSafe.h
//  CCKit
//
//  Created by lucc on 2021/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CCSafe)

+ (BOOL)cc_isValid:(NSArray *)arr;

- (id)cc_safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (CCSafe)

- (void)cc_safeAddObject:(id)anObject ;

- (void)cc_safeRemoveObject:(id)anObject ;

- (void)cc_safeRemoveObjectAtIndex:(NSUInteger)index ;

- (void)cc_safeInsertObject:(id)anObject atIndex:(NSUInteger)index ;

- (void)cc_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)cc_safeAddArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
