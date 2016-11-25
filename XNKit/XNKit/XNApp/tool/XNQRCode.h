//
//  XNQRCode.h
//  XNKit
//
//  Created by 小鸟 on 2016/11/10.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XNQRCode : NSObject

/**
  生成带logo的二维码

 @param url logo 信息url
 @param message 二维码信息
 @return 生成的二维码
 */
- (UIImage *)QRLogoUrl:(NSString *)url QRCodeMessage:(NSString *)message;

- (NSString *)scanQRCode;

@end
