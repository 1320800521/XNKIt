//
//  UILabel+XNLabel.m
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "UILabel+XNLabel.h"

@implementation UILabel (XNLabel)

+ (UILabel *)createLabelWithFrame:(CGRect)rect fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

- (void)addUnderlineWithRange:(NSRange)lineRange {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:self.text];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:lineRange];
    self.attributedText = content;
}

+ (UILabel *)createLableWithFrame:(CGRect)rect text:(NSString *)text fontSize:(CGFloat)size rowSpace:(CGFloat)space textColor:(UIColor *)color{
    UILabel * lable = [[UILabel alloc] initWithFrame:rect];
    lable.font = [UIFont systemFontOfSize:size];
    lable.numberOfLines = 0;
    lable.text = text;
    lable.textColor = color;
    if (text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = space;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        lable.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    
    return lable;
}
+ (UILabel *)createLableWithAttributedSize:(CGRect)rect Text:(NSString *)text fontSize:(CGFloat)size MaxWidth:(CGFloat)maxWidth LineSpacing:(CGFloat)lineSpacing{
    
    UILabel * lable = [[UILabel alloc] initWithFrame:rect];
    lable.font = [UIFont systemFontOfSize:size];
    lable.text = text;
    if ([lable.text length]==0) {
        lable.text = @"无";
    }
    lable.numberOfLines = 0;
    //设置label内容宽度
    CGFloat textWidth = maxWidth;
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:lineSpacing];
    if (size*text.length<maxWidth) {
        [style setLineSpacing:0];
    }
    //判断内容长度是否大于Label内容宽度，如果不大于，则设置内容宽度为行宽（内容如果小于行宽，Label长度太短，如果Label有背景颜色，将影响布局效果）
    NSInteger leng = textWidth;
    if (attStr.length < textWidth) {
        leng = attStr.length;
    }
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng)];
    //Label获取attStr式样
    lable.attributedText = attStr;
    //Label自适应大小
    [lable sizeToFit];
    //设置Label高度
    //    lable.heigh
    //    label.height = label.frame.size.height;
    
    return lable;
}

+ (UILabel *)createLableWithAttributedSize:(CGRect)rect Text:(NSString *)text fontSize:(CGFloat)size maxWidthNo:(CGFloat)maxWidthNo LineSpacing:(CGFloat)lineSpacing {
    
    UILabel * lable = [[UILabel alloc] initWithFrame:rect];
    lable.font = [UIFont systemFontOfSize:size];
    lable.text = text;
    if ([lable.text length]==0) {
        lable.text = @"无";
    }
    lable.numberOfLines = 0;
    //设置label内容宽度
    CGFloat textWidth = maxWidthNo;
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:lineSpacing];
    //    if (size*text.length<maxWidth) {
    //        [style setLineSpacing:0];
    //    }
    //判断内容长度是否大于Label内容宽度，如果不大于，则设置内容宽度为行宽（内容如果小于行宽，Label长度太短，如果Label有背景颜色，将影响布局效果）
    NSInteger leng = textWidth;
    if (attStr.length < textWidth) {
        leng = attStr.length;
    }
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng)];
    //Label获取attStr式样
    lable.attributedText = attStr;
    //Label自适应大小
    [lable sizeToFit];
    //设置Label高度
    //    lable.heigh
    //    label.height = label.frame.size.height;
    
    return lable;
}

- (void)addLineSpacingfont:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 12;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    self.textAlignment = NSTextAlignmentCenter;
    
}
//获取lable自适应高度
- (CGFloat)getLableHeightWithMaxWidth:(CGFloat)maxWidth LineSpacing:(CGFloat)lineSpacing Font:(CGFloat)font Text:(NSString *)text{
    UILabel * la = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, maxWidth, 1)];
    la.text = @"1";
    la.font = [UIFont systemFontOfSize:font];
    la.backgroundColor = [UIColor yellowColor];
    la.numberOfLines = 0;
    [la sizeToFit];
    CGFloat min_height = la.frame.size.height;
    la.text = text;
    la.frame = CGRectMake(1, 1, maxWidth, 1);
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc] initWithString:la.text];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    [attstr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [la.text length])];
    la.attributedText = attstr;
    [la sizeToFit];
    if (la.frame.size.height<=min_height+lineSpacing) {
        style.lineSpacing = 0;
        [attstr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [la.text length])];
        la.attributedText = attstr;
        [la sizeToFit];
    }
    return la.frame.size.height;
}
- (void)addLineSpacingWith:(CGFloat)lineSpacing{
    
}

@end
