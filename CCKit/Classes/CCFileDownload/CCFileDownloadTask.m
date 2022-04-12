//
//  CCFileDownloader.m
//  LCCKit
//
//  Created by lucc on 2022/4/8.
//

#import "CCFileDownloadTask.h"

@interface CCFileDownloadTask ()<NSURLSessionDownloadDelegate>
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
/** 下载数据 */
@property (nonatomic, strong) NSData *resumeData;
/** session */
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation CCFileDownloadTask

/// 初始化
/// @param url 下载地址
/// @param config 配置
/// @param progressHandler 进度回调
/// @param completionHandler 结果回调
- (instancetype)initWithUrl:(NSString *)url
                     config:(CCFileDownloadConfig *)config
            progressHandler:(void(^)(CGFloat progress))progressHandler
          completionHanlder:(void(^)(NSString *url, NSError *error))completionHandler; {
    self = [super init];
    if (self) {
        self.url = url;
        self.config = config;
        self.progressHandler = progressHandler;
        self.completionHandler = completionHandler;
    }
    return self;
}

/// 开始下载任务
- (BOOL)startTask {
    if (self.url.length == 0) {
        !self.completionHandler ?: self.completionHandler(nil, [NSError errorWithDomain:@"cc.filedownload.com" code:500 userInfo:@{NSLocalizedDescriptionKey:@"Url is invalid"}]);
        return NO;
    }
    if (!self.config.ignoreCache) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.config.savePath]) {
            !self.progressHandler ?: self.progressHandler(1);
            !self.completionHandler ?: self.completionHandler(self.config.savePath, nil);
            return YES;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.config.cachePath]) {
            [self resumeTask];
            return YES;
        }
    }
    [self startTaskWithResumeData:nil];
    return YES;
}

/// 开始下载任务
/// @param resumeData 已经下载的数据
- (void)startTaskWithResumeData:(NSData *)resumeData {
    if (resumeData) {
        self.task = [self.session downloadTaskWithResumeData:resumeData];
    } else {
        self.task = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    [self.task resume];
}

/// 断点续传
- (void)resumeTask {
    NSString *filePath = self.config.cachePath;
    NSData *resumeData = [NSData dataWithContentsOfFile:filePath];
    [self startTaskWithResumeData:resumeData];
}

/// 取消下载任务
- (void)cancelTask {
    __weak typeof(self) weakSelf = self;
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (resumeData) {
            /// 将数据临时写入本地
            [resumeData writeToFile:weakSelf.config.cachePath atomically:YES];
            !self.completionHandler ?: self.completionHandler(nil, [NSError errorWithDomain:@"cc.filedownload.com" code:503 userInfo:@{NSLocalizedDescriptionKey:@"Task cancel"}]);
        }
    }];
}

#pragma mark - NSURLSessionDownloadDelegate

/* 主线程执行；更新进度值
 * bytesWritten:每次服务器返回的数据大小
 * totalBytesWritten:截止到目前为止，下载数据大小
 * totalBytesExpectedToWrite:下载的总数据的大小(bytes)
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.progressHandler ?: self.progressHandler(progress);
    });
}

/// 下载完毕
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *filePath = self.config.savePath;
    NSError *error = nil;
    // 移动文件到指定的路径
    if(![NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        [NSFileManager.defaultManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:&error];
    }
    !self.completionHandler ?: self.completionHandler(filePath, nil);
}

#pragma mark - Getter

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPShouldSetCookies = YES;
        configuration.HTTPShouldUsePipelining = NO;
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        configuration.allowsCellularAccess = YES;
        configuration.timeoutIntervalForRequest = 60.0;
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:NSOperationQueue.mainQueue];
    }
    return _session;
}

@end
