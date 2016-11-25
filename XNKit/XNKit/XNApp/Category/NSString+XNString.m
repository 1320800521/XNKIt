//
//  NSString+XNString.m
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "NSString+XNString.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
//#import "UIDevice+IdentifierAddition.h"

static NSString* DigitChars = @"0123456789";
static NSString* CodeChars = @"123456789ABCDEFGHIJKLMNPQRSTUWXYZ";

@implementation NSString (XNString)

- (NSString *)md5Str {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+ (BOOL)strisEmpty:(NSString *)string {
    if([string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]])
        return NO;
    if ([string isKindOfClass:[NSNumber class]]) {
        if (string != nil) {
            return  YES;
        }
        return NO;
    } else {
        string = [self trimString:string];
        if (string != nil && string.length > 0 && ![string isEqualToString:@"null"] && ![string isEqualToString:@"(null)"] && ![string isEqualToString:@" "]) {
            return  YES;
        }
        return NO;
    }
}

+ (NSString *)trimString:(NSString *) str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (id)nullToString
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }else
        return self;
}


//判断是否为整形
- (BOOL)isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//转换拼音
- (NSString *)transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    NSMutableString *tempString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [tempString uppercaseString];
}


- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size
                                        options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self getSizeWithFont:font constrainedToSize:size].width;
}


- (NSString *)MD5EncodedString
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

-(NSString *)URLEncodingUTF8String
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}

- (NSComparisonResult)sortChineseCharacter:(NSString *)otherString
{
    
    NSInteger dec_src = (NSInteger)[self characterAtIndex:0];
    NSInteger dec_dest = (NSInteger)[otherString characterAtIndex:0];
    if (labs(dec_src - dec_dest) > 128) {
        return (dec_src > dec_dest  ? NSOrderedDescending : NSOrderedAscending);
    }
    
    return [self localizedCaseInsensitiveCompare:otherString];
}

- (NSString *)getGender
{
    if ([self isEqualToString:@"male"]) {
        return @"男";
    }else
        return @"女";
}

- (NSString *)exchangeGender
{
    if ([self isEqualToString:@"男"]) {
        return @"male";
    }else
        return @"female";
}

- (NSString *)pngImageName
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height<=480) {
        return [NSString stringWithFormat:@"%@@2x.png", self];
    } else if (height == 568) {
        return [NSString stringWithFormat:@"%@-568h@2x.png", self];
    } else if (height == 667) {
        return [NSString stringWithFormat:@"%@-667h@2x.png", self];
    } else if (height == 736) {
        return [NSString stringWithFormat:@"%@-736h@3x.png", self];
    }
    return [NSString stringWithFormat:@"%@-736h@3x.png", self];
}

- (NSDictionary *)strToJson
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    return dic;
}



// ------------------------------------------------------------------------------------



#pragma mark -
#pragma mark validate

/**
 验证输入框

 @param text      输入内容
 @param required  要求
 @param maxLength 最大长度

 @return 要求类型
 */
+ (NSString*)validateText:(NSString *)text required:(BOOL)required maxLength:(int)maxLength {
    if (text == nil || [text length] <= 0) {
        if (required)
            return @"此项为必填项。";
        return nil;
    }
    
    if ([text length] <= maxLength)
        return nil;
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0"];
    NSString* error = [formatter stringFromNumber:[NSNumber numberWithInt:maxLength]];
    NSString *tempStr = [NSString stringWithFormat:@"此项不可超过 %@ 个字", error];
    return tempStr;
}



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
+ (NSString*)validateText:(NSString*)text required:(BOOL)required minLength:(int)minLength maxLength:(int)maxLength pattern:(NSString*)pattern error:(NSString*) error {
    if (text == nil || [text length] <= 0) {
        if (required)
            return @"此项为必填项。";
        return nil;
    }
    
    NSInteger len = [text length];
    if (len >= minLength && len <= maxLength) {
        if (pattern == nil || [pattern length] <= 0)
            return nil;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        if ([predicate evaluateWithObject:text])
            return nil;
    }
    
    return error;
}


/**
 验证手机号输入长度

 @param mobile   手机号输入框
 @param required 要求

 @return 输入字符串
 */
+ (NSString*)validateChineseMobile:(NSString *)mobile required:(BOOL)required {
    return [[self class] validateText:mobile required:required minLength:11 maxLength:11 pattern:@"^[\\d]+$" error:@"此项应为11位的手机号"];
}


/**
 验证输入贵州

 @param boolString 输入内容
 @param required   要求

 @return 返回验证结果
 */
