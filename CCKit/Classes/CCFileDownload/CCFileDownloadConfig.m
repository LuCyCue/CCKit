//
//  CCFileDownloadConfig.m
//  Pods
//
//  Created by lucc on 2022/4/9.
//

#import "CCFileDownloadConfig.h"
#include <CommonCrypto/CommonCrypto.h>

@interface CCFileDownloadConfig () {
    NSString *__fileName;  //保存文件名
    NSString *__savePath;  //存储路径
    NSString *__cachePath; //缓存路径
}

@end

@implementation CCFileDownloadConfig

/// 初始化
- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
        if (url.pathExtension.length) {
            __fileName = [NSString stringWithFormat:@"%@.%@", [self md5String:url], url.pathExtension];
        } else {
            __fileName = [self md5String:url];
        }
    }
    return self;
}

- (NSString *)md5String:(NSString *)str {
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

- (NSString *)savePath {
    if (!__savePath) {
        __savePath = [NSString stringWithFormat:@"%@/%@", self.saveFolderPath, __fileName];
    }
    return __savePath;
}

- (NSString *)cachePath {
    if (!__cachePath) {
        __cachePath = [NSString stringWithFormat:@"%@/%@", self.cacheFolderPath, __fileName];
    }
    return __cachePath;
}

@end
