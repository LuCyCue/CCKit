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
    CCChainNodeStatusCancel,
};

NS_ASSUME_NONNULL_BEGIN

@interface CCChainNode : NSObject
@property (nonatomic, assign) CCChainNodeStatus status;
@property (nonatomic, strong) NSMutableArray<CCChainNode *> *nextNodes;
@property (nonatomic, strong) NSMutableArray<CCChainNode *> *preNodes;
@property (nonatomic, strong) id data;
@property (nonatomic, copy) void(^doHandler)(CCChainNode *sender);
@property (nonatomic, copy) void(^completionHandler)(CCChainNode *sender);
@property (nonatomic, copy) void(^errorHandler)(NSError *error);
@property (nonatomic, copy) void(^cancelHandler)(void);


- (void)start:(id _Nullable)sender;
- (void)cancel;

- (CCChainNode *(^)(CCChainNode *))addNextNode;

- (void)sendNext:(id)sender;

@end

NS_ASSUME_NONNULL_END
