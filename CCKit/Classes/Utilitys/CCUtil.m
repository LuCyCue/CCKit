//
//  CCUtil.m
//  Pods
//
//  Created by lucc on 2022/4/2.
//

#import "CCUtil.h"
#import <mach/mach.h>

@implementation CCUtil

/// 打开应用外URL
/// @param url url
/// @param completion 回调
+ (void)openURL:(NSString *)url completion:(void (^)(BOOL success))completion {
    // 判断是否能打开URL
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    // iOS10以上 -- 使用新方法
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            if (completion) completion(success);
        }];
    } else {
        // iOS10一下 -- 使用旧方法
        BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        if (completion) completion(success);
    }
}

/// 打开app对应的设置
+ (void)openAppSetting {
    [self openURL:UIApplicationOpenSettingsURLString completion:^(BOOL success) {
        
    }];
}

/// 拨打电话
/// @param phone 电话号码
/// @param completion 回调
+ (void)makeACallWithPhoneNumber:(NSString *)phone completion:(void (^)(BOOL success))completion {
   [self openURL:[NSString stringWithFormat:@"tel:%@", phone] completion:completion];
}

/// 获取keywindow
+ (UIWindow *)getKeyWindow {
    UIWindow *keyWindow = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        keyWindow = [[UIApplication sharedApplication].delegate window];
    } else {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if (!window.hidden) {
                keyWindow = window;
                break;
            }
        }
    }
    return keyWindow;
}

/// 获取当前window rootViewController
+ (UIViewController *)rootViewControllerForKeyWindow {
    UIWindow *keyWindow = [self getKeyWindow];
    return [keyWindow rootViewController];
}


/// 获取当前viewController
+ (UIViewController *)topViewControllerForKeyWindow {
    UIViewController *resultVC;
    UIWindow *keyWindow = [self getKeyWindow];
    resultVC = [self _topViewController:[keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

/// 获取cpu使用情况
+ (CGFloat)cpuUsageForApp {
    kern_return_t kr;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    float tot_cpu = 0;
    
    //  获取当前进程中 线程列表
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
        return -1;

    for (int j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        //获取每一个线程信息
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
            return -1;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            // cpu_usage : Scaled cpu usage percentage. The scale factor is TH_USAGE_SCALE.
            //宏定义TH_USAGE_SCALE返回CPU处理总频率：
            tot_cpu += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    } // for each thread
    
    // 注意方法最后要调用 vm_deallocate，防止出现内存泄漏
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    if (tot_cpu < 0) {
        tot_cpu = 0.;
    }
    
    return tot_cpu;
}

/// 当前app占用内容量（单位:M）
+ (NSInteger)useMemoryForApp {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        return (NSInteger)(memoryUsageInByte/1024/1024);
    } else {
        return -1;
    }
}

//当前设备总的内存 （单位：M）
+ (NSInteger)totalMemoryForDevice {
    return (NSInteger)([NSProcessInfo processInfo].physicalMemory/1024/1024);
}

@end
