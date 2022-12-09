//
//  UIImage+CCAdd.m
//  LCCKit
//
//  Created by chengchanglu on 2021/7/10.
//

#import "UIImage+CCAdd.h"

@implementation UIImage (CCAdd)

+ (UIImage *)cc_imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)cc_gradientColorImageFromColors:(NSArray*)colors gradientType:(CCImageGradientType)gradientType imgSize:(CGSize)imgSize locations:(NSArray<NSNumber *> *)locations {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    if (!locations) {
        locations = @[@0,@1];
    }
    CGFloat cLocations[locations.count];
    for (NSInteger i = 0; i < locations.count; i++) {
        cLocations[i] = locations[i].doubleValue;
    }

    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, cLocations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case CCGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case CCGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case CCGradientTypeTopLeftToBottomRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case CCGradientTypeTopRightToBottomLeft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)cc_scaleToSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    float verticalRadio = MIN(size.height*1.0/height, 1);
    float horizontalRadio = MIN(size.width*1.0/width, 1);
    float radio = 1;
    radio = MAX(verticalRadio, horizontalRadio);
    width = width*radio;
    height = height*radio;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)cc_fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

#pragma mark - 二维码

+ (UIImage *)cc_qrImageWithContent:(NSString *)content size:(CGFloat)size {
    CIImage *image = [UIImage cc_qrByContent:content];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)cc_qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage* resultUIImage = [self cc_qrImageWithContent:content size:size red:red green:green blue:blue];
    
    // 添加logo
    CGFloat logoW = resultUIImage.size.width / 5.;
    CGRect logoFrame = CGRectMake(logoW * 2, logoW * 2, logoW, logoW);
    UIGraphicsBeginImageContext(resultUIImage.size);
    [resultUIImage drawInRect:CGRectMake(0, 0, resultUIImage.size.width, resultUIImage.size.height)];
    [logo drawInRect:logoFrame];
    UIImage *kk = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return kk;
}

+ (UIImage *)cc_qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage *image = [UIImage cc_qrImageWithContent:content size:size];
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        // 将白色变成透明
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            // 改成下面的代码，会将图片转成想要的颜色 0~255
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (CIImage *)cc_qrByContent:(NSString *)content {
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData *stringData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    // 如果生成的图片不够清晰，可以打开注释提高清晰度
//    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *image = qrFilter.outputImage;
    return image;
}

#pragma mark - 压缩

/// 获取图片压缩比例
+ (CGSize)cc_compressionSizeForImageSize:(CGSize)imageSize {
    float percent = 0.9;
    CGFloat ratio = imageSize.width/imageSize.height;
    CGFloat targetW = 1280;
    CGFloat targetH = 1280;
    if (imageSize.width < 1280 && imageSize.height < 1280) {
        // 宽高均 <= 1280，图片尺寸大小保持不变
        targetW = imageSize.width;
        targetH = imageSize.height;
    } else if (imageSize.width > 1280 && imageSize.height > 1280) {
        if (ratio > 1) {
            // 宽大于高 取较小值(高)等于1280，较大值等比例压缩
            targetH = 1280;
            targetW = targetH * ratio;
        } else {
            // 高大于宽 取较小值(宽)等于1280，较大值等比例压缩 (宽高比在0.5到2之间 )
            targetW = 1280;
            targetH = targetW / ratio;
        }
    } else { // 宽或高 > 1280
        if (ratio > 2) {
            // 宽图 图片尺寸大小保持不变
            targetW = imageSize.width * percent;
            targetH = imageSize.height * percent;
        } else if (ratio < 0.5){
            // 长图 图片尺寸大小保持不变
            targetW = imageSize.width * percent;
            targetH = imageSize.height * percent;
        } else if (ratio > 1){
            // 宽大于高 取较大值(宽)等于1280，较小值等比例压缩
            targetW = 1280;
            targetH = targetW / ratio;
        } else {
            // 高大于宽 取较大值(高)等于1280，较小值等比例压缩
            targetH = 1280;
            targetW = targetH * ratio;
        }
    }
    return CGSizeMake(targetW, targetH);
}

/// 质量压缩比
/// @param length 图片大小（byte）
+ (float)cc_compressionPercentForImageDataLength:(NSUInteger)length {
    if (length > 100*1024) {
        if (length > 5 * 1024*1024) {
            //5M以及以上 50%
            return 0.5;
        } else if (length > 1 * 1024*1024) {
            //1M-5M 70%
            return 0.7;
        } else if (length > 512*1024) {
            //0.5M-1M 80%
            return 0.8;
        } else if (length > 200*1024) {
            // 小于0.5M &&大于 0.2M 90%
            return 0.9;
        }
    }
    return 1.f;
}

/// 图片压缩
/// @param minimumSize 大于多少需要压缩（byte）
- (NSData *)cc_compressWithMinimumSize:(NSInteger)minimumSize {
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    // 小于设定大小不进行压缩
    if (imageData.length <= minimumSize) {
        return imageData;
    }
    CGSize srcSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGSize thumbSize = [UIImage cc_compressionSizeForImageSize:srcSize];
    UIImage *thumbImage = [self cc_scaleToSize:thumbSize];
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, 1.0);
    // 进行尺寸压缩后，小于minimumSize不进行压缩
    if (thumbImageData.length <= minimumSize) {
        return imageData;
    }
    float percent = [UIImage cc_compressionPercentForImageDataLength:thumbImageData.length];
    NSData *pressData = UIImageJPEGRepresentation(thumbImage, percent);
    return pressData;
}

@end
