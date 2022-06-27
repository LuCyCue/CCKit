//
//  CCFPSTool.m
//  Pods
//
//  Created by lucc on 2022/6/16.
//

#import "CCFPSTool.h"
#import <UIKit/UIKit.h>

@interface CCFPSTool()
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, assign) NSInteger fps;
@end

@implementation CCFPSTool

- (instancetype)init {
    self = [super init];
    if (self) {
        _isStart = NO;
        _count = 0;
        _lastTime = 0;
    }
    return self;
}

- (void)start {
    self.link.paused = NO;
}

- (void)end {
    if (_link) {
        _link.paused = YES;
        [_link invalidate];
        _link = nil;
        _lastTime = 0;
        _count = 0;
    }
}

- (void)trigger:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) {
        return;
    }
    _lastTime = link.timestamp;
    CGFloat fps = _count / delta;
    _count = 0;
    NSInteger intFps = (NSInteger)(fps+0.5);
    self.fps = intFps;
    !self.fpsChangeHandler ?: self.fpsChangeHandler(self.fps);
}

#pragma mark - Getter

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(trigger:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

@end
