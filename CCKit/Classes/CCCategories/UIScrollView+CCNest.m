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
    SEL originalSel = @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    SEL newSel = @selector(cc_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) {
        return;
    }
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
}

- (BOOL)cc_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.hookGestureDelegate) {
        return self.shouldRecognizeSimultaneously;
    }
    return [self cc_gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

#pragma mark - Getter && Setter

- (void)setHookGestureDelegate:(BOOL)hookGestureDelegate {
    objc_setAssociatedObject(self, _cmd, @(hookGestureDelegate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hookGestureDelegate {
    NSNumber *ret = objc_getAssociatedObject(self, @selector(setHookGestureDelegate:));
    return ret.boolValue;
}

@end
