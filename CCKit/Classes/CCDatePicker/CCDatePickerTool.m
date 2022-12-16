//
//  CCDatePickerTool.m
//  LCCKit
//
//  Created by lucc on 2022/12/12.
//

#import "CCDatePickerTool.h"

@implementation CCDatePickerTool

+ (NSInteger)year:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
}

+ (NSInteger)month:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month];
}

+ (NSInteger)day:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date] day];
}

+ (NSInteger)hour:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:date] hour];
}

+ (NSInteger)minute:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:date] minute];
}

+ (NSInteger)second:(NSDate *)date {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:date] second];
}

@end
