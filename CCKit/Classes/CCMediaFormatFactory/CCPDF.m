//
//  CCPDF.m
//  LCCKit
//
//  Created by lucc on 2022/5/17.
//

#import "CCPDF.h"
#import "CCFormatWebView.h"

@implementation CCPDF

+ (BOOL)createFileWithWebView:(CCFormatWebView *)webView outputPath:(NSString *)outputPath {
    NSData *pdfData = [webView convert2PDFData];
    BOOL result = [pdfData writeToFile:outputPath atomically:YES];
    return result;
}

+ (BOOL)convertPDFWithImages:(NSArray<UIImage *>*)images outputPath:(NSString *)outputPath {
    
    if (!images || images.count == 0) return NO;
    
    BOOL result = UIGraphicsBeginPDFContextToFile(outputPath, CGRectZero, NULL);
    
    // pdf每一页的尺寸大小
    CGRect pdfBounds = UIGraphicsGetPDFContextBounds();
    CGFloat pdfWidth = pdfBounds.size.width;
    CGFloat pdfHeight = pdfBounds.size.height;
    
    NSLog(@"%@",NSStringFromCGRect(pdfBounds));
    
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        // 绘制PDF
        UIGraphicsBeginPDFPage();
        
        // 获取每张图片的实际长宽
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        
        // 每张图片居中显示
        // 如果图片宽高都小于PDF宽高
        if (imageW <= pdfWidth && imageH <= pdfHeight) {
         
            CGFloat originX = (pdfWidth - imageW) * 0.5;
            CGFloat originY = (pdfHeight - imageH) * 0.5;
            [image drawInRect:CGRectMake(originX, originY, imageW, imageH)];
            
        }
        else{
            CGFloat w,h; // 先声明缩放之后的宽高
//            图片宽高比大于PDF
            if ((imageW / imageH) > (pdfWidth / pdfHeight)){
                w = pdfWidth - 20;
                h = w * imageH / imageW;
                
            } else{
//             图片高宽比大于PDF
                h = pdfHeight - 20;
                w = h * imageW / imageH;
            }
            [image drawInRect:CGRectMake((pdfWidth - w) * 0.5, (pdfHeight - h) * 0.5, w, h)];
        }
    }];
    
    UIGraphicsEndPDFContext();
    
    return result;
}

@end
