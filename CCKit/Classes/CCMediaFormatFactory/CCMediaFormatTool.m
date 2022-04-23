//
//  CCMediaFormatTool.m
//  LCCKit
//
//  Created by lucc on 2022/4/23.
//

#import "CCMediaFormatTool.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation CCMediaFormatTool

+ (NSString *)md5String:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)cacheFolder {
    NSString *cachesPath = [NSString stringWithFormat:@"%@/CCMedia", NSTemporaryDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cachesPath;
}

+ (NSString *)tmpPathWithFileName:(NSString *)fileName {
    if (fileName.length == 0) {
        return nil;
    }
    NSString *folderPath = [self cacheFolder];
    return [NSString stringWithFormat:@"%@/%@", folderPath, fileName];
}

+ (NSString *)randPathWithExtendName:(NSString *)extendName {
    int randNum = arc4random_uniform(1000);
    NSString *randName = [NSString stringWithFormat:@"%@%d.%@", [CCMediaFormatTool md5String:@([NSDate date].timeIntervalSince1970).stringValue], randNum, extendName];
    NSString *path = [CCMediaFormatTool tmpPathWithFileName:randName];
    return path;
}

@end
