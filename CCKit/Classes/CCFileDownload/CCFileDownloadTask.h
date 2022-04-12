//
//  CCFileDownloader.h
//  LCCKit
//
//  Created by lucc on 2022/4/8.
//

#import <Foundation/Foundation.h>
#import "CCFileDownloadConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCFileDownloadTask : NSObject
/** url */
@property (nonatomic, copy) NSString *url;
/** 下载进度回调 */
@property (nonatomic, copy) void(^progressHandler)(CGFloat progress);
/** 成功回调 */
@property (nonatomic, copy) void(^completionHandler)(NSString * _Nullable localPath, NSError * _Nullable error);
/** 本地存储地址 */
@property (nonatomic, strong) CCFileDownloadConfig *config;

/// 初始化
/// @param url 下载地址
/// @param config 配置
/// @param progressHandler 进度回调
/// @param completionHandler 结果回调
- (instancetype)initWithUrl:(NSString *)url
                     config:(CCFileDownloadConfig *)config
            progressHandler:(void(^)(CGFloat progress))progressHandler
          completionHanlder:(void(^)(NSString *url, NSError *error))completionHandler;


/// 开始下载任务
- (BOOL)startTask;

/// 取消下载任务
- (void)cancelTask;

@end

NS_ASSUME_NONNULL_END
