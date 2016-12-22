//
//  XNNetWork.m
//  XNKit
//
//  Created by 小鸟 on 2016/12/1.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNNetWork.h"

@interface XNNetWork ()<MBProgressHUDDelegate>
/**
 加载菊花
 */
@property (nonatomic,strong) MBProgressHUD *hub;

@end
/**
    根URL
 */
static NSString *XN_BaseUrl = nil;
/**
    请求头
 */
static NSDictionary *XN_HttpHeader = nil;
/**
    公共参数
 */
static NSDictionary *XN_PublicParam = nil;
/**
    请求任务数组
 */
static NSMutableArray *XN_TaskArray = nil;
/**
    默认缓存路径
 */
static NSString *XN_NetWorkCaches = @"XNNetWorkCaches";
/**
    是否根URL发生变化
 */
static BOOL XN_BaseUrlChanged = YES;
/**
    不对URL进行编码
 */
//static BOOL XN_Encode = NO;
/**
    取消请求时操作
 */
static BOOL XN_CancelRequestShould = YES;
/**
    是否缓存数据
 */
//static BOOL XN_Cache = YES;
/**
    默认打印日志
 */
static BOOL XN_Debug = YES;
/**
    设置请求时间为60秒
 */
static NSTimeInterval XN_Time = 60.0f;
/**
    默认状态为WiFi
 */
static XNNetworkStatus XN_NetWorkStatus = XNNetworkStatusReachableViaWiFi;

/**
    请求数据类型
 */
static XNRequestType XN_RequestType = XNRequestTypeText;
/**
    默认返回JSON 数据
 */
static XNResponseType XN_ResponseType = XNResponseTypeJSON;
/**
    请求管理
 */
static AFHTTPSessionManager *XN_HttpManager = nil;





@implementation XNNetWork


+ (XNNetWork *)shareInstance{
    static XNNetWork *XN_netWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XN_netWork = [[XNNetWork alloc]init];
    });
    return XN_netWork;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.netWorkAble = NO;
//        cachePath();
    }
    return self;
}

+ (NSString *)hybnetworking_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

/*!
 *
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSO，
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(XNRequestType)requestType
             responseType:(XNResponseType)responseType
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest{
    XN_RequestType = requestType;
    XN_ResponseType = responseType;
    XN_CancelRequestShould = shouldCallbackOnCancelRequest;
}

/*!
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders{
    XN_HttpHeader = httpHeaders;
}

//获取默认缓存位置
static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",XN_NetWorkCaches]];
}

/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 
 @return 格式是:@"Documents/GDHNetworkCaches"
 */
+ (NSString *)baseCache {
    return [NSString stringWithFormat:@"Documents/%@",XN_NetWorkCaches];
}

/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 默认路径是(GDHNetworkCaches)
 格式是:@"Documents/GDHNetworkCaches",只需要字符串即可。
 
 @param baseCache 默认路径是(GDHNetworkCaches)
 */
+ (void)updateBaseCacheDocuments:(NSString *)baseCache {
    if (baseCache != nil && baseCache.length > 0) {
        XN_NetWorkCaches = baseCache;
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath() isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath()
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
    }
}



/**
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize{
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

/**
 *
 *	清除缓存
 */
- (BOOL)clearCaches{
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"GDHNetworking clear caches error: %@", error);
            return NO;
        } else {
            NSLog(@"GDHNetworking clear caches ok");
            return YES;
        }
    }else{
        return NO;
    }
}


/**
 *  更新 根url
 *  用于指定网络请求接口的基础url，如：
 *  http://www.google.com
 *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
 *  于多个服务器，可以调用更新
 *
 @param baseUrl 新的url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl{
    if ([baseUrl length] > 7 && ![baseUrl isEqualToString:XN_BaseUrl]) {
        XN_BaseUrlChanged = YES;
    }else{
        XN_BaseUrlChanged = NO;
    }
    
    if (!XN_BaseUrl) {
        XN_BaseUrl = [NSString string];
    }
    XN_BaseUrl = baseUrl;
}

+ (void)configerBaseUrl:(XNBaseUrlType)type{

}

/**
 设置公共参数

 @param param 公共参数
 @return 公共参数
 */
