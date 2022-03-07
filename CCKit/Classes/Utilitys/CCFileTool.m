//
//  CCFileTool.m
//  Pods
//
//  Created by HuanZheng on 2022/2/26.
//

#import "CCFileTool.h"
#import <Photos/photos.h>

@implementation CCFileTool

/// 获取某个模块下的bundle
/// @param moduleName 模块名称
/// @param currentClass 定义在模块中的class
+ (NSBundle *)bundleWithModuleName:(NSString *)moduleName currentClass:(Class)currentClass {
    NSBundle *bundle = [NSBundle bundleForClass:currentClass];
    NSURL *url = [bundle URLForResource:moduleName withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

/// 将PHAsset写入沙盒
/// @param asset PHAsset实例
/// @param path 沙盒路径
/// @param completion 回调
/// @discussion iclound上的PHAsset不支持
+ (void)writePHAsset:(PHAsset *)asset targetPath:(NSString *)path completion:(void (^)(NSString *, UIImage *, NSData *, AVURLAsset *, NSError *))completion {
    if (!asset || path.length == 0) {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: @"输入参数错误"};
        !completion ?: completion(nil, nil, nil, nil, [[NSError alloc] initWithDomain:@"com.lcckit.filetool" code:500 userInfo:userInfo]);
        return;
    }
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    PHAssetResourceRequestOptions *resourceOptions = [PHAssetResourceRequestOptions new];
    resourceOptions.networkAccessAllowed = NO; //不支持icloud上传
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        // 图片类型
        for (PHAssetResource *assetRes in assetResources) {
           if (assetRes.type == PHAssetResourceTypePhoto) {
               resource = assetRes;
           }
        }
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        options.networkAccessAllowed = NO;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            NSError *error;
            UIImage *img = [UIImage imageWithData:imageData];
            NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
            [imgData writeToFile:path options:NSDataWritingAtomic error:&error];
            if (completion) {
                completion(path, img, imgData, nil, error);
            }
        }];
        
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        for (PHAssetResource *assetRes in assetResources) {
            if (assetRes.type == PHAssetResourceTypeVideo) {
               resource = assetRes;
            }
            if (@available(iOS 9.1, *)) {
                if (assetRes.type == PHAssetResourceTypePairedVideo) {
                    resource = assetRes;
                }
            }
        }
        PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:path] options:resourceOptions completionHandler:^(NSError *_Nullable error) {
                if (!error) {
                    // 获取首帧封面图
                    AVAssetImageGenerator *assetGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
                    assetGenerator.appliesPreferredTrackTransform = YES;
                    CMTime actualTime;
                    CGImageRef cgImage = [assetGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(0.0, 600) actualTime:&actualTime error:&error];
                    UIImage *image = [[UIImage alloc] initWithCGImage:cgImage];
                    CGImageRelease(cgImage);
                    if (completion) {
                         completion(path, image, UIImageJPEGRepresentation(image, 1.f), (AVURLAsset *)avasset, error);
                    }
                } else {
                    if (completion) {
                        completion(path, nil, nil, (AVURLAsset *)avasset, error);
                    }
                }
            }];
        }];
    }
}


@end
