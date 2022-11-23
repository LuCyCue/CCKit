//
//  CCTimer.m
//  Pods
//
//  Created by Lucc on 2022/11/22.
//

#import "CCTimer.h"

@interface CCTimer ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, assign) CFRunLoopRef timerRunLoop;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
@implementation CCTimer

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timerInterval target:(id)target selector:(nonnull SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    CCTimer *cTimer = CCTimer.new;
    cTimer.target = target;
    cTimer.aSelector = aSelector;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:cTimer selector:@selector(timerAction) userInfo:userInfo repeats:yesOrNo];
    cTimer.timer = timer;
    return cTimer;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timerInterval target:(id)target selector:(nonnull SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    CCTimer *cTimer = CCTimer.new;
    cTimer.target = target;
    cTimer.aSelector = aSelector;
    NSTimer *timer = [NSTimer timerWithTimeInterval:timerInterval target:cTimer selector:@selector(timerAction) userInfo:userInfo repeats:yesOrNo];
    cTimer.timer = timer;
    return cTimer;
}

- (void)addToRunLoop:(NSRunLoopMode)mode onNewThread:(BOOL)onNewThread {
    if (onNewThread) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //1 addTimer
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:mode];
            // run runLoop
            self.timerRunLoop = CFRunLoopGetCurrent();
            CFRunLoopRun();
        });
    } else {
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:mode];
    }
}

- (void)invalidate {
    if (self.timerRunLoop) {
        CFRunLoopStop(self.timerRunLoop);
        self.timerRunLoop = NULL;
    }
    if (self.timer && self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerAction {
    if (self.target && [self.target respondsToSelector:self.aSelector]) {
        [self.target performSelector:self.aSelector withObject:self];
    }
}

@end
#pragma clang diagnostic pop
