//
//  CCMediaFormatDefine.h
//  LCCKit
//
//  Created by lucc on 2022/4/25.
//


#ifndef CCMediaFormatDefine_h
#define CCMediaFormatDefine_h
#import <CoreGraphics/CoreGraphics.h>

typedef void(^CCMediaFormatCompletion)(NSString * _Nullable url, NSError * _Nullable error);
typedef void(^CCMediaFormatProgress)(CGFloat progress);


/// 导出视频质量
typedef NS_ENUM(NSInteger, CCExportPresetType) {
    CCExportPresetTypeLowQuality = 0, //低质量
    CCExportPresetTypeMediumQuality,  //中等质量
    CCExportPresetTypeHighestQuality, //高等质量
    CCExportPresetType640x480,
    CCExportPresetType960x540,
    CCExportPresetType1280x720,
    CCExportPresetType1920x1080,
    CCExportPresetType3840x2160,
};

/// 导出文件类型
typedef NS_ENUM(NSInteger, CCVideoFileType) {
    CCVideoFileTypeMov = 0,
    CCVideoFileTypeMp4,
    CCVideoFileTypeM4v,
};

/// 文件类型拓展名映射
static NSString * _Nonnull const CCVideoFileTypeMap[] = {
    [CCVideoFileTypeMov] = @".mov",
    [CCVideoFileTypeMp4] = @".mp4",
    [CCVideoFileTypeM4v] = @".m4v",
};

/// 导出文件类型
typedef NS_ENUM(NSInteger, CCGifQualityType) {
    CCGifQualityTypeMedium = 0,
    CCGifQualityTypeHigh,
};

#endif
