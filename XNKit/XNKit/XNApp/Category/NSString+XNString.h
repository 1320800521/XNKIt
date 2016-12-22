//
//  NSString+XNString.h
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (XNString)


/**
 MD5 加密

 @return 加密后字符串
 */
//- (NSString *)md5Str;

- (NSString *)nullToString;

+ (NSString *)trimString:(NSString *) str;

/**

 @return  字符串是否为空
 */
+ (BOOL)strisEmpty:(NSString *)string;
//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;

//转换拼音
- (NSString *)transformToPinyin;

// ***********  MD5 Encoding ********************
- (NSString *)MD5EncodedString;
- (NSString *)URLEncodingUTF8String;

// *********** Chinese Letter *********************
- (NSComparisonResult)sortChineseCharacter:(NSString *)otherString;


//判断字符串是否都为空格“ ”
+ (BOOL)isSeparatedByText:(NSString*)text;


#pragma mark -
#pragma mark validate

/**
 验证输入框
 
 @param text      输入内容
 @param required  要求
 @param maxLength 最大长度
 
 @return 要求类型
 */
+ (NSString*)validateText:(NSString *)text required:(BOOL)required maxLength:(int)maxLength;



/**
 验证输入内容和要求
 
 @param text      输入内容
 @param required  要求描述
 @param minLength 最小长度
 @param maxLength 最大长度
 @param pattern pattern
 @param error error
 
 @return 验证结果
 */
+ (NSString*)validateText:(NSString*)text required:(BOOL)required minLength:(int)minLength maxLength:(int)maxLength pattern:(NSString*)pattern error:(NSString*) error;


/**
 验证手机号输入长度
 
 @param mobile   手机号输入框
 @param required 要求
 
 @return 输入字符串
 */
+ (NSString*)validateChineseMobile:(NSString *)mobile required:(BOOL)required;


/**
 验证输入贵州
 
 @param boolString 输入内容
 @param required   要求
 
 @return 返回验证结果
 */
+ (NSString*)validateBoolean:(NSString *)boolString required:(BOOL)required;


/**
 验证性别输入
 
 @param sex      性别
 @param required 要求
 
 @return 验证后结果
 */
+ (NSString*)validateSex:(NSString *)sex required:(BOOL)required;


/**
 验证输入字符长度
 
 @param str     输入字符
 @param required 要求
 
 @return 验证后结果
 */
+ (NSString*)validateStr:(NSString *)str required:(BOOL)required;


#pragma mark -
#pragma mark split

+ (NSArray *)httpStringToArray:(NSString*)text;

//获取电话号码的正则表达式
+(NSArray*)TelNumberStringArrayFromText:(NSString*)text;

#pragma mark -
#pragma mark random
+(NSString*)randomStringWithLength:(unsigned int)length chars:(NSString*)chars ;;

+(NSString*)randomIntStringWithLength:(unsigned int)length;

+(NSString*)randomCodeStringWithLength:(unsigned int)length;

#pragma mark -
#pragma mark -- PhotoNumer

+(BOOL)containsString:(NSString *)aString SrcStr:(NSString*)Str;

//判断手机号码
+(BOOL)validatePhoneNumber:(NSString *)string;

//判断电子邮箱
+(BOOL)validateEmail:(NSString *)string;

//判断是否是整数
+(BOOL)validateInt:(NSString *)string;

//判断书否是浮点数
+(BOOL)validateFloat:(NSString *)string;


- (NSString *)getGender;
- (NSString *)exchangeGender;
- (NSString *)pngImageName;
- (NSDictionary *)strToJson;

//字符串操作
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;



@end
