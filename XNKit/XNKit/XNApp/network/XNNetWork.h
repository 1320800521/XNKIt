//
//  XNNetWork.h
//  XNKit
//
//  Created by 小鸟 on 2016/12/1.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XNNetWork : NSObject

/**
 get请求

 @param urlString 请求url
 @param pram 参数
 @param success 请求成功回调
 @param failure 失败回调
 */
+ (void)getDataWithUrl:(NSString *)urlString pram:(id)pram success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
