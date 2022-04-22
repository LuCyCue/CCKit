//
//  CCGIF.h
//  LCCKit
//
//  Created by lucc on 2022/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCGIF : NSObject

/// 动画循环次数
@property (nonatomic, assign) int32_t loopCount;
/// 动画延迟时间
@property (nonatomic, assign) CGFloat delayTime;
/// 缩放率 （0.0-1.0）
@property (nonatomic, assign) CGFloat scale;
/// 每秒帧数
@property (nonatomic, assign) NSUInteger framesPerSecond;
/// 输出地址
@property (nonatomic, copy) NSString *outputUrl;
/// 结束回调
@property (nonatomic, copy) void(^completionHandler)(NSString * _Nullable outputUrl, NSError * _Nullable error);

/// 视频生成gif
- (void)createFileWithAVAsset:(AVURLAsset *)asset;

@end

NS_ASSUME_NONNULL_END