+ (NSString*)validateBoolean:(NSString *)boolString required:(BOOL)required {
    return [[self class] validateText:boolString required:required minLength:0 maxLength:2 pattern:@"^(是|否)$" error:@"此项为必填项且只能输入 【是】或【否】"];
}


/**
 验证性别输入

 @param sex      性别
 @param required 要求

 @return 验证后结果
 */
+ (NSString*)validateSex:(NSString *)sex required:(BOOL)required {
    return [[self class] validateText:sex required:required minLength:0 maxLength:2 pattern:@"^(男|女)$" error:@"此项为必填项且只能输入 【男】或【女】"];
}


/**
 验证输入字符长度

 @param str     输入字符
 @param required 要求

 @return 验证后结果
 */
+ (NSString*)validateStr:(NSString *)str required:(BOOL)required {
    return [[self class] validateText:str required:required minLength:2 maxLength:20 pattern:nil error:@"此项应为2-20个字符组成"];
}


#pragma mark -
#pragma mark split

+ (NSArray *)httpStringToArray:(NSString*)text
{
    NSMutableArray  *array = [NSMutableArray array];
    //@"test,content:232helloregex http://www.appfanr.com?who=me&where=china http://appfanr.com/";
    NSString *urlPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlPattern options:NSRegularExpressionCaseInsensitive error:&error ];
    NSUInteger count =[regex numberOfMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];//匹配到的次数
    if(count > 0) {
        NSArray* matches = [regex matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            [array addObject:[text substringWithRange:matchRange]];
        }
    }
    
    return array;
}

//获取电话号码的正则表达式
+(NSArray*)TelNumberStringArrayFromText:(NSString*)text {
    __block NSMutableArray  * array = [NSMutableArray array];
    
    if(text && [text length]>0) {
        
        NSError *error;
        NSMutableSet* keys = [NSMutableSet set];
        
        NSRegularExpression *regex = nil;
        regex = [NSRegularExpression regularExpressionWithPattern:@"(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?)|(110|120|119|114))" options:0 error:&error];
        
        //  regex = [NSRegularExpression regularExpressionWithPattern:@"(13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}" options:0 error:&error];
        if (regex != nil) {
            [regex enumerateMatchesInString:text options:0 range:NSMakeRange(0, [text length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                NSString* item = [[text substringWithRange:[result rangeAtIndex:0]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString* key = [item uppercaseString];
                if (item != nil && [item length] > 0 && ![keys containsObject:key]) {
                    [keys addObject:key];
                    [array addObject:item];
                }
            }];
        }
    }
    
    return array;
}


#pragma mark -
#pragma mark random
+(NSString*)randomStringWithLength:(unsigned int)length chars:(NSString*)chars {
    NSMutableString* buffer = [NSMutableString string];
    for (unsigned int i = 0; i < length; i++) {
        u_int32_t index = arc4random() % [chars length];
        unichar c = [chars characterAtIndex:index];
        [buffer appendFormat:@"%C", c];
    }
    
    return buffer;
}

+(NSString*)randomIntStringWithLength:(unsigned int)length {
    return [[self class] randomStringWithLength:length chars:DigitChars];
}

+(NSString*)randomCodeStringWithLength:(unsigned int)length {
    return [[self class] randomStringWithLength:length chars:CodeChars];
}

#pragma mark -
#pragma mark -- PhotoNumer

+(BOOL)containsString:(NSString *)aString SrcStr:(NSString*)Str
{
    NSRange range = [[Str lowercaseString] rangeOfString:[aString lowercaseString]];
    return range.location != NSNotFound;
}

//判断手机号码
+(BOOL)validatePhoneNumber:(NSString *)string
{
    NSString *Regex = @"(13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:string];
}

//判断电子邮箱
+(BOOL)validateEmail:(NSString *)string
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailPredicate evaluateWithObject:string];
}

//判断是否是整数
+(BOOL)validateInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断书否是浮点数
+(BOOL)validateFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//判断字符串是否都为空格“ ”
+ (BOOL)isSeparatedByText:(NSString*)text
{
    BOOL isAllSpace = YES;
    if (text) {
        NSString *textOhter = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (textOhter && textOhter.length > 0) {
            isAllSpace = NO;
        }
    }
    return isAllSpace;
}

+(NSString*)stringByReplacingNewLineCharsOfString:(NSString *)string {
    if (string == nil || string.length <= 0)
        return string;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\r(\n)?" options:0 error:nil];
    return [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@"\n"];
}


@end
