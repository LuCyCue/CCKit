//
//  CCRefreshTimer.m
//  Pods
//
//  Created by lucc on 2023/2/24.
//

#import "CCRefreshTimer.h"

@interface CCRefreshTimer ()
//任务block
@property (nonatomic, copy) void(^refreshHandler)(void);
//正在执行任务
@property (nonatomic, assign) BOOL isExecuting;
//是否有更多的任务待执行
@property (nonatomic, assign) BOOL hasMoreTask;
@end

@implementation CCRefreshTimer

- (void)dealloc {
    NSLog(@"dealloc success");
}

- (void)refresh {
    if ([NSThread isMainThread]) {
        [self executeTask];
    } else {
        [self performSelectorOnMainThread:@selector(executeTask) withObject:nil waitUntilDone:YES];
    }
}

- (void)executeTask {
    if (_isExecuting) {
        _hasMoreTask = YES;
        return;
    }
    self.isExecuting = YES;
    !self.refreshHandler ?: self.refreshHandler();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.refreshInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isExecuting = NO;
        if (self.hasMoreTask) {
            self.hasMoreTask = NO;
            [self executeTask];
        }
    });
}

- (void)addRefreshHandler:(void(^)(void))refreshHandler {
    _refreshHandler = refreshHandler;
}

- (NSTimeInterval)refreshInterval {
    if (_refreshInterval <= 0) {
        _refreshInterval = 1;
    }
    return _refreshInterval;
}

@end