+ (NSDictionary *)configerPublicParam:(NSDictionary *)param{
    
    if (!XN_PublicParam && param) {
        XN_PublicParam = [NSDictionary dictionaryWithDictionary:param];
    }
    return param;
}

#pragma mark 请求前提示
/**
    请求开始提示
 @param xn_url 请求地址
 @param xn_params 请求参数
 @param xn_showHub 加载动画
 @param xn_failBlock 失败回调
 */
+ (void)tipurl:(NSString *)xn_url
         params:(NSDictionary *)xn_params
        showHub:(BOOL)xn_showHub
   failureBlcok:(XNFail)xn_failBlock{
    
    if (xn_showHub) {
//        if (![XNNetWork shareInstance].hub) {
            [XNNetWork shareInstance].hub = [ MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        }
        [[[XNNetWork shareInstance] hub] showAnimated:YES];
    }
    // 处理拼接url
    NSString *absolute = [self absoluteUrlWithPath:xn_url];
    
    if (XN_BaseUrl == nil) {
        if ([NSURL URLWithString:xn_url] == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            SHOW_ALERT(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (xn_showHub) {
//                [[XNNetWork shareInstance].hub hide:YES afterDelay:3];
                [[XNNetWork shareInstance].hub hideAnimated:YES];
            }
            xn_failBlock(nil);
        }
    } else {
        NSURL *absoluteURL = [NSURL URLWithString:absolute];
        
        if (absoluteURL == nil) {
            DTLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            SHOW_ALERT(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            if (xn_showHub) {
                [[XNNetWork shareInstance].hub hideAnimated:YES];
            }
            xn_failBlock(nil);
        }
    }

}


/**
 创建网络请求
 
 @param xn_type 请求类型  post、get...
 @param xn_url 请求地址URL
 @param xn_params 参数
 @param xn_refreshCache 是否获取缓存。无网络或者获取数据失败则获取本地缓存数据
 @param xn_showHub 是否显示 加载菊花
 @param xn_progress 加载进度
 @param xn_successBlock 请求成功回调
 @param xn_failBlock 失败回调
 @return 一个task对象
 */
+ (XNSessionTask *)initWithType:(XNNetworkType)xn_type
                            url:(NSString *)xn_url
                         params:(NSDictionary *)xn_params
                   refreshCache:(BOOL)xn_refreshCache
                        showHub:(BOOL)xn_showHub
                       progress:(XNDownLoadProgress)xn_progress
                   successblock:(XNSuccess)xn_successBlock
                   failureBlcok:(XNFail)xn_failBlock{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:xn_params];
    [dict addEntriesFromDictionary:XN_PublicParam];
    
    xn_params = (NSDictionary *)dict;
    
    
    [self tipurl:xn_url params:xn_params showHub:xn_showHub failureBlcok:xn_failBlock];
    
    AFHTTPSessionManager *manager = [self manager];
    // 处理拼接url
    NSString *absolute = [self absoluteUrlWithPath:xn_url];
    
    // 创建一个session
    XNSessionTask *session = nil;
    if (XN_NetWorkStatus == XNNetworkStatusNotReachable || XN_NetWorkStatus == XNNetworkStatusUnknown) {
        // 无网络情况下读取缓存数据
        
        if (xn_refreshCache) {
            // 读取缓存
            id response = [self  cahceResponseWithURL:absolute parameters:xn_params];
            if (response) {
                if (xn_successBlock) {
                    [self tryToParseData:response];
                }
                
                if (XN_Debug) {
                    DTLog(@"\nRequest success, URL: %@\n \n response:%@\n\n",
                          [self generateGETAbsoluteURL:absolute params:xn_params],
            
                          [self tryToParseData:response]);
                }
                
                if (xn_showHub) {
                    [[XNNetWork shareInstance].hub hideAnimated:YES afterDelay:3];
                }
                xn_successBlock(response);
                
                return nil;
            }else{
                if (xn_showHub) {
                     [[XNNetWork shareInstance].hub hideAnimated:YES afterDelay:3];
                }
                SHOW_ALERT(@"网络连接断开,请检查网络!");
                xn_failBlock(nil);
                return nil;
            }
            
            
        }
        
    } else {
        // 有网络时，直接网络请求
        
        if (xn_type == XNTypeGet) {
            //  不读去缓存  Get 请求
            session = [manager GET:absolute parameters:xn_params progress:^(NSProgress * _Nonnull downloadProgress) {
                if (xn_progress) {
                    xn_progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount,downloadProgress.totalUnitCount-downloadProgress.completedUnitCount);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(xn_successBlock){
//                    [self tryToParseData:responseObject];
                    
                    xn_successBlock([self tryToParseData:responseObject]);
                }
                
                if (xn_refreshCache) {
                    // 缓存数据
                    [self cacheResponseObject:responseObject request:absolute parameters:xn_params];
                }
                
                // 删除任务
                [XN_TaskArray removeObject:task];
                
                if (XN_Debug) {
                    DTLog(@"\nRequest success, URL: %@\n \n response:%@\n\n",
                          [self generateGETAbsoluteURL:absolute params:xn_params],
                          
                          [self tryToParseData:responseObject]);
                }
                if (xn_showHub) {
                    [[XNNetWork shareInstance].hub hideAnimated:YES afterDelay:3];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [XN_TaskArray removeObject:task];
                if (xn_failBlock) {
                    SHOW_ALERT(@"网络连接断开,请检查网络!");
                    
                    DTLog(@"\n");
                    if ([error code] == NSURLErrorCancelled) {
                        DTLog(@"\nRequest was canceled mannully, URL: %@ %@\n\n",
                              [self generateGETAbsoluteURL:absolute params:xn_params],
                              xn_params);
                    } else {
                        DTLog(@"\nRequest error, URL: %@ \n errorInfos:%@\n\n",
                              [self generateGETAbsoluteURL:absolute params:xn_params],
                              [error localizedDescription]);
                    }
                }
                
            }];
        }else if (xn_type == XNTypePost){
            session = [manager POST:absolute parameters:xn_params progress:^(NSProgress * _Nonnull downProgress) {
                if (xn_progress) {
                    xn_progress(downProgress.completedUnitCount, downProgress.totalUnitCount,downProgress.totalUnitCount-downProgress.completedUnitCount);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (xn_successBlock) {
//                    [self tryToParseData:responseObject];
                    xn_successBlock([self tryToParseData:responseObject]);
                }
                
                if (xn_refreshCache) {
                    // 缓存数据
                    [self cacheResponseObject:responseObject request:absolute parameters:xn_params];
                }
                
                // 删除任务
                [XN_TaskArray removeObject:task];
                
                if (XN_Debug) {
                    DTLog(@"\nRequest success, URL: %@\n \n response:%@\n\n",
                          [self generateGETAbsoluteURL:absolute params:xn_params],
                          
                          [self tryToParseData:responseObject]);
                }
                if (xn_showHub) {
                    [[XNNetWork shareInstance].hub hideAnimated:YES afterDelay:3];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                // 删除任务
                [XN_TaskArray removeObject:task];
                
                SHOW_ALERT(@"网络连接断开,请检查网络!");
                
                if (xn_failBlock) {
                    SHOW_ALERT(@"网络连接断开,请检查网络!");
                    
                    DTLog(@"\n");
                    if ([error code] == NSURLErrorCancelled) {
                        DTLog(@"\nRequest was canceled mannully, URL: %@ %@\n\n",
                              [self generateGETAbsoluteURL:absolute params:xn_params],
                              xn_params);
                    } else {
                        DTLog(@"\nRequest error, URL: %@ \n errorInfos:%@\n\n",
                              [self generateGETAbsoluteURL:absolute params:xn_params],
                              [error localizedDescription]);
                    }
                }
            }];
        }
    }
    
    return session;
}


/**
 取消请求

 @param url 取消请求的url
 @return 返回本地缓存读取的数据
 */
+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        // Try to get datas from disk
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [self hybnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            DTLog(@"从缓存读取数据: %@\n", url);
        }
    }
    
    return cacheData;
}

/**-----解析数据*/

/**
 仅对一级字典结构起作用

 @param url 路径地址
 @param params 请求参数
 @return 将地址和参数拼接后的新地址
 */
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || ((NSDictionary *)params).count == 0) {
        return url;
    }
    // 把参数传话成一个字符串
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}


