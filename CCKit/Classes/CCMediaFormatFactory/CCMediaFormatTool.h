//
//  CCMediaFormatTool.h
//  LCCKit
//
//  Created by lucc on 2022/4/23.
//

#import <Foundation/Foundation.h>
#import "CCMediaFormatDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCMediaFormatTool : NSObject

+ (NSString *)tmpPathWithFileName:(NSString *)fileName;

+ (NSString *)md5String:(NSString *)str;

+ (NSString *)randPathWithExtendName:(NSString *)extendName;

+ (NSString *)randFolderPath;

+ (BOOL)checkSDKValid:(CCMediaFormatCompletion)completion;

+ (BOOL)checkSDKValid;

@end

NS_ASSUME_NONNULL_END
