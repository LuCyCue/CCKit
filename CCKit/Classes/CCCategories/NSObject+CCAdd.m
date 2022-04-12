//
//  NSObject+CCAdd.m
//  Pods
//
//  Created by lucc on 2022/3/31.
//

#import "NSObject+CCAdd.h"
#import <objc/runtime.h>

@implementation NSObject (CCAdd)

/// 交互实例方法
/// @param originalSel 被替换的SEL
/// @param newSel 新的SEL
+ (BOOL)cc_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) {
        return NO;
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
    return YES;
}

/// 交互类方法
/// @param originalSel 被替换的SEL
/// @param newSel 新的SEL
+ (BOOL)cc_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) {
        return NO;
    }
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

/// 获取类的所有实例方法
+ (NSArray<NSString *> *)cc_getMethodNames {
    NSMutableArray *methodNames = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(self, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method m = methods[i];
        SEL selector = method_getName(m);
        NSString *name = NSStringFromSelector(selector);
        [methodNames addObject:name];
    }
    free(methods);
    return [methodNames copy];
}

/// 获取类的是有成员变量
+ (NSArray<NSString *> *)cc_getAllIVars {
    NSMutableArray *ivarNames = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *name = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
        [ivarNames addObject:name];
        
    }
    free(ivars);
    return [ivarNames copy];
}

/// 在主线程执行代码块
/// @param block 代码块
/// @discussion 会先判断当前线程是否为主线程，是的话直接执行。不是的话，则会异步添加到主线程
+ (void)cc_runInMainThread:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(),block);
    }
}

/// 在新的线程异步执行代码块
/// @param block 代码块
+ (void)cc_runInNewThread:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block();
    });
}


@end
