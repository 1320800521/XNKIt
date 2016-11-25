//
//  XNTool.m
//  XNKit
//
//  Created by 小鸟 on 16/11/3.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNTool.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIAlertView+XNBlock.h"
#import <AVFoundation/AVFoundation.h>


@implementation XNTool

//GB2312转换为UTF8格式
+ (NSData *)convertGB2312toUTF8Data:(NSData *)gb2312Data {
    NSStringEncoding strEncodint = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str = [[NSString alloc] initWithData:gb2312Data encoding:strEncodint];
    NSData *utf8Data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return utf8Data;
}

//NSData转NSString
+ (NSString *)convertDataToString:(NSData *)aData {
    NSString *strResult = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    return strResult;
}

//NSString转NSData
+ (NSData *)convertStringToData:(NSString *)aString {
    NSData* dataResult = [aString dataUsingEncoding:NSUTF8StringEncoding];
    return dataResult;
}

//获取当前时间
+ (NSString *)getNowDateWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format]; //@"yyyy-MM-dd HH:mm"
    NSString *nowDateTime = [dateFormatter stringFromDate:[NSDate date]];
    return nowDateTime;
}

//NSDate转NSString
+ (NSString *)convertDateToString:(NSDate *)aDate withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:aDate];
    
    return strDate;
}

//NSString转NSDate
+ (NSDate *)convertStringToDate:(NSString *)aString withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:aString];
    
    return date;
}

//获取时间戳(13位)
+ (NSString *)get13TimeStamp {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]*1000] longValue]];
    return timeSp;
}

/**
 * 时间戳转日期(13位)
 */
+ (NSDate *)getDateFrom13Timestamp:(NSString *)timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]/1000];
    return confromTimesp;
}

/*!
 * 时间戳转时间(13位)
 */
+ (NSString *) getStringFrom13Timestamp:(NSString *)timestamp withFormat:(NSString *)format {
    NSDate *date = [self getDateFrom13Timestamp:timestamp];
    NSString *strDate = [self convertDateToString:date withFormat:format];
    return strDate;
}

/*!
 * 时间戳转时间(默认10位)
 */
+ (NSString *)getStringFromTimestamp:(NSString *)timestamp withFormat:(NSString *)format {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
    NSString *strDate = [self convertDateToString:confromTimesp withFormat:format];
    return strDate;
}

//获取随机颜色
+ (UIColor *)getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *randomColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return randomColor;
}

//十六进制色值转rgb
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha {
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}

//隐藏UITableView多余的分割线
+ (void)setExtraCellLineHidden:(UITableView *)tableView {
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

/**
 * 获取一个随机整数，范围在[from, to]，包括from，包括to
 */
+ (NSInteger)getRandomNumFrom:(NSInteger)from toNum:(NSInteger)to {
    return (NSInteger)(from + (arc4random() % (to-from+1)));
}

//判断手机号是否正确
// ^((13[0-9])|(147)|(17[0,1,3,6,7,8])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
//+ (BOOL)isMobilePhone:(NSString *)phoneNo {
//    if ([StringUtils isEmptyOrNull:phoneNo]) {
//        return NO;
//    }
//    if (![StringUtils validatePhoneNumber:phoneNo]) {
//        return NO;
//    }
//    return YES;
//}

+ (UIView *)sharedWindow {
    return (UIView *)[(AppDelegate *)[UIApplication sharedApplication].delegate window];
}

//判断字符串长度
+ (BOOL)verifyPasswordLength:(NSString *)passWord {
    int strlength = 0;
    char* p = (char*)[passWord cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[passWord lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    if (strlength >= 6 && strlength <= 20) {
        return YES;
    }
    return NO;
}

//判断密码是否有效，是否包含字母和数字，并且长度为6-20
+ (BOOL)verifyPasswdValid:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z][a-zA-Z0-9_]{5,20}$";
    NSRegularExpression *regularexpression =[[NSRegularExpression alloc]initWithPattern:pattern  options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0) {
        return YES;
    }
    return NO;
}

+(BOOL) isCurruteInpute:(NSString *)inputStr
{
    /**
     *   ^[0-9]+([.]{0}|[.]{1}[0-9]+)$
     */
    
    NSString * regex = @"^\\+?[1-9][0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputStr];
    
    return !isMatch;
}
//不带小数点
+(BOOL) isCurruteInpute_point:(NSString *)inputStr
{
    /**
     *   ^[0-9]+([.]{0}|[.]{1}[0-9]+)$
     */
    
    NSString * regex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:inputStr];
    
    return !isMatch;
    
}

// 获取本地图片，并转为url地址
+(NSString *)getImgToUrl:(NSString *)imageName{
    NSString *fp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imageName];
    return [[NSFileManager defaultManager] fileExistsAtPath:fp]?fp:nil;
    
}

+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    //    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (ALAuthorizationStatusDenied == authStatus || ALAuthorizationStatusRestricted == authStatus) {
        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
        return NO;
    }
    //    }
    return YES;
}

// 检查相机权限
+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:tipStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [aler showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL];
                }
            }
        }];
    } else {
//        kTipAlert(@"%@", tipStr);
    }
}

+ (void)checkLocationAuthor{
//
//    ALAuthorizationStatus status = [CLLocationManager authorizationStatus];
//    if (kCLAuthorizationStatusDenied == status || ALAuthorizationStatusRestricted == status) {
//        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
//            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在手机设置中开启定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"开启定位", nil];
//            [aler showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//                if (buttonIndex==1) {
//                    //                [self setCanRefresh:YES];
//                    UIApplication *app = [UIApplication sharedApplication];
//                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    if ([app canOpenURL:settingsURL]) {
//                        [app openURL:settingsURL];
//                    }
//                }else{
//                    
////                    NoDataView *view = [[NoDataView alloc] init];
////                    [view.titleLabel setText:@"定位服务未开启"];
////                    view.titleLabel.numberOfLines = 2;
////                    self.nearActiveTable.backgroundView = view;
//                    
//                }
//            }];
//            
//        } else {
//            kTipAlert(@"请在手机设置中开启定位服务");
//        }
//    }else{
//        [self startRefresh];
//    }
}


@end
