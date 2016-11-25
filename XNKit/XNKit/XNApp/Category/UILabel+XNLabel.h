//
//  UILabel+XNLabel.h
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XNLabel)

/**
 根据字体大小创建label

 @param rect label farme
 @param size 字体大小

 @return label
 */
+ (UILabel *)createLabelWithFrame:(CGRect)rect fontSize:(CGFloat)size;


/**
 在一个范围内添加行间距

 @param lineRange 范围
 */
- (void)addUnderlineWithRange:(NSRange)lineRange;

/**
 创建label

 @param rect  frame
 @param text  文字
 @param size  文字大小
 @param space 行间距
 @param color 字体颜色

 @return 返回label
 */
+ (UILabel *)createLableWithFrame:(CGRect)rect text:(NSString *)text fontSize:(CGFloat)size rowSpace:(CGFloat)space textColor:(UIColor *)color;

/**
 创建label

 @param rect        lable.farme
 @param text        label.text
 @param size        font
 @param maxWidth    最大宽度
 @param lineSpacing 行间距

 @return label
 */
+ (UILabel *)createLableWithAttributedSize:(CGRect)rect Text:(NSString *)text fontSize:(CGFloat)size MaxWidth:(CGFloat)maxWidth LineSpacing:(CGFloat)lineSpacing;
/**
 *  计算label高度
 *
 *  @param rect        label rect
 *  @param text        文字
 *  @param size        字体大小
 *  @param maxWidthNo  最大行宽 不判断行宽设置行间距
 *  @param lineSpacing 行间距
 *
 *  @return label
 */
+ (UILabel *)createLableWithAttributedSize:(CGRect)rect Text:(NSString *)text fontSize:(CGFloat)size maxWidthNo:(CGFloat)maxWidthNo LineSpacing:(CGFloat)lineSpacing;

/**
 设置行间距

 @param font 字体大小
 */
- (void)addLineSpacingfont:(UIFont *)font;

/**
 获取lable的高度

 @param maxWidth    最大宽度
 @param lineSpacing 行距
 @param font        字体大小
 @param text        文字

 @return 高度
 */
- (CGFloat)getLableHeightWithMaxWidth:(CGFloat)maxWidth LineSpacing:(CGFloat)lineSpacing Font:(CGFloat)font Text:(NSString *)text;

@end
