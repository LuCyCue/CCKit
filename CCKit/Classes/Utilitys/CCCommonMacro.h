//
//  CCCommonMacro.h
//  Pods
//
//  Created by chengchanglu on 2021/7/10.
//

#ifndef CCCommonMacro_h
#define CCCommonMacro_h

//屏幕宽高
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
//375*667的屏宽，比例缩放
#define CCWidthScale(w)        (SCREEN_WIDTH/375.f*(w))
#define CCHeightScale(h)       (SCREEN_HEIGHT/667.f*(h))
//状态栏高度
#define kUIStatusBarHeight      ([[UIApplication sharedApplication] statusBarFrame].size.height)
//导航栏高度
#define kUINavgationBarHeight   (kUIStatusBarHeight + 44.f)
//底部安全区域
#define KSafeBottomHeight       ((kUIStatusBarHeight == 20) ? 0.f : 34.f)
//颜色RGB
#define RGBA(r,g,b,a)           [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)              [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//16进制
#define UIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#define UIColorFromRGBV(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//系统属性相关
#define SYSTEM_VERSION          [[[UIDevice currentDevice] systemVersion] floatValue]
#define BUILD_VERSION           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APP_NAME                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define PROJECT_NAME            [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

//系统版本号比较
#define SystemVersionEqual(v)                       ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedSame)
#define SystemVersionGreaterThan(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedDescending)
#define SystemVersionGreaterThanOrEqual(v)          ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedAscending)
#define SystemVersionLessThan(v)                    ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedAscending)
#define SystemVersionLessThanOrEqual(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedDescending)

//日志打印
#if DEBUG
#define CCLog(xx, ...)                  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CCLog(xx, ...)                  nil
#endif

//沙盒路径
#define SANDBOX_HOME_PATH               NSHomeDirectory()
//documnet
#define SANDBOX_DOCUMENT_PATH           [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
//cache
#define SANDBOX_CACHES_PATH             [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
//library
#define SANDBOX_LIBRARY_PATH            [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
//temp
#define SANDBOX_TEMP_PATH               NSTemporaryDirectory()

//获取实例属性字符串
#define CCKeyPath(obj, keyPath)  @(((void)obj.keyPath, #keyPath))

//强转类型，不符合目标类型反回nil
#define CCDynamicCast(object, klass) ([(object) isKindOfClass: [klass class]] ? (klass*) object : nil)

//weak && strong
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* CCCommonMacro_h */
