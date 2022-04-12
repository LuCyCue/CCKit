//
//  CCFileDownloadManager.m
//  LCCKit
//
//  Created by lucc on 2022/4/8.
//

#import "CCFileDownloadManager.h"
#import "CCFileDownloadTask.h"

@interface CCFileDownloadManager ()
@property (nonatomic, strong) NSMutableDictionary *downloadingTasks;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, strong) dispatch_semaphore_t maxConcurrentLock;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation CCFileDownloadManager

+ (instancetype)manager {
    static CCFileDownloadManager *manager = nil;
    static dispatch_once_t onece;
    dispatch_once(&onece, ^{
        manager = [[CCFileDownloadManager alloc] init];
        manager.lock = dispatch_semaphore_create(1);
        manager.maxConcurrentCount = 5;
        manager.maxConcurrentLock = dispatch_semaphore_create(5);
        manager.queue = dispatch_queue_create("cc.filedownload.com", DISPATCH_QUEUE_SERIAL);
    });
    return manager;
}

/// 下载文件
/// @param url 文件地址
/// @param progressHandler 进度回调
/// @param completionHandler 结果回调
- (void)downloadFileWithUrl:(NSString *)url
            progressHandler:(void(^)(CGFloat progress))progressHandler
          completionHandler:(void(^)(NSString *url, NSError *err))completionHandler {
    dispatch_async(self.queue, ^{
        dispatch_semaphore_wait(self.maxConcurrentLock, DISPATCH_TIME_FOREVER);
        if (url.length == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !completionHandler ?: completionHandler(nil, [NSError errorWithDomain:@"cc.filedownload.com" code:500 userInfo:@{NSLocalizedDescriptionKey:@"Url is invalid"}]);
                dispatch_semaphore_signal(self.maxConcurrentLock);
            });
            return;
        }
        CCFileDownloadConfig *config = [self configWithUrl:url];
        CCFileDownloadTask *task = [[CCFileDownloadTask alloc] init];
        task.url = url;
        task.config = config;
        task.progressHandler = progressHandler;
        __weak typeof(self) weakSelf = self;
        __weak typeof(task) weakTask = task;
        task.completionHandler = ^(NSString * _Nullable localPath, NSError * _Nullable error) {
            [weakSelf removeTask:weakTask];
            dispatch_async(dispatch_get_main_queue(), ^{
                !completionHandler ?: completionHandler(localPath, error);
                dispatch_semaphore_signal(self.maxConcurrentLock);
            });
        };
        if ([self getTaskWithUrl:url]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !completionHandler ?: completionHandler(nil, [NSError errorWithDomain:@"cc.filedownload.com" code:501 userInfo:@{NSLocalizedDescriptionKey:@"Task is exist"}]);
                dispatch_semaphore_signal(self.maxConcurrentLock);
            });
            return;
        }
        [self addTask:task];
        [task startTask];
    });
}

/// 取消下载任务
/// @param url 文件地址
- (void)cancelDownloadTaskWithUrl:(NSString *)url {
    if (url.length == 0) {
        return;
    }
    if ([self.downloadingTasks objectForKey:url]) {
        CCFileDownloadTask *task = [self.downloadingTasks objectForKey:url];
        [task cancelTask];
    }
}

- (CCFileDownloadConfig *)configWithUrl:(NSString *)url {
    CCFileDownloadConfig *config = [[CCFileDownloadConfig alloc] initWithUrl:url];
    config.saveFolderPath = self.saveFolderPath;
    config.cacheFolderPath = self.cacheFolderPath;
    config.ignoreCache = self.ignoreCache;
    return config;
}

#pragma mark - ThreadSafe write and read

- (CCFileDownloadTask *)getTaskWithUrl:(NSString *)url {
    if (url.length == 0) {
        return nil;
    }
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    CCFileDownloadTask *task = [self.downloadingTasks objectForKey:url];
    dispatch_semaphore_signal(self.lock);
    return task;
}

- (void)addTask:(CCFileDownloadTask *)task {
    if (!task || task.url.length == 0) {
        return;
    }
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    [self.downloadingTasks setObject:task forKey:task.url];
    dispatch_semaphore_signal(self.lock);
}

- (void)removeTask:(CCFileDownloadTask *)task {
    if (!task || task.url.length == 0) {
        return;
    }
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    [self.downloadingTasks removeObjectForKey:task.url];
    dispatch_semaphore_signal(self.lock);
}

- (BOOL)hasDownloadingTask {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    BOOL ret = [self.downloadingTasks allKeys].count > 0;
    dispatch_semaphore_signal(self.lock);
    return ret;
}

#pragma mark - Getter

- (NSString *)saveFolderPath {
    if (!_saveFolderPath) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        _saveFolderPath = [NSString stringWithFormat:@"%@/CCDownload", cachesPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_saveFolderPath]) {
            [NSFileManager.defaultManager createDirectoryAtPath:_saveFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _saveFolderPath;
}

- (NSString *)cacheFolderPath {
    if (!_cacheFolderPath) {
        _cacheFolderPath = [NSString stringWithFormat:@"%@/Caches/", self.saveFolderPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheFolderPath]) {
            [NSFileManager.defaultManager createDirectoryAtPath:_cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _cacheFolderPath;
}

- (NSMutableDictionary *)downloadingTasks {
    if (!_downloadingTasks) {
        _downloadingTasks = [NSMutableDictionary dictionary];
    }
    return _downloadingTasks;
}

#pragma mark - Setter

- (void)setMaxConcurrentCount:(NSUInteger)maxConcurrentCount {
    _maxConcurrentCount = maxConcurrentCount;
    if (![self hasDownloadingTask]) {
        self.maxConcurrentLock = dispatch_semaphore_create(maxConcurrentCount);
    }
}

@end
