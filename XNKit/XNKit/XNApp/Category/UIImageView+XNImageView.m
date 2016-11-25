//
//  UIImageView+XNImageView.m
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "UIImageView+XNImageView.h"
#import "UIColor+XNColor.h"

@implementation UIImageView (XNImageView)
- (void)doCircleFrameWithColor:(NSString *)colorSting{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"colorSting"].CGColor;
}
- (void)doNotCircleFrame{
    self.layer.cornerRadius = 0.0;
    self.layer.borderWidth = 0.0;
}

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius color:(NSString *)colorSting{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    if (!color) {
        self.layer.borderColor = [UIColor colorWithHexString:colorSting].CGColor;
    }else{
        self.layer.borderColor = color.CGColor;
    }
}

@end
