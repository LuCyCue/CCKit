//
//  CCFPSTool.h
//  Pods
//
//  Created by lucc on 2022/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFPSTool : NSObject

/// fps数值回调
@property (nonatomic, copy) void(^fpsChangeHandler)(NSInteger value);

/// 开始统计
- (void)start;

/// 结束统计
- (void)end;
@end

NS_ASSUME_NONNULL_END
