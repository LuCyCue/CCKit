//
//  CCRefreshTimer.h
//  Pods
//
//  Created by lucc on 2023/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 为需要控制UI刷新频率场景定制
@interface CCRefreshTimer : NSObject

/// 最小刷新间隔( 单位：s, default：1s)
@property (nonatomic, assign) NSTimeInterval refreshInterval;

/// 刷新
- (void)refresh;

/// 添加刷新任务
/// @param refreshHandler 刷新代码块
- (void)addRefreshHandler:(void(^)(void))refreshHandler;

@end

NS_ASSUME_NONNULL_END
