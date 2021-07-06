#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+CCSafe.h"
#import "NSDictionary+CCSafe.h"
#import "NSObject+CCDealloc.h"
#import "NSObject+CCKVO.h"
#import "NSObject+CCNotification.h"
#import "NSString+CCSafe.h"
#import "UIButton+CCLayout.h"

FOUNDATION_EXPORT double LCCKitVersionNumber;
FOUNDATION_EXPORT const unsigned char LCCKitVersionString[];

