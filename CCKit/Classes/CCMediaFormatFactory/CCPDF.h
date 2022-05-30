//
//  CCPDF.h
//  LCCKit
//
//  Created by lucc on 2022/5/17.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class CCFormatWebView;
NS_ASSUME_NONNULL_BEGIN

@interface CCPDF : NSObject

+ (BOOL)convertPDFWithImages:(NSArray<UIImage *>*)images outputPath:(NSString *)outputPath;

+ (BOOL)createFileWithWebView:(CCFormatWebView *)webView outputPath:(NSString *)outputPath;
@end

NS_ASSUME_NONNULL_END
