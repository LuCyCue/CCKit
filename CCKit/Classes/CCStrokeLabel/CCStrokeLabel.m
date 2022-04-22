//
//  CCStrokeLabel.m
//  LCCKit
//
//  Created by lucc on 2022/4/12.
//

#import "CCStrokeLabel.h"

@implementation CCStrokeLabel

- (void)drawTextInRect:(CGRect)rect {
    if (self.strokeWidth) {
        CGSize shadowOffset = self.shadowOffset;
        UIColor *textColor = self.textColor;
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 描边
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        self.textColor = self.strokeColor;
        [super drawTextInRect:rect];
        // 文字
        self.textColor = textColor;
        CGContextSetTextDrawingMode(context, kCGTextFill);
        self.shadowOffset = CGSizeMake(0, 0);
        [super drawTextInRect:rect];
        self.shadowOffset = shadowOffset;
    } else {
        [super drawTextInRect:rect];
    }
}

@end
