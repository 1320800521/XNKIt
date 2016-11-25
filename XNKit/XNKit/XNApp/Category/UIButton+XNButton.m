//
//  UIButton+XNButton.m
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "UIButton+XNButton.h"
#import "UIImage+XNImage.h"

@implementation UIButton (XNButton)

- (void)setBackgroundImageWithColor:(UIColor *)color andTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:color size:self.frame.size] forState:UIControlStateNormal];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
}
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    [self setBackgroundImage:[self createImageWithColor:color] forState:state
     ];
}
- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}
- (void)addClickBackgroundColor:(UIColor *)color{
    [self setBackgroundColor:color forState:UIControlStateHighlighted];
}
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title TitleColor:(UIColor *)titleColor Backgroundcolor:(UIColor *)backgroundColor TitleFont:(CGFloat)font CornerRadius:(CGFloat)cornerRadius ClickBackColor:(UIColor *)clickBackColor forState:(UIControlState)state {
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:state];
    [button setTitleColor:titleColor forState:state];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.layer.cornerRadius = cornerRadius;
    [button setBackgroundColor:[UIColor colorWithHexString:@"f8f8f8"] forState:UIControlStateNormal];
    [button setBackgroundColor:clickBackColor forState:UIControlStateHighlighted];
    UIImageView * ima = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_shadow.png"]];
    ima.frame = CGRectMake(0, -2, frame.size.width, 2);
    [button addSubview:ima];
    return button;
}
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title TitleColor:(UIColor *)titleColor Backgroundcolor:(UIColor *)backgroundColor TitleFont:(CGFloat)font ClickBackColor:(UIColor *)clickBackColor forState:(UIControlState)state {
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:state];
    [button setTitleColor:titleColor forState:state];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setBackgroundColor:backgroundColor forState:UIControlStateNormal];
    [button setBackgroundColor:clickBackColor forState:UIControlStateHighlighted];
    return button;
}
+ (UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title TitleColor:(UIColor *)titleColor TitleFont:(CGFloat)font Image:(NSString *)image{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return button;
}

@end
