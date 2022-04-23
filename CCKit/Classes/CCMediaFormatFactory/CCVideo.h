//
//  CCVideo.h
//  LCCKit
//
//  Created by lucc on 2022/4/23.
//

#import <Foundation/Foundation.h>

@interface CCVideo : NSObject

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

@end

