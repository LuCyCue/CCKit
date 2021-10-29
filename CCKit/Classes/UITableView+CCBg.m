//
//  UITableView+CCBg.m
//  LCCKit
//
//  Created by lucc on 2021/9/18.
//

#import "UITableView+CCBg.h"
#import <objc/runtime.h>

@implementation UITableView (CCBg)

- (void)cc_addLongBgWithImage:(UIImage *)image {
    if (!image) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat imageHeight = image.size.height * self.bounds.size.width / image.size.width;
        CGFloat contentHeight = self.contentSize.height + 150;
        NSInteger count = contentHeight / imageHeight + 1;
        for (int i = 0; i < count; i++) {
            CGRect frame = CGRectMake(0, i * imageHeight, self.bounds.size.width, imageHeight);
            [self cc_addBgLayerWithImage:image frame:frame];
        }
    });
}

- (void)cc_removeLongBg {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *bgLayers = [self _getBgLayers];
        [bgLayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CALayer *layer = (CALayer *)obj;
            [layer removeFromSuperlayer];
        }];
        [bgLayers removeAllObjects];
    });
}

- (void)cc_addBgLayerWithImage:(UIImage *)image frame:(CGRect)frame {
    NSMutableArray *bgLayers = [self _getBgLayers];
    CALayer *layer = [[CALayer alloc] init];
    layer.contents = (__bridge id)(image.CGImage);
    layer.frame = frame;
    layer.zPosition = -1;
    [self.layer addSublayer:layer];
    [bgLayers addObject:layer];
}

- (NSMutableArray *)_getBgLayers {
    NSMutableArray *bgLayers = objc_getAssociatedObject(self, _cmd);
    if (!bgLayers) {
        bgLayers = [NSMutableArray new];
        objc_setAssociatedObject(self, _cmd, bgLayers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bgLayers;
}

@end
