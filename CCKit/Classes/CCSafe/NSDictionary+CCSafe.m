//
//  NSDictionary+CCSafe.m
//  CCKit
//
//  Created by lucc on 2021/6/9.
//

#import "NSDictionary+CCSafe.h"

@implementation NSDictionary (CCSafe)

+ (BOOL)cc_isValid:(NSDictionary *)dic {
    if (nil != dic && [dic isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

- (id)cc_safeObjectForKey:(id)key {
    if (!key) {
        return nil;
    }
    id obj = [self objectForKey:key];
    //确保返回对象不为NSNull
    if(obj && ![obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    return nil;
}

- (int)cc_safeIntValueForKey:(id)key {
    id obj = [self cc_safeObjectForKey:key];
    if ([obj respondsToSelector:@selector(intValue)]) {
        return [obj intValue];
    }
    return 0;
}

- (double)cc_safeDoubleValueForKey:(id)key {
    id obj = [self cc_safeObjectForKey:key];
    if ([obj respondsToSelector:@selector(doubleValue)]) {
        return [obj doubleValue];
    }
    return 0.f;
}

- (NSString *)cc_safeStringValueForKey:(id)key {
    id obj = [self cc_safeObjectForKey:key];
    if ([obj respondsToSelector:@selector(stringValue)]) {
        return [obj stringValue];
    }
    return nil;
}

@end

@implementation NSMutableDictionary (ZTSafe)

- (void)cc_safeSetObject:(id)object forKey:(id)key {
    if (!object || !key) {
        return;
    }
    [self setObject:object forKey:key];
}

- (void)cc_setIntValue:(int)value forKey:(id)aKey {
    [self cc_safeSetObject:[[NSNumber numberWithInt:value] stringValue] forKey:aKey];
}

- (void)cc_setDoubleValue:(double)value forKey:(id)aKey {
    [self cc_safeSetObject:[[NSNumber numberWithDouble:value] stringValue] forKey:aKey];
    
}

- (void)cc_safeRemoveObjectForKey:(id)key {
    if (!key) {
        return;
    }
    [self removeObjectForKey:key];
}

@end
