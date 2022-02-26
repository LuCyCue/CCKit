//
//  NSString+CCSafe.h
//  CCKit
//
//  Created by lucc on 2021/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CCSafe)

/// 返回非nil字符串，如果为nil则返回 @""
/// @param src 源字符串
+ (NSString *)cc_safeString:(NSString *)src;

/// 是否是空字符串
/// @param str 源字符串
+ (BOOL)cc_isEmptyStr:(NSString *)str;

/// 是否为空白字符串
/// @param string 源字符串
+ (BOOL)cc_isBlankString:(NSString *)string;

/// 查询子字符串的range
/// @param searchStr 子字符串
- (NSRange)cc_safeRangeOfString:(NSString *)searchStr;

/// 获取子字符串
/// @param index 起始值
- (NSString *)cc_safeSubstringFromIndex:(NSInteger)index;

/// 获取子字符串
/// @param index 终点值
- (NSString *)cc_safeSubstringToIndex:(NSInteger)index;

/// 获取子字符串
/// @param range 范围
- (NSString *)cc_safeSubstringWithRange:(NSRange)range;

/// 替换字符串内容
/// @param target 目标字符串
/// @param replacement 用于替换字符串
- (NSString *)cc_safeStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;

/// 替换字符串内容
/// @param range 目标字符串所处范围
/// @param replacement 用于替换字符串
- (NSString *)cc_safeStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement;

/// 拼接字符串
/// @param aString 被拼接子字符串
- (NSString *)cc_safeStringByAppendingString:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
