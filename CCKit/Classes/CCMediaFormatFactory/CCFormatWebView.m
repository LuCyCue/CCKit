//
//  CCFormatWebView.m
//  LCCKit
//
//  Created by lucc on 2022/5/17.
//

#import "CCFormatWebView.h"

@implementation CCFormatWebView

- (NSData *)convert2PDFData {
//    返回视图的打印格式化
    UIViewPrintFormatter *format = [self viewPrintFormatter];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:format startingAtPageAtIndex:0];
    // 设置PDF文件每页的尺寸
    CGRect pageRect =  CGRectMake(0, 0, 600, 768);
//    呈现每个页面的上下文的尺寸大小
    CGRect printableRect = CGRectInset(pageRect, 50, 50);
    [render setValue:[NSValue valueWithCGRect:pageRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, pageRect, NULL);
    for (NSInteger i = 0; i < [render numberOfPages]; i++) {
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}

- (UIImage *)convert2Image {
    /*
     将 UIWebView 分屏截取，然后将截取的图片拼接成一张图片
     将 UIWebView 从头，contentOffset = (0, 0)，开始截取webView.bounds.size.height高度的图片，
     */
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGPoint offset = self.scrollView.contentOffset;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    CGFloat contentHeight = self.scrollView.contentSize.height;
    NSMutableArray *images = [NSMutableArray array];
    
    while (contentHeight > 0) {
        UIGraphicsBeginImageContext(boundsSize);
        
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [images addObject:image];
        
        CGFloat offsetY = self.scrollView.contentOffset.y;
        
        [self.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        
        contentHeight -= boundsHeight;
    }
    
    [self.scrollView setContentOffset:offset];
    
    UIGraphicsBeginImageContext(self.scrollView.contentSize);
    
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0, boundsHeight * idx, boundsWidth, boundsHeight)];
    }];
    
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return fullImage;
}

@end
