//
//  CCPDFConvertView.h
//
//  Created by lucc on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPDFConvertView : UIView

/// 文件地址，只支持本地文件
@property (nonatomic, copy) NSURL *fileUrl;


/// 初始化
/// @param frame 坐标信息
/// @param fileUrl 文件地址
- (instancetype)initWithFrame:(CGRect)frame fileUrl:(NSURL *)fileUrl;

@end

NS_ASSUME_NONNULL_END
