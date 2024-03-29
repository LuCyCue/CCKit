//
//  CCFormatWebView.h
//  LCCKit
//
//  Created by lucc on 2022/5/17.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCFormatWebView : WKWebView

- (NSData *)convert2PDFData;

- (NSData *)convert2PDFData:(CGRect)pageRect pageInset:(UIEdgeInsets)pageInset;

- (void)convert2PDFData:(CGRect)pageRect pageInset:(UIEdgeInsets)pageInset completion:(void(^)(NSData *data))completion;

@end

NS_ASSUME_NONNULL_END
