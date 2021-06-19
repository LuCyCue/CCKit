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

#import "NSObject+CCDealloc.h"
#import "NSObject+KVO.h"
#import "NSObject+notification.h"

FOUNDATION_EXPORT double CCKitVersionNumber;
FOUNDATION_EXPORT const unsigned char CCKitVersionString[];

