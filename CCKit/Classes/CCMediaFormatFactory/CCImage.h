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

@end

NS_ASSUME_NONNULL_END
