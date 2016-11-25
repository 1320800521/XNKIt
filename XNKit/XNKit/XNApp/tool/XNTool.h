//
//  XNTool.h
//  XNKit
//
//  Created by 小鸟 on 16/11/3.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XNTool : NSObject

//GB2312转换为UTF8格式
+ (NSData *)convertGB2312toUTF8Data:(NSData *)gb2312Data;

//NSData转NSString
+ (NSString *)convertDataToString:(NSData *)aData;

//NSString转NSData
+ (NSData *)convertStringToData:(NSString *)aString;

//获取当前时间
+ (NSString *)getNowDateWithFormat:(NSString *)format;

//时间NSDate转NSString
+ (NSString *)convertDateToString:(NSDate *)aDate withFormat:(NSString *)format;

//NSString转NSDate时间
+ (NSDate *)convertStringToDate:(NSString *)aString withFormat:(NSString *)format;

//获取时间戳(13位)
+ (NSString *)get13TimeStamp;

/**
 * 时间戳转日期(13位)
 */
+ (NSDate *)getDateFrom13Timestamp:(NSString *)timestamp;

/*!
 * 时间戳转时间(13位)
 */
+ (NSString *)getStringFrom13Timestamp:(NSString *)timestamp withFormat:(NSString *)format;

/*!
 * 时间戳转时间(默认10位)
 */
+ (NSString *)getStringFromTimestamp:(NSString *)timestamp withFormat:(NSString *)format;

//随机获取颜色值
+ (UIColor *)getRandomColor;

//十六进制色值转rgb
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

//隐藏UITableView多余的分割线
+ (void)setExtraCellLineHidden:(UITableView *)tableView;

/**
 * 获取一个随机整数，范围在[from, to]，包括from，包括to
 * 1、  获取一个随机整数范围在：[0,100)包括0，不包括100 (int x = arc4random() % 100;)
 * 2、  获取一个随机数范围在：[500,1000]，包括500，包括1000 (int y = (arc4random() % 501) + 500;)
 */
+ (NSInteger)getRandomNumFrom:(NSInteger)from toNum:(NSInteger)to;

#pragma mark -
#pragma mark - verify
//判断手机号是否正确
+ (BOOL)isMobilePhone:(NSString *)phoneNo;
//判断字符串长度
+ (BOOL)verifyPasswordLength:(NSString *)passWord;
//判断密码是否有效，是否包含字母和数字，并且长度为6-20
+ (BOOL)verifyPasswdValid:(NSString *)str;

+ (UIView *)sharedWindow;
/**
 *  判断输入字符串中 是否包含 除 数字、小数点以外其他字符 （0-9 .）
 *
 *  @param inputStr 输入字符串
 *
 *  @return YES：合法 NO：不合法
 */
+(BOOL) isCurruteInpute:(NSString *)inputStr;

+(BOOL) isCurruteInpute_point:(NSString *)inputStr;

// 获取本地图片，并转为url地址
+(NSString *)getImgToUrl:(NSString *)imageName;
/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

@end
