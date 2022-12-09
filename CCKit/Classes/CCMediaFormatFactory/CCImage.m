//
//  CCImage.m
//  LCCKit
//
//  Created by lucc on 2022/5/5.
//

#import "CCImage.h"
#import <ImageIO/ImageIO.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation CCImage

/// 提取gif包含的图片组
+ (NSArray *)imagesFromGif:(NSData *)gif {
    NSMutableArray *imageArray = [NSMutableArray array];
    CGImageSourceRef gifImageSourceRef = CGImageSourceCreateWithData((CFDataRef)gif, nil);
    // 获取图片个数
    size_t framesCount = CGImageSourceGetCount(gifImageSourceRef);
    for (size_t i = 0; i < framesCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifImageSourceRef, i, nil);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArray addObject:image];
        CFRelease(imageRef);
    }
    return imageArray;
}

/// pdf生成图片组, 归档到沙盒
/// @param pdfUrl pdf文件
/// @param outputPath 输出文件夹（文件夹需唯一）
+ (NSArray<NSString *> * _Nullable)imagesFromPdf:(NSURL *)pdfUrl outputPath:(NSString *)outputPath {
    CFURLRef ref = (__bridge CFURLRef)pdfUrl;
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL(ref);
    CFRelease(ref);
    size_t pageNum = CGPDFDocumentGetNumberOfPages(pdf);
    if (pageNum == 0) {
        return nil;
    }
    NSMutableArray *pathArray = [NSMutableArray array];
    for (int i = 1; i <= pageNum; i++) {
        CGImageRef imageRef = PDFPageToCGImage(i, pdf);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSString *path = [NSString stringWithFormat:@"%@/%@.png", outputPath, @(i)];
        NSData *imgData = UIImagePNGRepresentation(image);
        if ([imgData writeToFile:path atomically:YES]) {
            [pathArray addObject:path];
        }
        CGImageRelease(imageRef);
    }
    return pathArray;
}

+ (NSArray<UIImage *> *)imagesFromPdf:(NSURL *)pdfUrl {
    CFURLRef ref = (__bridge CFURLRef)pdfUrl;
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL(ref);
    CFRelease(ref);
    size_t pageNum = CGPDFDocumentGetNumberOfPages(pdf);
    if (pageNum == 0) {
        return @[];
    }
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i = 1; i <= pageNum; i++) {
        CGImageRef imageRef = PDFPageToCGImage(i, pdf);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imgArray addObject:image];
        CGImageRelease(imageRef);
    }
    return [imgArray copy];
}

CGImageRef PDFPageToCGImage(size_t pageNumber, CGPDFDocumentRef document) {
    CGPDFPageRef page = CGPDFDocumentGetPage(document, pageNumber);
    if(page) {
        CGRect pageSize = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextRef outContext = CreateARGBBitmapContext(pageSize.size.width*2, pageSize.size.height*2);
     
        if(outContext) {
            CGContextDrawPDFPage(outContext, page);
            CGImageRef ThePDFImage = CGBitmapContextCreateImage(outContext);
            char *data = CGBitmapContextGetData(outContext);
            free(data);
            CFRelease(outContext);
            return ThePDFImage;
        }
    }
    return NULL;
}

CGContextRef CreateARGBBitmapContext (size_t pixelsWide, size_t pixelsHigh) {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    unsigned long   bitmapByteCount;
    unsigned long   bitmapBytesPerRow;
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);

    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);

    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease(colorSpace);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextScaleCTM(context, 2, 2);
    return context;
}

//同时获取图片组最大宽度及拼接高度
+ (void)getImagesMaxWidthAndTotleHeight:(NSArray *)images callBack:(void(^)(NSUInteger maxWith,NSUInteger totleHeight))callBack {
    CGFloat maxWidth = 0;
    CGFloat allImageHeight = 0;
    for (UIImage * image in images) {
        CGFloat currentImageWidth = image.size.width;
        maxWidth = maxWidth < currentImageWidth ? currentImageWidth : maxWidth;
        allImageHeight += image.size.height;
    }
    callBack(maxWidth,allImageHeight);
}

//拼接长图
+ (void)combineImages:(NSArray *)images callBack:(void(^)(UIImage *_Nullable resultImage))callBack {
    [self getImagesMaxWidthAndTotleHeight:images callBack:^(NSUInteger imageWidth, NSUInteger imageHeight) {
        if (imageWidth == 0 || imageHeight == 0) {
            callBack(nil);
            return;
        }
        UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor.blackColor CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, imageWidth, imageHeight));
        NSUInteger x = 0;
        NSUInteger y = 0;
        for (UIImage *image in images) {
            x = (imageWidth-image.size.width)/2;
            [image drawInRect:CGRectMake(x, y, image.size.width, image.size.height)];
            y += image.size.height;
        }
        CGImageRef resultImgRef = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage, CGRectMake(0, 0, imageWidth, imageHeight));
        UIGraphicsEndImageContext();
        UIImage *resultImage = [UIImage imageWithCGImage:resultImgRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        callBack(resultImage);
    }];
}

@end
