//
//  NSObject+dealloc.m
//  OCTest
//
//  Created by lucc on 2019/6/24.
//  Copyright © 2019年 lucc. All rights reserved.
//

#import "NSObject+CCDealloc.h"
#import <objc/runtime.h>


@interface Deallocator : NSObject
@property (nonatomic, unsafe_unretained) id owner;
@property (nonatomic, strong) NSMutableArray<CCDeallocBlock> *callbacks;

- (instancetype)initWithOwner:(id)owner;
- (void)addCallback:(CCDeallocBlock)block;
- (void)invokeCallbacks;
@end

@implementation Deallocator

- (instancetype)initWithOwner:(id)owner {
    self = [super init];
    if (self) {
        self.owner = owner;
        self.callbacks = [NSMutableArray array];
    }
    return self;
}

- (void)addCallback:(CCDeallocBlock)block {
    if (block) {
        [self.callbacks addObject:block];
    }
}

- (void)invokeCallbacks {
    NSArray *blocks = self.callbacks;
    self.callbacks = nil;
    
    __unsafe_unretained NSObject *owner = self.owner;
    if (blocks.count > 0 && owner) {
        [blocks enumerateObjectsUsingBlock:^(CCDeallocBlock block, NSUInteger idx, BOOL *stop) {
            block(owner);
        }];
    }
}

@end

@implementation NSObject (CCDealloc)

- (void)cc_addDeallocBlock:(CCDeallocBlock)callBack {
    @synchronized (self) {
        [[self class] exchangeMethodsIfNeed];
        [self.deallocator addCallback:callBack];
    }
}

- (Deallocator *)deallocator {
    Deallocator *dealloc = objc_getAssociatedObject(self, _cmd);
    if (!dealloc) {
        dealloc = [[Deallocator alloc] initWithOwner:self];
        objc_setAssociatedObject(self, _cmd, dealloc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dealloc;
}

+ (BOOL)exchangeMethodsIfNeed {
    static NSMutableSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableSet set];
    });
    if ([set containsObject:self]) {
        return NO;
    }

    SEL originSelector = NSSelectorFromString(@"dealloc");
    Method originMethod = class_getInstanceMethod(self, originSelector);
    void(*originImp)(id, SEL) = (typeof (originImp))method_getImplementation(originMethod);
    void(^targetImpBlock)(id) = ^(__unsafe_unretained NSObject *owner){
        [owner.deallocator invokeCallbacks];
        originImp(owner, originSelector);
    };
    IMP targerImp = imp_implementationWithBlock(targetImpBlock);
    class_replaceMethod(self, originSelector, targerImp, method_getTypeEncoding(originMethod));
    [set addObject:self];
    return YES;
}

@end
