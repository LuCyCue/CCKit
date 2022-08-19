//
//  CCPDFConvertView.h
//
//  Created by lucc on 2022/5/18.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class CCPDFConvertView;
NS_ASSUME_NONNULL_BEGIN

@protocol CCPDFConvertViewDelegate <NSObject>

/// 开始加载文件
- (void)startLoadFile:(CCPDFConvertView *)view;

/// 文件加载结束，如果加载发生错误，则error不为空
- (void)didCompleteLoadFile:(CCPDFConvertView *)view error:(NSError *_Nullable)error;

@end

@interface CCPDFConvertView : UIView

/// 文件地址，只支持本地文件
@property (nonatomic, copy) NSURL *fileUrl;
/// 代理(文件加载情况回调，请确保文件加载成功后，再进行转换)
@property (nonatomic, weak) id<CCPDFConvertViewDelegate> delegate;

/// 初始化
/// @param frame 坐标信息
/// @param fileUrl 文件地址
- (instancetype)initWithFrame:(CGRect)frame fileUrl:(NSURL *)fileUrl;

/// 获取内容
- (CGSize)getContentSize;

/// 获取偏移
- (CGPoint)getContentOffset;

@end

NS_ASSUME_NONNULL_END
