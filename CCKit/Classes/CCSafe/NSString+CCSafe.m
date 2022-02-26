//
//  NSString+CCSafe.m
//  CCKit
//
//  Created by lucc on 2021/6/8.
//

#import "NSString+CCSafe.h"

@implementation NSString (CCSafe)

/// 返回非nil字符串，如果为nil则返回 @""
/// @param src 源字符串
+ (NSString *)cc_safeString:(NSString *)src {
    return src.length == 0 ? @"" : src;
}

/// 是否是空字符串
/// @param str 源字符串
+ (BOOL)cc_isEmptyStr:(NSString *)str {
    if (str && [str isKindOfClass:[NSString class]] && str.length) {
        return NO;
    } else {
        return YES;
    }
}

/// 是否为空白字符串
/// @param string 源字符串
+ (BOOL)cc_isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] &&
        [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

/// 查询子字符串的range
/// @param searchStr 子字符串
- (NSRange)cc_safeRangeOfString:(NSString *)searchStr {
    if (!searchStr || searchStr.length == 0) {
        return [self rangeOfString:@""];
    }
    return [self rangeOfString:searchStr];
}

/// 获取子字符串
/// @param index 起始值
- (NSString *)cc_safeSubstringFromIndex:(NSInteger)index {
    if (index < 0 || index > self.length) {
        return @"";
    }
    return [self substringFromIndex:index];
}

/// 获取子字符串
/// @param index 终点值
- (NSString *)cc_safeSubstringToIndex:(NSInteger)index {
    if (index < 0 || index > self.length) {
        return @"";
    }
    return [self substringToIndex:index];
}

/// 获取子字符串
/// @param range 范围
- (NSString *)cc_safeSubstringWithRange:(NSRange)range {
    if (range.location == NSNotFound || range.location < 0 || range.location + range.length > self.length) {
        return @"";
    }
    return [self substringWithRange:range];;
}

/// 替换字符串内容
/// @param target 目标字符串
/// @param replacement 用于替换字符串
- (NSString *)cc_safeStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    if (target == nil || replacement == nil) {
        return self;
    }
    return [self stringByReplacingOccurrencesOfString:target withString:replacement];
}

/// 替换字符串内容
/// @param range 目标字符串所处范围
/// @param replacement 用于替换字符串
- (NSString *)cc_safeStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    if (replacement == nil || range.location == NSNotFound || range.location < 0 || range.location + range.length > self.length) {
        return self;
    }
    return [self stringByReplacingCharactersInRange:range withString:replacement];
}

/// 拼接字符串
/// @param aString 被拼接子字符串
- (NSString *)cc_safeStringByAppendingString:(NSString *)aString {
    return [self stringByAppendingString:[NSString cc_safeString:aString]];
}

@end
