//
//  XNAttributeText.h
//  XNKit
//
//  Created by 小鸟 on 2016/11/4.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface XNAttributeText : NSObject

#pragma mark -
#pragma mark -- Text Size
+ (CGSize)getTextSize:(CGSize)size text:(NSString*)content font:(UIFont*)font;

+ (CGSize)getTextSize:(CGSize)size text:(NSString*)content fontSize:(CGFloat)font;

/**
 获取字体大小

 @param size    控件到校
 @param content 文本
 @param font    字号

 @return 单个字体大小
 */
+ (CGSize)getTextBoldFontSize:(CGSize)size text:(NSString*)content fontSize:(CGFloat)font;

/**
 获取文字高度

 @param content 文字内容
 @param font    字体大小
 @param rect    控件frame

 @return 字体高度
 */
+ (CGFloat)heightForTextView:(NSString*)content fontSize:(CGFloat)font textViewFrame:(CGRect)rect;


+ (NSMutableAttributedString*)setTextBynew:(NSString *)text WithFont:(UIFont*)font fontSize:(CGFloat)nfontSize;
+ (NSInteger)getAttributedStringHeightWithStringBynew:(NSString*)content WidthValue:(NSInteger)width fontSize:(CGFloat)nfontSize;

/**
 更具需求设置富文本

 @param content    普通文本
 @param nomalColor 普通文本颜色
 @param nomalFont  普通文本字体（字体+大小）
 @param nomalRange 普通字体范围
 @param attrColor  富文本颜色
 @param attrFont   富文本字体（字体+大小）
 @param attrRang   富文本范围

 @return 最后富文本
 */
+ (NSAttributedString *)setAttributeStingWithString:(NSString *)content
                                         nomalColor:(UIColor *)nomalColor
                                          nomalFont:(UIFont *)nomalFont
                                         nomalRange:(NSRange)nomalRange
                                          attrColor:(UIColor *)attrColor
                                           attrFont:(UIFont *)attrFont
                                          attrRange:(NSRange)attrRang
                                          lineSpace:(CGFloat)lineSpace;

/*! @brief bug-fixed: 一行且写满（length26）的string显示有问题 V>ios7
 * @author ycb
 */
+ (NSInteger)especialAttributedStringHeightStringBynew:(NSString*)content WidthValue:(NSInteger)width fontSize:(CGFloat)nfontSize;



@end
