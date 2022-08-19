//
//  CCFormatWebView.m
//  LCCKit
//
//  Created by lucc on 2022/5/17.
//

#import "CCFormatWebView.h"

@implementation CCFormatWebView

- (NSData *)convert2PDFData {
    return [self convert2PDFData:CGRectMake(0, 0, 420, 594) pageInset:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (NSData *)convert2PDFData:(CGRect)pageRect pageInset:(UIEdgeInsets)pageInset {
    //返回视图的打印格式化
    UIViewPrintFormatter *format = [self viewPrintFormatter];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:format startingAtPageAtIndex:0];
    //设置PDF文件每页的尺寸
    if (CGRectEqualToRect(pageRect, CGRectZero)) {
        pageRect = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    }
    if (UIEdgeInsetsEqualToEdgeInsets(pageInset, UIEdgeInsetsZero)) {
        pageInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    //呈现每个页面的上下文的尺寸大小
    CGRect printableRect = CGRectMake(pageInset.left, pageInset.top, pageRect.size.width-pageInset.left-pageInset.right, pageRect.size.height-pageInset.top-pageInset.bottom);
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

- (void)convert2PDFData:(CGRect)pageRect pageInset:(UIEdgeInsets)pageInset completion:(void(^)(NSData *data))completion {
    //设置PDF文件每页的尺寸
    if (CGRectEqualToRect(pageRect, CGRectZero)) {
        pageRect = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    }
    if (UIEdgeInsetsEqualToEdgeInsets(pageInset, UIEdgeInsetsZero)) {
        pageInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    UIViewPrintFormatter *format = [self viewPrintFormatter];
    //返回视图的打印格式化
   
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:format startingAtPageAtIndex:0];

    //呈现每个页面的上下文的尺寸大小
    CGRect printableRect = CGRectMake(pageInset.left, pageInset.top, pageRect.size.width-pageInset.left-pageInset.right, pageRect.size.height-pageInset.top-pageInset.bottom);
    [render setValue:[NSValue valueWithCGRect:pageRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, pageRect, NULL);
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < [render numberOfPages]; i++) {
        dispatch_group_enter(group);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.03 * i) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIGraphicsBeginPDFPage();
            CGRect bounds = UIGraphicsGetPDFContextBounds();
            [render drawPageAtIndex:i inRect:bounds];
            dispatch_group_leave(group);
        });

    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UIGraphicsEndPDFContext();
        !completion ?: completion(pdfData);
    });
}
//- (UIImage *)convert2Image {
//    /*
//     将 UIWebView 分屏截取，然后将截取的图片拼接成一张图片
//     将 UIWebView 从头，contentOffset = (0, 0)，开始截取webView.bounds.size.height高度的图片，
//     */
//    CGSize boundsSize = self.bounds.size;
//    CGFloat boundsWidth = self.bounds.size.width;
//    CGFloat boundsHeight = self.bounds.size.height;
//    CGPoint offset = self.scrollView.contentOffset;
//
//    [self.scrollView setContentOffset:CGPointMake(0, 0)];
//
//    CGFloat contentHeight = self.scrollView.contentSize.height;
//    NSMutableArray *images = [NSMutableArray array];
//
//    while (contentHeight > 0) {
//        UIGraphicsBeginImageContext(boundsSize);
//
//        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//
//        UIGraphicsEndImageContext();
//
//        [images addObject:image];
//
//        CGFloat offsetY = self.scrollView.contentOffset.y;
//
//        [self.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
//
//        contentHeight -= boundsHeight;
//    }
//
//    [self.scrollView setContentOffset:offset];
//
//    UIGraphicsBeginImageContext(self.scrollView.contentSize);
//
//    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
//        [image drawInRect:CGRectMake(0, boundsHeight * idx, boundsWidth, boundsHeight)];
//    }];
//
//    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return fullImage;
//}

@end
