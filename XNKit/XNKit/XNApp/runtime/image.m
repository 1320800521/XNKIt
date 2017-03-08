

//
//  image.m
//  XNKit
//
//  Created by 小鸟 on 2017/2/13.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import "image.h"
#import <objc/objc-runtime.h>

@implementation image


/**
 只需执行一次的方法，一般放到load中，也可以放到initialize中 ，需要判断调用的类型
 */
+ (void)load{
    
    // 先拿到需要交换的方法
    Method method1 = class_getClassMethod([UIImage class], @selector(imageNamed:));
    
    Method method2 = class_getClassMethod([UIImage class], @selector(tip_imageNamed:));
    
    // 交换方法
    method_exchangeImplementations(method2, method1);
}

// 加载当前类或者子类时候.会调用.可能会调用不止一次
+ (void)initialize{

}

// 新增方法 加载图片时判断图片是否存在
+ (UIImage *)tip_imageNamed:(NSString *)name{
    
    UIImage *image = [self tip_imageNamed:name];
    
    
    if (image == nil) {
        
        NSLog(@"这张照片不存在");
    }
    
    return image;
}

@end
