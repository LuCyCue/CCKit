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
};

NS_ASSUME_NONNULL_BEGIN

@interface CCChainNode : NSObject
@property (nonatomic, assign) CCChainNodeStatus status;
@property (nonatomic, strong) NSMutableArray<CCChainNode *> *nextNodes;
@property (nonatomic, assign) NSUInteger preNodeCount;
@property (nonatomic, copy) void(^doHandler)(id sender);
@property (nonatomic, copy) void(^completionHandler)(id sender);
@property (nonatomic, copy) void(^errorHandler)(NSError *error);

- (void)doNext;

@end

NS_ASSUME_NONNULL_END
