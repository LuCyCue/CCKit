//
//  CCGCDTimer.m
//  Pods
//
//  Created by Lucc on 2022/11/23.
//

#import "CCGCDTimer.h"

@interface CCGCDTimer ()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy) void(^timerHandler)(void);
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) BOOL repeats;
@end

@implementation CCGCDTimer

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats handler:(void(^)(void))handler {
    CCGCDTimer *timer = CCGCDTimer.new;
    timer.timeInterval = timeInterval;
    timer.timerHandler = handler;
    timer.repeats = repeats;
    return timer;
}

- (void)fire {
    [self invalidate];
    NSLog(@"start Timer");
    self.queue = dispatch_queue_create("com.cc.gcdtimer", DISPATCH_QUEUE_SERIAL);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    if (self.repeats) {
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, self.timeInterval * NSEC_PER_MSEC), self.timeInterval * NSEC_PER_MSEC, 0);
    } else {
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, self.timeInterval * NSEC_PER_MSEC), DISPATCH_TIME_FOREVER, 0);
    }
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        !weakSelf.timerHandler ?: weakSelf.timerHandler();
        if (!weakSelf.repeats) {
            [self invalidate];
        }
    });
    dispatch_resume(self.timer);
    self.valid = YES;
}

- (void)invalidate {
    if (self.timer && self.valid) {
        dispatch_cancel(self.timer);
        self.valid = NO;
        self.timer = nil;
    }
}

@end
