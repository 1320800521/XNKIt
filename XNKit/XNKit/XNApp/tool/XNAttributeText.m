//
//  XNAttributeText.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/4.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNAttributeText.h"
#import "NSString+XNString.h"
#import <CoreText/CoreText.h>

#define kCoreTextFont       [UIFont fontWithName:@"Helvetica-Light" size:16]
#define kCoreTextUIFontName "Helvetica-Light"

@implementation XNAttributeText

+ (CGSize)getTextSize:(CGSize)size text:(NSString*)content font:(UIFont*)font
{
    UILabel *displayLabel = [[UILabel alloc] init];
    displayLabel.backgroundColor = [UIColor clearColor];
    displayLabel.text = content;
    displayLabel.numberOfLines = 0;
    displayLabel.font = font;
    
    CGRect _rect = CGRectMake(0, 0, size.width, size.height);
    _rect = [displayLabel textRectForBounds:_rect limitedToNumberOfLines:0];
    
    CGSize _size = CGSizeMake(_rect.size.width, _rect.size.height);
    return _size;
}

+ (CGSize)getTextSize:(CGSize)size text:(NSString*)content fontSize:(CGFloat)font
{
    UILabel *displayLabel = [[UILabel alloc] init];
    displayLabel.backgroundColor = [UIColor clearColor];
    displayLabel.text = content;
    displayLabel.numberOfLines = 0;
    displayLabel.font = [UIFont systemFontOfSize:font];
    
    CGRect _rect = CGRectMake(0, 0, size.width, size.height);
    _rect = [displayLabel textRectForBounds:_rect limitedToNumberOfLines:0];
    
    CGSize _size = CGSizeMake(_rect.size.width, _rect.size.height);
    return _size;
}

+ (CGSize)getTextBoldFontSize:(CGSize)size text:(NSString*)content fontSize:(CGFloat)font {
    UILabel *displayLabel = [[UILabel alloc] init];
    displayLabel.backgroundColor = [UIColor clearColor];
    displayLabel.text = content;
    displayLabel.numberOfLines = 0;
    displayLabel.font = [UIFont boldSystemFontOfSize:font];
    
    CGRect _rect = CGRectMake(0, 0, size.width, size.height);
    _rect = [displayLabel textRectForBounds:_rect limitedToNumberOfLines:0];
    
    CGSize _size = CGSizeMake(_rect.size.width, _rect.size.height);
    return _size;
}

+ (CGFloat)heightForTextView:(NSString*)content fontSize:(CGFloat)font textViewFrame:(CGRect)rect{
    
    UITextView *displayTextView = [[UITextView alloc] init];
    displayTextView.backgroundColor = [UIColor clearColor];
    displayTextView.text = content;
    displayTextView.font = [UIFont systemFontOfSize:font];
    displayTextView.frame = rect;
    
    CGFloat fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(displayTextView.contentSize.width - fPadding, CGFLOAT_MAX);
    
    
    CGSize newSize = [content getSizeWithFont:displayTextView.font constrainedToSize:constraint];
    //CGSize newSize = [content sizeWithFont: displayTextView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat fHeight = newSize.height + 16.0;
    
    return fHeight;
}

+ (NSAttributedString *)setAttributeStingWithString:(NSString *)content
                                         nomalColor:(UIColor *)nomalColor
                                          nomalFont:(UIFont *)nomalFont
                                         nomalRange:(NSRange)nomalRange
                                          attrColor:(UIColor *)attrColor
                                           attrFont:(UIFont *)attrFont
                                          attrRange:(NSRange)attrRang
                                          lineSpace:(CGFloat)lineSpace{

//
    
    NSMutableParagraphStyle *paragraghStyle = [[NSMutableParagraphStyle alloc]init];
    paragraghStyle.lineBreakMode = NSLineBreakByClipping;
    paragraghStyle.lineSpacing = lineSpace;

    // 正常字体
    NSDictionary *nomalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,nomalFont,NSParagraphStyleAttributeName,paragraghStyle,NSStrikethroughColorAttributeName,nomalColor, nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:content];
    [attr setAttributes:nomalAttributes range:nomalRange];
   
    // 特殊字体
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,attrFont,NSParagraphStyleAttributeName,paragraghStyle,NSStrikethroughColorAttributeName,attrColor, nil];
    
    [attr setAttributes:attributes range:attrRang];
    
    return (NSAttributedString *)attr;
}


