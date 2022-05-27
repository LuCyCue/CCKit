//
//  CCImage.h
//  LCCKit
//
//  Created by lucc on 2022/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCImage : NSObject

/// 提取gif包含的图片组
+ (NSArray *)imagesFromGif:(NSData *)gif;

/// 从pdf里创建图片
/// @param pdfUrl pdf地址
+ (NSArray<UIImage *> *)imagesFromPdf:(NSURL *)pdfUrl;

/// pdf生成图片组, 归档到沙盒
/// @param pdfUrl pdf文件
/// @param outputPath 输出文件夹（文件夹需唯一）
+ (NSArray<NSString *> * _Nullable)imagesFromPdf:(NSURL *)pdfUrl outputPath:(NSString *)outputPath;

@end

NS_ASSUME_NONNULL_END
