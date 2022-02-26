//
//  NSDictionary+CCSafe.h
//  CCKit
//
//  Created by lucc on 2021/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CCSafe)

+ (BOOL)cc_isValid:(NSDictionary *)dic;

- (id)cc_safeObjectForKey:(id)key;

- (int)cc_safeIntValueForKey:(id)key;

- (double)cc_safeDoubleValueForKey:(id)key;

- (NSString *)cc_safeStringValueForKey:(id)key;

@end

@interface NSMutableDictionary (CCSafe)

- (void)cc_safeSetObject:(id)object forKey:(id)key;

- (void)cc_setIntValue:(int)value forKey:(id)aKey;

- (void)cc_setDoubleValue:(double)value forKey:(id)aKey;

- (void)cc_safeRemoveObjectForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
