//
//  UIButton+XNButton.h
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XNButton)
- (void)setBackgroundImageWithColor:(UIColor *)color andTitleColor:(UIColor *)titleColor;
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title TitleColor:(UIColor *)titleColor Backgroundcolor:(UIColor *)backgroundColor TitleFont:(CGFloat)font CornerRadius:(CGFloat)cornerRadius ClickBackColor:(UIColor *)clickBackColor forState:(UIControlState)state;
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title TitleColor:(UIColor *)titleColor TitleFont:(CGFloat)font Image:(NSString *)image;
- (void)addClickBackgroundColor:(UIColor *)color;
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title TitleColor:(UIColor *)titleColor Backgroundcolor:(UIColor *)backgroundColor TitleFont:(CGFloat)font ClickBackColor:(UIColor *)clickBackColor forState:(UIControlState)state;

@end
