//
//  UIImageView+XNImageView.h
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (XNImageView)
- (void)doCircleFrameWithColor:(NSString *)colorSting;
- (void)doNotCircleFrame;
- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius color:(NSString *)colorSting;
@end
