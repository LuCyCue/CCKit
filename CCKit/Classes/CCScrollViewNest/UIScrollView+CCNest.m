//
//  UIScrollView+CCNest.m
//  Pods
//
//  Created by lucc on 2022/2/27.
//

#import "UIScrollView+CCNest.h"
#import <objc/runtime.h>


@implementation UIScrollView (CCNest)

+ (void)load {
    [self swizzleInstanceMethod:@selector(setDelegate:) with:@selector(cc_setDelegate:) class:self];
}

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel class:(Class)aClass {
    Method originalMethod = class_getInstanceMethod(aClass, originalSel);
    Method newMethod = class_getInstanceMethod(aClass, newSel);
    BOOL added = class_addMethod(aClass,
                                originalSel,
                                class_getMethodImplementation(aClass, newSel),
                                method_getTypeEncoding(newMethod));
    if (added) {
        class_replaceMethod(aClass, newSel, class_getMethodImplementation(aClass, originalSel), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod,
                                       newMethod);
    }
    return YES;
}

- (void)cc_setDelegate:(id<UIScrollViewDelegate>)delegate {
    static NSMutableSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableSet set];
    });
    if (delegate && ![set containsObject:delegate.class]) {
        SEL newSel = @selector(cc_scrollViewDidScroll:);
        SEL originalSel = @selector(scrollViewDidScroll:);
        if (class_getInstanceMethod(delegate.class, originalSel)) {
            [self.class swizzleInstanceMethod:originalSel with:newSel class:delegate.class];
        } else {
            void(^emptyBlock)(void) = ^{};
            IMP emptyMethodImp = imp_implementationWithBlock(emptyBlock);
            Method originalMethod = class_getInstanceMethod(delegate.class, originalSel);
            Method newMethod = class_getInstanceMethod(delegate.class, newSel);
            class_addMethod(delegate.class, originalSel, class_getMethodImplementation(delegate.class, newSel), method_getTypeEncoding(newMethod));
            class_replaceMethod(delegate.class, newSel, emptyMethodImp, method_getTypeEncoding(originalMethod));
        }
        
        [set addObject:delegate.class];
    }
    [self cc_setDelegate:delegate];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.hookGestureDelegate) {
        return self.shouldRecognizeSimultaneously;
    }
    return NO;
}

#pragma mark - Getter && Setter

- (void)setHookGestureDelegate:(BOOL)hookGestureDelegate {
    objc_setAssociatedObject(self, _cmd, @(hookGestureDelegate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hookGestureDelegate {
    NSNumber *ret = objc_getAssociatedObject(self, @selector(setHookGestureDelegate:));
    return ret.boolValue;
}

- (void)setShouldRecognizeSimultaneously:(BOOL)shouldRecognizeSimultaneously {
    objc_setAssociatedObject(self, _cmd, @(shouldRecognizeSimultaneously), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)shouldRecognizeSimultaneously {
    NSNumber *ret = objc_getAssociatedObject(self, @selector(setShouldRecognizeSimultaneously:));
    return ret.boolValue;
}

- (void)setCanScroll:(BOOL)canScroll {
    objc_setAssociatedObject(self, _cmd, @(canScroll), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)canScroll {
    NSNumber *ret = objc_getAssociatedObject(self, @selector(setCanScroll:));
    return ret.boolValue;
}

- (void)setRole:(CCNestScrollRole)role {
    objc_setAssociatedObject(self, _cmd, @(role), OBJC_ASSOCIATION_RETAIN);
}

- (CCNestScrollRole)role {
    NSNumber *ret = objc_getAssociatedObject(self, @selector(setRole:));
    return ret.unsignedIntegerValue;
}

- (void)setSuperSrcollView:(UIScrollView *)superSrcollView {
    objc_setAssociatedObject(self, _cmd, superSrcollView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIScrollView *)superSrcollView {
    return objc_getAssociatedObject(self, @selector(setSuperSrcollView:));
}

- (void)setChildScrollView:(UIScrollView *)childScrollView {
    objc_setAssociatedObject(self, _cmd, childScrollView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIScrollView *)childScrollView {
    return objc_getAssociatedObject(self, @selector(setChildScrollView:));
}

- (void)setCriticalOffset:(CGFloat)criticalOffset {
    objc_setAssociatedObject(self, _cmd, @(criticalOffset), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)criticalOffset {
    NSNumber *ret = objc_getAssociatedObject(self, @selector(setCriticalOffset:));
    return ret.floatValue;
}

@end
