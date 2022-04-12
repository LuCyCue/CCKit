//
//  NSString+CCAdd.h
//  Pods
//
//  Created by Lucc on 2022/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CCAdd)
/// 获取中文首字母
- (NSString *)cc_getFirstLetter;

/// 生成唯一标识
+ (NSString *)cc_stringUUID;

@end

NS_ASSUME_NONNULL_END
