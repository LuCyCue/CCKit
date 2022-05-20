//
//  CCFormatWebView.h
//  LCCKit
//
//  Created by lucc on 2022/5/17.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFormatWebView : WKWebView

- (NSData *)convert2PDFData;

- (UIImage *)convert2Image;

@end

NS_ASSUME_NONNULL_END
