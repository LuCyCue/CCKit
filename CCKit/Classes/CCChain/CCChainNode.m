//
//  CCChainNode.m
//  Pods
//
//  Created by lucc on 2022/3/21.
//

#import "CCChainNode.h"

@implementation CCChainNode

- (CCChainNode *(^)(CCChainNode *))addNextNode {
    return ^CCChainNode* (CCChainNode *nextNode) {
        [self.nextNodes addObject:nextNode];
        [nextNode.preNodes addObject:self];
        return self;
    };
}

- (void)sendNext:(id)sender {
    if (self.status == CCChainNodeStatusCancel) {
        return;
    }
    self.status = CCChainNodeStatusCompletion;
    !self.completionHandler ?: self.completionHandler(self);
    for (CCChainNode *next in self.nextNodes) {
        [next start:self];
    }
}

- (void)start:(id _Nullable)sender {
    for (CCChainNode *node in self.preNodes) {
        if (node.status != CCChainNodeStatusCompletion) {
            return;
        }
    }
    self.status = CCChainNodeStatusDoing;
    !self.doHandler ?: self.doHandler(self);
}

- (void)cancel {
    self.status = CCChainNodeStatusCancel;
    !self.cancelHandler ?: self.cancelHandler();
    for (CCChainNode *next in self.nextNodes) {
        [next cancel];
    }
}

- (void)sendError:(NSError *)error {
    self.status = CCChainNodeStatusError;
    !self.errorHandler ?: self.errorHandler(error);
    for (CCChainNode *next in self.nextNodes) {
        [next sendError:error];
    }
}

- (NSMutableArray<CCChainNode *> *)nextNodes {
    if (!_nextNodes) {
        _nextNodes = [NSMutableArray array];
    }
    return _nextNodes;
}

- (NSMutableArray<CCChainNode *> *)preNodes {
    if (!_preNodes) {
        _preNodes = [NSMutableArray array];
    }
    return _preNodes;
}

@end
