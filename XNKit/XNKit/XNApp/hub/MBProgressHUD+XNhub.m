//
//  MBProgressHUD+XNhub.m
//  XNKit
//
//  Created by 小鸟 on 2017/3/8.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import "MBProgressHUD+XNhub.h"
#import "AppDelegate.h"


@implementation MBProgressHUD (XNhub)



+ (void)addTextTip:(NSString *)text{

    UIView *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = NSLocalizedString(@"Done", @"HUD done title");
    
    hud.label.text = text;
    
    [hud hideAnimated:YES afterDelay:3.f];

}

@end
