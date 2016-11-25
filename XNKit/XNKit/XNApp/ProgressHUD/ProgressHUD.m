//
//  ProgressHUD.m
//  ZhangcaiLicaishi
//
//  Created by HThetang on 15/3/19.
//  Copyright (c) 2015年 hetang. All rights reserved.
//

#import "ProgressHUD.h"
#import "MBProgressHUD.h"

@interface ProgressHUD ()


//带图标的，成功或失败的，自动隐藏的HUD
+ (void)showAutoHideHUD:(UIView *)inView title:(NSString *)title imageName:(NSString *)name duration:(CGFloat)duration;

@end

@implementation ProgressHUD

static MBProgressHUD *HUD;

static UIImageView *imageView;

+ (ProgressHUD *) sharedInstance
{
    static ProgressHUD *sharedHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^ {
        sharedHUD = [[self alloc] init];
        imageView = [[UIImageView alloc]init];
    });
    return sharedHUD;
}

- (id)init
{
    self = [super init];
    if (self) {
        // do something
        imageView = [[UIImageView alloc]init];
    }
    return self;
}

+ (void)startAnimation
{
//    CGAffineTransform endAngle = CGAffineTransformMakeRotation(imageview Angle * (M_PI / 180.0f));
//    
//    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        imageView.transform = endAngle;
//    } completion:^(BOOL finished) {
//        angle += 10;
//    [self startAnimation];
//    }];
    
    imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"refresh"];
    HUD.customView = imageView;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



//等待HUD
+ (void)showLoadingHUD:(UIView *)inView title:(NSString *)title
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
//    [inView addSubview:imageView];
    [self startAnimation];
    
    if (title && title.length > 0) {
        
        HUD.labelText = title;
    }
}

//只显示提示信息的HUD，自动消失
+ (void)showTipsHUD:(UIView *)inView title:(NSString *)title duration:(CGFloat)duration
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = title;
    //HUD.margin = 18.f;
    HUD.cornerRadius = 3.0;
    //HUD.alpha = 0.8;
    //HUD.dimBackground = YES;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:duration];
}

//带图标的，成功或失败的，自动隐藏的HUD
+ (void)showAutoHideHUD:(UIView *)inView title:(NSString *)title imageName:(NSString *)name duration:(CGFloat)duration
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = title;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:duration];
}

//成功HUD
+ (void)showSuccessHUD:(UIView *)inView title:(NSString *)title duration:(CGFloat)duration
{
    [self showAutoHideHUD:inView title:title imageName:@"hud_right.png" duration:duration];
}

//失败HUD
+ (void)showErrorHUD:(UIView *)inView title:(NSString *)title duration:(CGFloat)duration
{
    [self showAutoHideHUD:inView title:title imageName:@"hud_error.png" duration:duration];
}

//隐藏HUD
+ (void)hideHUD
{
    [HUD hide:YES];
    [HUD removeFromSuperViewOnHide];
    HUD = nil;
}

@end
