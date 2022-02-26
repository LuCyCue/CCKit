//
//  NSObject+KVO.m
//  OCTest
//
//  Created by lucc on 2019/6/28.
//  Copyright © 2019年 lucc. All rights reserved.
//

#import "NSObject+CCKVO.h"
#import <objc/runtime.h>
#import "NSObject+CCDealloc.h"

@interface _KvoTargetObject : NSObject

@property (nonatomic, copy) kvoBlock block;
@property (nonatomic, assign) BOOL deliverOnMainThread;

- (instancetype)initWithBlock:(kvoBlock)block deliverOnMainThread:(BOOL)deliverOnMainThread;

@end

@implementation _KvoTargetObject

- (instancetype)initWithBlock:(kvoBlock)block deliverOnMainThread:(BOOL)deliverOnMainThread {
    self = [super init];
    if (self) {
        _block = block;
        _deliverOnMainThread = deliverOnMainThread;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!_block) {
        return;
    }
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) {
        return;
    }
    NSNumber *kind = (NSNumber *)([change objectForKey:NSKeyValueChangeKindKey]);
    if (kind.intValue != NSKeyValueChangeSetting) {
        return;
    }
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (newVal == [NSNull null]) {
        newVal = nil;
    }
    if (oldVal == [NSNull null]) {
        oldVal = nil;
    }
    if (_deliverOnMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _block(object,newVal,oldVal);
        });
    } else {
        _block(object,newVal,oldVal);
    }
}

@end

@implementation NSObject (CCKVO)

- (void)cc_addObserveKeyPath:(NSString *)keyPath changeBlock:(kvoBlock)changeBlock {
    [self _addObserverKeyPath:keyPath changeBlock:changeBlock deliverOnMainThread:NO];
}

- (void)cc_addObserveOnMainThreadKeyPath:(NSString *)keyPath changeBlock:(kvoBlock)changeBlock {
    [self _addObserverKeyPath:keyPath changeBlock:changeBlock deliverOnMainThread:YES];
}

- (void)_addObserverKeyPath:(NSString *)keyPath changeBlock:(kvoBlock)changeBlock deliverOnMainThread:(BOOL)deliverOnMainThread {
    _KvoTargetObject *targetObject = [[_KvoTargetObject alloc] initWithBlock:changeBlock deliverOnMainThread:deliverOnMainThread];
    [self addObserver:targetObject forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    NSMutableDictionary *allKeyObseveBlocks = [self _allKeyObserveBlocks];
    NSMutableArray *blocks = [allKeyObseveBlocks objectForKey:keyPath];
    if (!blocks) {
        blocks = [NSMutableArray array];
        [allKeyObseveBlocks setObject:blocks forKey:keyPath];
    }
    [blocks addObject:targetObject];
    if (![self _ifAddDeallocBlockForKVO]) {
        [self cc_addDeallocBlock:^(id owner) {
            [owner cc_removeObserveAll];
            NSLog(@"KVO remove success");
        }];
    }
}

- (BOOL)_ifAddDeallocBlockForKVO {
    NSNumber *ret = objc_getAssociatedObject(self, _cmd);
    if (ret.boolValue) {
        return YES;
    }
    objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return NO;
}

- (void)cc_removeObserveKeyPath:(NSString *)keyPath {
    NSMutableDictionary *allKeyObseveBlocks = [self _allKeyObserveBlocks];
    NSMutableArray *blocks = [allKeyObseveBlocks objectForKey:keyPath];
    [blocks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [allKeyObseveBlocks removeObjectForKey:keyPath];
}

- (void)cc_removeObserveAll {
    NSMutableDictionary *allKeyObseveBlocks = [self _allKeyObserveBlocks];
    [allKeyObseveBlocks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray*  _Nonnull array, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [allKeyObseveBlocks removeAllObjects];
}

- (NSMutableDictionary *)_allKeyObserveBlocks {
    NSMutableDictionary *allBlocks = objc_getAssociatedObject(self, @selector(_allKeyObserveBlocks));
    if (!allBlocks) {
        allBlocks = [NSMutableDictionary new];
        objc_setAssociatedObject(self, @selector(_allKeyObserveBlocks), allBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return allBlocks;
}

@end
