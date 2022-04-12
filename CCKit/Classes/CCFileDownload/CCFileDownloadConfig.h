//
//  CCFileDownloadConfig.h
//  Pods
//
//  Created by lucc on 2022/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFileDownloadConfig : NSObject
//保存地址
@property (nonatomic, copy, readonly) NSString *savePath;
//缓存地址
@property (nonatomic, copy, readonly) NSString *cachePath;
//保存文件夹路径
@property (nonatomic, copy) NSString *saveFolderPath;
//下载缓存路径，断点续传用
@property (nonatomic, copy) NSString *cacheFolderPath;
//忽略缓存，重新下载
@property (nonatomic, assign) BOOL ignoreCache;
//下载地址
@property (nonatomic, copy) NSString *url;

/// 初始化
- (instancetype)initWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
