//
//  CCMediaFormatTool.h
//  LCCKit
//
//  Created by lucc on 2022/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCMediaFormatTool : NSObject

+ (NSString *)tmpPathWithFileName:(NSString *)fileName;

+ (NSString *)md5String:(NSString *)str;

+ (NSString *)randPathWithExtendName:(NSString *)extendName;

@end

NS_ASSUME_NONNULL_END
