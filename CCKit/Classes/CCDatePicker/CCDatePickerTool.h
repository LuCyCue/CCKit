//
//  CCDatePickerTool.h
//  LCCKit
//
//  Created by lucc on 2022/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCDatePickerTool : NSObject

+ (NSInteger)year:(NSDate *)date;

+ (NSInteger)month:(NSDate *)date;

+ (NSInteger)day:(NSDate *)date;

+ (NSInteger)hour:(NSDate *)date;

+ (NSInteger)minute:(NSDate *)date;

+ (NSInteger)second:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
