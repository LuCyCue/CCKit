//
//  CCVideo.h
//  LCCKit
//
//  Created by lucc on 2022/4/23.
//

#import <Foundation/Foundation.h>
#import "CCMediaFormatDefine.h"
#import <CoreGraphics/CoreGraphics.h>

@interface CCVideo : NSObject

@property (nonatomic, copy) NSString *outputUrl;
@property (nonatomic, assign) CCExportPresetType presetType;
@property (nonatomic, assign) CCVideoFileType outputFileType;
//源数据（可以为 PHAsset、NSURL、AVURLAsset）
@property (nonatomic, strong) id sourceVideo;
/// 结束回调
@property (nonatomic, copy) void(^completionHandler)(NSString *outputUrl, NSError *error);

/// gif 转成mp4格式
/// @param gif gif data
/// @param speed 视频播放速度（1和gif一致，大于1, 加快， 小于1，变慢）
/// @param size 视频宽高
/// @param repeat 重复次数
/// @param path 输出路径
/// @param completion 回调
- (void)convertGIFToMP4:(NSData *)gif
                  speed:(float)speed
                   size:(CGSize)size
                 repeat:(int)repeat
                 output:(NSString *)path
             completion:(void (^)(NSError *))completion;

/// 开始转码
- (void)startConvertFormat;

@end

