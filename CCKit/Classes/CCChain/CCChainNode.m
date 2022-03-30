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
        return self;
    };
}

- (void)doNext {
    
}


- (NSMutableArray<CCChainNode *> *)nextNodes {
    if (!_nextNodes) {
        _nextNodes = [NSMutableArray array];
    }
    return _nextNodes;
}

@end
