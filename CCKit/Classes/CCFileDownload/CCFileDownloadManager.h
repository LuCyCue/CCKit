//
//  CCFileDownloadManager.h
//  LCCKit
//
//  Created by lucc on 2022/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFileDownloadManager : NSObject
/// 下载文件保存文件夹路径（默认为 /Library/Caches/CCDownload）
@property (nonatomic, copy) NSString *saveFolderPath;
/// 下载缓存文件夹（默认为 /Library/Caches/CCDownload/Caches）
@property (nonatomic, copy) NSString *cacheFolderPath;
/// 忽略缓存，重新下载
@property (nonatomic, assign) BOOL ignoreCache;
/// 最大并发数(默认为5)
@property (nonatomic, assign) NSUInteger maxConcurrentCount;

/// 单例
+ (instancetype)manager;

/// 下载文件
/// @param url 文件地址
/// @param progressHandler 进度回调
/// @param completionHandler 结果回调
- (void)downloadFileWithUrl:(NSString *)url
            progressHandler:(void(^)(CGFloat progress))progressHandler
          completionHandler:(void(^)(NSString *url, NSError *err))completionHandler;

/// 取消下载任务
/// @param url 文件地址
- (void)cancelDownloadTaskWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
