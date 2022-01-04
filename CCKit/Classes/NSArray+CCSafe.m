//
//  NSArray+CCSafe.m
//  CCKit
//
//  Created by lucc on 2021/6/8.
//

#import "NSArray+CCSafe.h"

@implementation NSArray (CCSafe)

+ (BOOL)cc_isValid:(NSArray *)arr {
    if (nil != arr && [arr isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

- (id)cc_safeObjectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        return nil;
    }
    id obj = [self objectAtIndex:index];
    
    //确保返回对象不为NSNull
    if(obj && ![obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    return nil;
}

@end

@implementation NSMutableArray (CCSafe)

- (void)cc_safeAddObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void)cc_safeRemoveObject:(id)anObject {
    if (anObject) {
        [self removeObject:anObject];
    }
}

- (void)cc_safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index >= self.count || index <= 0) {
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)cc_safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject || index < 0 || index > self.count) {
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)cc_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < 0 || index >= self.count || !anObject) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}

- (void)cc_safeAddArray:(NSArray *)array {
    if (!array) {
        return;
    }
    [self addObjectsFromArray:array];
}

@end