+ (NSMutableAttributedString*)setTextBynew:(NSString *)text WithFont:(UIFont*)font fontSize:(CGFloat)nfontSize
{
    NSInteger len = [text length];
    NSMutableAttributedString *_resultAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [_resultAttributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                                    value:(id)[UIColor blueColor].CGColor
                                    range:NSMakeRange(0, len)];
    
    //CTFontRef ctFont2 = CTFontCreateWithName(CFSTR(FS_CoreTextUIFontName), FS_BigFont, NULL);
    CTFontRef ctFont2 = CTFontCreateWithName(CFSTR(kCoreTextUIFontName), nfontSize, NULL);
    [_resultAttributedString addAttribute:(NSString *)(kCTFontAttributeName)
                                    value:(__bridge id)ctFont2
                                    range:NSMakeRange(0, len)];
    CFRelease(ctFont2);
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTLeftTextAlignment;//左对齐
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    //创建文本行间距
    CGFloat lineSpace = 4.2f;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;//指定为行间距属性
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    //创建样式数组
    CTParagraphStyleSetting settings[] = {
        alignmentStyle,lineSpaceStyle
    };
    //设置样式
    
    //CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings,  sizeof(settings)/sizeof(settings[0]));
    
    //给字符串添加样式attribute
    [_resultAttributedString addAttribute:(id)kCTParagraphStyleAttributeName
                                    value:(__bridge id)paragraphStyle
                                    range:NSMakeRange(0, [_resultAttributedString length])];
    CFRelease(paragraphStyle);
    
    return _resultAttributedString;
}

+ (NSMutableAttributedString*)setTextBynewMessage:(NSString *)text WithFont:(UIFont*)font fontSize:(CGFloat)nfontSize
{
    NSInteger len = [text length];
    NSMutableAttributedString *_resultAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [_resultAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                    value:CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:16].fontName, 16, NULL))
                                    range:NSMakeRange(0,len)];
    CTParagraphStyleSetting alignmentStyle;
    CTTextAlignment alignment = kCTLeftTextAlignment;
    
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    
    alignmentStyle.valueSize = sizeof(kCTLeftTextAlignment);
    
    alignmentStyle.value = &alignment;
    
    CGFloat lineSpace = 4.0f;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
    CGFloat paragraphSpacing = 16.0;
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    paragraphSpaceStyle.value = &paragraphSpacing;
    
    CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
    
    [_resultAttributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [_resultAttributedString length])];
    
    return _resultAttributedString;
}


+ (NSInteger)especialAttributedStringHeightStringBynew:(NSString*)content WidthValue:(NSInteger)width fontSize:(CGFloat)nfontSize
{
    if ([[[UIDevice currentDevice] systemVersion] longLongValue] >= 7) {
        return [self getAttributedStringHeightWithStringBynewMessage:content WidthValue:width fontSize:nfontSize];
    } else {
        return [self getAttributedStringHeightWithStringBynew:content WidthValue:width fontSize:nfontSize];
    }
}

+ (NSInteger)getAttributedStringHeightWithStringBynewMessage:(NSString*)content WidthValue:(NSInteger)width fontSize:(CGFloat)nfontSize
{
    NSInteger total_height = 0;
    NSInteger nCount = 0;
    if( content && [content length] > 0 )
    {
        NSMutableAttributedString *mutaString = [[self class] setTextBynewMessage:content WithFont:[UIFont systemFontOfSize:16.0] fontSize:nfontSize];
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mutaString);
        CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, drawingRect);
        CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), path, NULL);
        CGPathRelease(path);
        CFRelease(framesetter);
        
        NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
        
        CGPoint origins[[linesArray count]];
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
        
        int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        
        CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        total_height = 100000 - line_y + (int) descent + 2;    //+1为了纠正descent转换成int小数点后舍去的值
        
        nCount = [linesArray count]- 1;
        CFRelease(textFrame);
    }
    
    return total_height;
}

+ (NSInteger)getAttributedStringHeightWithStringBynew:(NSString*)content WidthValue:(NSInteger)width fontSize:(CGFloat)nfontSize
{
    NSInteger total_height = 0;
    if( content && [content length] > 0 )
    {
        NSMutableAttributedString *mutaString = [[self class] setTextBynew:content WithFont:kCoreTextFont fontSize:nfontSize];
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mutaString);
        CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, drawingRect);
        CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
        CGPathRelease(path);
        CFRelease(framesetter);
        
        NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
        
        CGPoint origins[[linesArray count]];
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
        
        int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        
        CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        total_height = 100000 - line_y + (int) descent + 2;    //+1为了纠正descent转换成int小数点后舍去的值
        
        int  newtotal_height = [linesArray count]*18+([linesArray count]-1)*4.2;
        
        NSLog(@"%lu",(unsigned long)[linesArray count]);
        
        NSLog(@"getAttributedStringHeightWithStringByTest:%ld",(long)total_height);
        
        NSLog(@"new getAttributedStringHeightWithStringByTest:%d",newtotal_height);
        
        CFRelease(textFrame);
    }
    
    return total_height;
}

@end
