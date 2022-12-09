//
//  UIImage+CCAdd.h
//  LCCKit
//
//  Created by chengchanglu on 2021/7/10.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CCImageGradientType) {
    /// 从上到下
    CCGradientTypeTopToBottom = 0,
    /// 从左到右
    CCGradientTypeLeftToRight = 1,
    /// 左上到右下
    CCGradientTypeTopLeftToBottomRight = 2,
    /// 右上到左下
    CCGradientTypeTopRightToBottomLeft = 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CCAdd)

/**
 生成指定颜色的图片
 
 @param color 颜色
 @param size 尺寸
 */
+ (UIImage *)cc_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 生成渐变色图片

 @param colors 颜色集合
 @param gradientType 渐变色方向
 @param imgSize 生成图片大小
 */
+ (UIImage *)cc_gradientColorImageFromColors:(NSArray*)colors gradientType:(CCImageGradientType)gradientType imgSize:(CGSize)imgSize locations:(NSArray<NSNumber *> *)locations;

/**
 放大图片到指定尺寸

 @param size 目标尺寸
 */
- (UIImage*)cc_scaleToSize:(CGSize)size;

/**
 修复图片方向
 */
- (UIImage *)cc_fixOrientation;

/**
 生成二维码

 @param content 二维码内容
 @param size 图片大小
 */
+ (UIImage *)cc_qrImageWithContent:(NSString *)content size:(CGFloat)size;


/**
 生成自定义颜色且中间带logo在二维码

 @param content 二维码内容
 @param logo 中间Logot图片
 @param size 图片大小
 @param red 红色值
 @param green 绿色值
 @param blue 蓝色值
 */
+ (UIImage *)cc_qrImageWithContent:(NSString *)content
                              logo:(UIImage *)logo
                              size:(CGFloat)size
                               red:(NSInteger)red
                             green:(NSInteger)green
                              blue:(NSInteger)blue;
/**
 生成自定义颜色二维码
 
 @param content 二维码内容
 @param size 图片大小
 @param red 红色值
 @param green 绿色值
 @param blue 蓝色值
 */
+ (UIImage *)cc_qrImageWithContent:(NSString *)content
                              size:(CGFloat)size
                               red:(NSInteger)red
                             green:(NSInteger)green
                              blue:(NSInteger)blue;

/// 图片压缩
/// @param minimumSize 大于多少需要压缩（byte）
- (NSData *)cc_compressWithMinimumSize:(NSInteger)minimumSize;
@end

NS_ASSUME_NONNULL_END
