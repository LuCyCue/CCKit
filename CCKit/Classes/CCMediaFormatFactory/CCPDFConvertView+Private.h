//
//  CCPDFConvertView+Private.h
//
//  Created by lucc on 2022/5/20.
//

#import "CCPDFConvertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCPDFConvertView (Private)

- (BOOL)convertToPdf:(NSString *)outputPath;

- (BOOL)convertToImage:(NSString *)outputPath;

- (BOOL)convertToPdf:(NSString *)outputPath pageRect:(CGRect)pageRect pageInset:(UIEdgeInsets)pageInset;

@end

NS_ASSUME_NONNULL_END
