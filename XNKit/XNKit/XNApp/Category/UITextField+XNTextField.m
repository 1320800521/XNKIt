//
//  UITextField+XNTextField.m
//  XNKit
//
//  Created by 小鸟 on 16/11/3.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "UITextField+XNTextField.h"
#import "UIColor+XNColor.h"

@implementation UITextField (XNTextField)

+(UITextField *)creatTextFieldWithFrame:(CGRect)frame placehold:(NSString *)placehold textColor:(NSString *)textColor placeHoldColor:(NSString *)placeHoldColor font:(CGFloat)font supperView:(UIView *)superView
{
    UITextField *text = [[UITextField alloc]initWithFrame:frame];
    text.placeholder = placehold;
    text.textAlignment = NSTextAlignmentRight;
    text.textColor = [UIColor colorWithHexString:textColor];
    [text setValue:[UIColor colorWithHexString:placeHoldColor] forKeyPath:@"_placeholderLabel.textColor"];
    [text setValue:[UIFont boldSystemFontOfSize:font] forKeyPath:@"_placeholderLabel.font"];
    text.borderStyle = UITextBorderStyleNone;
    [superView addSubview:text];
    return text;
}

+(UITextField *)creatTextFieldWithFrame:(CGRect)frame placehold:(NSString *)placehold textColor:(NSString *)textColor placeHoldColor:(NSString *)placeHoldColor font:(CGFloat)font
{
    UITextField *text = [[UITextField alloc]initWithFrame:frame];
    text.placeholder = placehold;
    text.textAlignment = NSTextAlignmentRight;
    text.textColor = [UIColor colorWithHexString:textColor];
    [text setValue:[UIColor colorWithHexString:placeHoldColor] forKeyPath:@"_placeholderLabel.textColor"];
    [text setValue:[UIFont boldSystemFontOfSize:font] forKeyPath:@"_placeholderLabel.font"];
    text.borderStyle = UITextBorderStyleNone;
    return text;
}

@end
