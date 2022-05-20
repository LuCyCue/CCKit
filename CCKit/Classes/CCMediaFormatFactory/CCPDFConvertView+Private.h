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

@end

NS_ASSUME_NONNULL_END
