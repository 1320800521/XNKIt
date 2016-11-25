//
//  ProgressHUD.h
//  ZhangcaiLicaishi
//
//  Created by HThetang on 15/3/19.
//  Copyright (c) 2015年 hetang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ProgressHUD : NSObject

+ (ProgressHUD *)sharedInstance;

//等待HUD
+ (void)showLoadingHUD:(UIView *)inView title:(NSString *)title;
//只显示提示信息的HUD，自动消失
+ (void)showTipsHUD:(UIView *)inView title:(NSString *)title duration:(CGFloat)duration;

//成功HUD
+ (void)showSuccessHUD:(UIView *)inView title:(NSString *)title duration:(CGFloat)duration;
//失败HUD
+ (void)showErrorHUD:(UIView *)inView title:(NSString *)title duration:(CGFloat)duration;
//隐藏HUD
+ (void)hideHUD;

@end
