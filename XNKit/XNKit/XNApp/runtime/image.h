//
//  image.h
//  XNKit
//
//  Created by 小鸟 on 2017/2/13.
//  Copyright © 2017年 小鸟. All rights reserved.
//

/*
 
 运行时
 
 
 替换 imageNameed 在加载图片的时候提示图片是肉加载成功
 
 
 */

#import <UIKit/UIKit.h>

@interface image : UIImage

+ (UIImage *)tip_imageNamed:(NSString *)name;

@end
