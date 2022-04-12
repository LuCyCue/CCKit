//
//  CCChainNode.h
//  Pods
//
//  Created by lucc on 2022/3/21.
//

#import <Foundation/Foundation.h>

/// 节点状态
typedef NS_ENUM(NSUInteger, CCChainNodeStatus) {
    CCChainNodeStatusReady,
    CCChainNodeStatusDoing,
    CCChainNodeStatusCompletion,
    CCChainNodeStatusError,
};

NS_ASSUME_NONNULL_BEGIN

@interface CCChainNode : NSObject
@property (nonatomic, assign) CCChainNodeStatus status;
@property (nonatomic, strong) NSMutableArray<CCChainNode *> *subNodes;
@property (nonatomic, strong) CCChainNode *nextNode;
@property (nonatomic, copy) void(^doHandler)(id sender);
@property (nonatomic, copy) void(^completionHandler)(id sender);
@property (nonatomic, copy) void(^errorHandler)(NSError *error);

- (void)start;
- (void)cancel;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
