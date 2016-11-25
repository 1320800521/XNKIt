//
//  UITextField+XNTextField.h
//  XNKit
//
//  Created by 小鸟 on 16/11/3.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (XNTextField)

+(UITextField *)creatTextFieldWithFrame:(CGRect)frame placehold:(NSString *)placehold textColor:(NSString *)textColor placeHoldColor:(NSString *)placeHoldColor font:(CGFloat)font supperView:(UIView *)superView;

+(UITextField *)creatTextFieldWithFrame:(CGRect)frame placehold:(NSString *)placehold textColor:(NSString *)textColor placeHoldColor:(NSString *)placeHoldColor font:(CGFloat)font;

@end
