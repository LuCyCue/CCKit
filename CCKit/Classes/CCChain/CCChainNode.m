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
        self.nextNode = nextNode;
        return self;
    };
}

- (void)sendNext:(id)sender {
    
}

- (void)start {
    self.status = CCChainNodeStatusDoing;
    !self.doHandler ?: self.doHandler(self);
}

- (void)sendError:(NSError *)error {
    self.status = CCChainNodeStatusError;
    !self.errorHandler ?: self.errorHandler(error);
}


@end