/**
 处理url的

 @param path 除跟地址外的现象对地址
 @return 拼接完成的地址
 */
+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if (XN_BaseUrl == nil || [XN_BaseUrl length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([XN_BaseUrl hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               XN_BaseUrl, mutablePath];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",XN_BaseUrl, path];
            }
        } else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",XN_BaseUrl, path];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               XN_BaseUrl, path];
            }
        }
    }
    
    return [absoluteUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Private
+ (AFHTTPSessionManager *)manager {
    @synchronized (self) {
        // 只要不切换baseurl，就一直使用同一个session manager
        if (XN_HttpManager == nil || XN_BaseUrlChanged) {
            // 开启转圈圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            AFHTTPSessionManager *manager = nil;;
            if (XN_BaseUrl != nil) {
                manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:XN_BaseUrl]];
            } else {
                manager = [AFHTTPSessionManager manager];
            }
            
            switch (XN_RequestType) {
                case XNRequestTypeJSON: {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case XNRequestTypeText: {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            switch (XN_ResponseType) {
                case XNResponseTypeJSON: {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case XNResponseTypeXML: {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case XNResponseTypeData: {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            for (NSString *key in XN_HttpHeader.allKeys) {
                if (XN_HttpHeader[key] != nil) {
                    [manager.requestSerializer setValue:XN_HttpHeader[key] forHTTPHeaderField:key];
                }
            }
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            
            manager.requestSerializer.timeoutInterval = XN_Time;
            
            // 设置允许同时最大并发数量，过大容易出问题
            manager.operationQueue.maxConcurrentOperationCount = 3;
            XN_HttpManager = manager;
        }
    }
    
    return XN_HttpManager;
}

/**
 请求成功回调

 @param responseObject 请求成功返回数据
 @param showHub 加载界面
 @param absolute 请求地址
 @param parmas 参数
 */
+ (void)successBlock:(id)responseObject shouHub:(BOOL)showHub absolute:(NSString *)absolute parmas:(NSDictionary *)parmas{
   
    [self tryToParseData:responseObject];
    
    if (showHub) {
        [[XNNetWork shareInstance].hub hideAnimated:YES afterDelay:3];
    }
    
    if (XN_Debug) {
        DTLog(@"\nRequest success, URL: %@\n \n response:%@\n\n",
              [self generateGETAbsoluteURL:absolute params:parmas],
              
              [self tryToParseData:responseObject]);
    }

}

/**
 请求失败回调

 @param error 错误信息
 @param absolute 请求地址
 @param xn_parmas 参数
 */
+ (void)failBlockWithError:(NSError *)error absolute:(NSString *)absolute parmas:(NSDictionary *)xn_parmas{
    SHOW_ALERT(@"网络连接断开,请检查网络!");
    
    DTLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        DTLog(@"\nRequest was canceled mannully, URL: %@ %@\n\n",
              [self generateGETAbsoluteURL:absolute params:xn_parmas],
              xn_parmas);
    } else {
        DTLog(@"\nRequest error, URL: %@ \n errorInfos:%@\n\n",
              [self generateGETAbsoluteURL:absolute params:xn_parmas],
              [error localizedDescription]);
    }
}

#pragma mark 数据解析
+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}


/**
 缓存网络请求数据

 @param responseObject 返回数据
 @param request 参宿
 */
+ (void)cacheResponseObject:(id)responseObject request:(NSString *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                DTLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request params:params];
        NSString *key = [self hybnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                DTLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                DTLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

//获取所有的请求
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (XN_TaskArray == nil) {
            XN_TaskArray = [[NSMutableArray alloc] init];
        }
    });
    
    return XN_TaskArray;
}
/**
 *
 *	取消所有请求
 */
+ (void)cancelAllRequest{
    @synchronized(self) {
        [XN_TaskArray enumerateObjectsUsingBlock:^(XNSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[XNSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}
/**
 *
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的HYBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url{
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [XN_TaskArray enumerateObjectsUsingBlock:^(XNSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[XNSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

/**
 监听网络状态的变化
 
 @param statusBlock 返回网络枚举类型:GDHNetworkStatus
 */
+ (void)StartMonitoringNetworkStatus:(XNNetworkStatusBlock)statusBlock {
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath() isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath()
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){//网络无连接
            XN_NetWorkStatus = XNNetworkStatusNotReachable;
            [XNNetWork shareInstance].netWorkAble = YES;
            //            DTLog(@"网络无连接");
            //SHOW_ALERT(@"网络连接断开,请检查网络!");
            if (statusBlock) {
                statusBlock (XN_NetWorkStatus);
            }
        } else if (status == AFNetworkReachabilityStatusUnknown){//未知网络
            XN_NetWorkStatus = XNNetworkStatusUnknown;
            [XNNetWork shareInstance].netWorkAble = NO;
            //            DTLog(@"未知网络");
            if (statusBlock) {
                statusBlock (XNNetworkStatusUnknown);
            }
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){//2，3，4G网络
            XN_NetWorkStatus = XNNetworkStatusReachableViaWWAN;
            [XNNetWork shareInstance].netWorkAble = NO;
            //            DTLog(@"2，3，4G网络");
            if (statusBlock) {
                statusBlock (XNNetworkStatusReachableViaWWAN);
            }
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){//WIFI网络
            XN_NetWorkStatus = XNNetworkStatusReachableViaWiFi;
            [XNNetWork shareInstance].netWorkAble = NO;
            //            DTLog(@"WIFI网络");
            if (statusBlock) {
                statusBlock (XNNetworkStatusReachableViaWiFi);
            }
        }
    }];
}


/**
 封装Get请求

 @param url 请求url
 @param paramsDict 参数
 @param successBlock 请求成功回调
 @param failureBlock 请求失败回调
 @param progress 请求进度
 @param refreshCache 是否刷新缓存
 @param showHUD 加载界面
 */
+ (void)getRequstWithURL:(NSString *)url
                  params:(NSDictionary *)paramsDict
            successBlock:(XNSuccess)successBlock
            failureBlock:(XNFail)failureBlock
                progress:(XNGetProgress)progress
            refreshCache:(BOOL)refreshCache
                 showHUD:(BOOL)showHUD{
    
    [XNNetWork initWithType:XNTypeGet url:url params:paramsDict refreshCache:refreshCache showHub:showHUD progress:progress successblock:successBlock failureBlcok:failureBlock];
}


/**
 post请求

 @param url 请求url
 @param paramsDict 参数
 @param successBlock 请求成功回调
 @param failureBlock 请求失败回调
 @param progress 请求进度
 @param refreshCache 是否缓存
 @param showHUD 加载动画
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)paramsDict
              successBlock:(XNSuccess)successBlock
              failureBlock:(XNFail)failureBlock
                  progress:(XNPostProgress)progress
              refreshCache:(BOOL)refreshCache
                   showHUD:(BOOL)showHUD{

    [XNNetWork initWithType:XNTypePost url:url params:paramsDict refreshCache:refreshCache showHub:showHUD progress:progress successblock:successBlock failureBlcok:failureBlock];
}


/**
 上传图片

 @param xn_image 需要上传的图片
 @param xn_url 上传地址
 @param xn_fileName 文件名
 @param xn_name 文件描述
 @param xn_type 文件格式（类型）
 @param xn_parmas 参数
 @param xn_showHub 加载界面
 @param xn_progress 上传进度
 @param xn_successBlock 成功回调
 @param xn_failBlock 失败会带哦
 @return 返回结果
 */
+ (XNSessionTask *)uploadImage:(UIImage *)xn_image
                       url:(NSString *)xn_url
                  fileName:(NSString *)xn_fileName
                      name:(NSString *)xn_name
                      type:(NSString *)xn_type
                     parma:(NSDictionary *)xn_parmas
                   showHub:(BOOL)xn_showHub
                  progress:(XNUpLoacProgress)xn_progress
                   success:(XNSuccess)xn_successBlock
                      fail:(XNFail)xn_failBlock{

    [self tipurl:xn_url params:xn_parmas showHub:xn_showHub failureBlcok:xn_failBlock];

    NSString *absolute = [self absoluteUrlWithPath:xn_url];
    
    AFHTTPSessionManager *manager = [self manager];
    
    XNSessionTask *session = [manager POST:absolute parameters:xn_parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
        NSData *imageData = UIImageJPEGRepresentation(xn_image, 1);
        
        NSString *imageFileName = xn_name;
        if (xn_name == nil || ![xn_name isKindOfClass:[NSString class]] || xn_name.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:xn_name fileName:imageFileName mimeType:xn_type];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (xn_progress) {
            xn_progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
         [XN_TaskArray removeObject:task];
        
        if(xn_successBlock){
            [self tryToParseData:responseObject];
            
            if (xn_showHub) {
                [[XNNetWork shareInstance].hub hideAnimated:YES afterDelay:3];
            }
            
            if (XN_Debug) {
                DTLog(@"\nRequest success, URL: %@\n \n response:%@\n\n",
                      [self generateGETAbsoluteURL:absolute params:xn_parmas],
                      
                      [self tryToParseData:responseObject]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [XN_TaskArray removeObject:task];
            if (xn_failBlock) {
                
            }
    }];
    
    return session;
}


/**
 上传文件

 @param xn_url 上传地址
 @param xn_uploadFile 上传文件名
 @param xn_showHub 加载假面
 @param xn_progress 上传进度
 @param xn_success 上传成功回调
 @param xn_fail 上传失败回调
 */
+ (void)uploadFileWithUrl:(NSString *)xn_url
                          uploadFile:(NSString *)xn_uploadFile
                             showHub:(BOOL)xn_showHub
                            progress:(XNUpLoacProgress)xn_progress
                             success:(XNSuccess)xn_success
                                fail:(XNFail)xn_fail{
    
    NSString *absolute = [self absoluteUrlWithPath:xn_url];
    [self tipurl:absolute params:@{} showHub:xn_showHub failureBlcok:xn_fail];

    AFHTTPSessionManager *manager = [self manager];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:absolute]];

    XNSessionTask *session = nil;
    
    [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (xn_progress) {
            xn_progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [XN_TaskArray removeObject:session];
        
        if (error) {
            [self failBlockWithError:error absolute:absolute parmas:@{}];
        }else{
           // xn_fail(nil);
            
            [self successBlock:nil shouHub:xn_showHub absolute:absolute parmas:@{}];
            
        }
    }];
    
    if(session){
        [XN_TaskArray  addObject:session];
    }
}

/**
 文件下载

 @param xn_url 下载地址
 @param xn_savePath 文件保存路径
 @param xn_showHub 加载界面
 @param xn_Progress 下载进度
 @param xn_success 下载成功回调
 @param xn_Fail 下载失败回调
 */
+ (void)downloadWithUrl:(NSString *)xn_url
               savePath:(NSString *)xn_savePath
                showHub:(BOOL)xn_showHub
               progress:(XNDownLoadProgress)xn_Progress
                success:(XNSuccess)xn_success
                   fail:(XNFail)xn_Fail{

    NSString *absolute = [self absoluteUrlWithPath:xn_url];
    [self tipurl:absolute params:@{} showHub:xn_showHub failureBlcok:xn_Fail];

    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:absolute]];

    AFHTTPSessionManager *manager = [self manager];
    
    XNSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (xn_Progress) {
            xn_Progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount,downloadProgress.totalUnitCount-downloadProgress.completedUnitCount);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
      
        return [NSURL fileURLWithPath:xn_savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [XN_TaskArray removeObject:session];
        
        if (error) {
            
            [self failBlockWithError:error absolute:absolute parmas:@{}];
            
        }else{
            if (xn_success) {
                [self successBlock:nil shouHub:xn_showHub absolute:absolute parmas:@{}];
            }
        }
        
        if (xn_showHub) {
            
            
            [[XNNetWork shareInstance].hub hideAnimated:YES afterDelay:3];
        }
        xn_Fail(nil);
        
    }];
    
    [session resume];
    
    if (session) {
        [XN_TaskArray addObject:session];
    }
    
}


- (MBProgressHUD *)hud {
    if (_hub == nil) {
        //x_hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        _hub.hidden = NO;
        // 隐藏时候从父控件中移除
        _hub.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        //    hud.dimBackground = YES;
        _hub.mode = MBProgressHUDModeIndeterminate;
        _hub.animationType = MBProgressHUDAnimationFade;
        _hub.delegate = self;
    }
    return _hub;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    self.hub = nil;
}



@end
