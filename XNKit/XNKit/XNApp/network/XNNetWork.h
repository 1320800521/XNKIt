//
//  XNNetWork.h
//  XNKit
//
//  Created by 小鸟 on 2016/12/1.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>


/**
 请求跟地址

 - XNBaseUrlTest: 开发环境
 - XNBaseUrlOnline: 生产环境地址
 */
typedef NS_ENUM(NSInteger,XNBaseUrlType) {
    XNBaseUrlTest = 1,
    XNBaseUrlOnline = 2
};

/**
 网络请求类型 枚举

 - XNTypeGet: Get请求
 - XNTypePost: post请求
 */
typedef NS_ENUM(NSInteger,XNNetworkType) {
    XNTypeGet = 1,
    XNTypePost
};

/**
 请求响应类型

 - XNResponseTypeJSON: json     格式数据
 - XNResponseTypeXML: xml       格式
 - XNResponseTypeData: data     类型
 */
typedef NS_ENUM(NSInteger,XNResponseType) {
    XNResponseTypeJSON = 1,  // 默认类型
    XNResponseTypeXML = 2,
    XNResponseTypeData = 3
};


/**
 请求数据参数类型

 - XNRequestTypeJSON: 参数以json格式发送
 - XNRequestTypeText: 参数以直接拼接格式发送
 */
typedef NS_ENUM(NSUInteger,XNRequestType) {
    XNRequestTypeJSON = 1, // 默认
    XNRequestTypeText  = 2 // 普通text/html
};


/**
 获取网络状态

 - XNNetworkStatusUnknown: 位置网络
 - XNNetworkStatusNotReachable: 无网络
 - XNNetworkStatusReachableViaWWAN: 数据流量 2G、3G、4G.....
 - XNNetworkStatusReachableViaWiFi: WiFi
 */
typedef NS_ENUM(NSInteger, XNNetworkStatus) {
    XNNetworkStatusUnknown          = -1,
    XNNetworkStatusNotReachable     = 0,
    XNNetworkStatusReachableViaWWAN = 1,
    XNNetworkStatusReachableViaWiFi = 2
};


/**
 网络监测

 @param status 当前网络状态
 */
typedef void (^XNNetworkStatusBlock) (XNNetworkStatus status);

/**
 网络状态block

 @param status 网络状态
 */
typedef void(^NXNetStatus)(XNNetworkStatus status);

/**
 下载进度

 @param bytessRead          已下载文件大小
 @param totalBytesRead      总文件大小
 @param totalBytesToRead    剩余大小
 */
typedef void(^XNDownLoadProgress)(int64_t bytessRead,int64_t totalBytesRead,int64_t totalBytesToRead);

// get方式下载
typedef XNDownLoadProgress XNGetProgress;
// post 方式下载
typedef XNDownLoadProgress XNPostProgress;


/**
 上传进度

 @param upLoadedBytes       已上传大小
 @param totolBytes          总的大小
 */
typedef void(^XNUpLoacProgress)(int64_t upLoadedBytes,int64_t totolBytes);

/** 
    创建一个任务,ios9以后，苹果要求使用https，不在支持http请求，也建议用session来替代connect
 */
typedef NSURLSessionTask XNSessionTask;
/**
 请求成功

 @param returnData 返回值
 */
typedef void(^XNSuccess)(id returnData);

/**
 请求失败

 @param error 返回错误原因
 */
typedef void(^XNFail)(NSError *error);




@interface XNNetWork : NSObject

///**
// 加载菊花
// */
//@property (nonatomic,strong) MBProgressHUD *hub;

/**
 网络是否可用
 */
@property (nonatomic,assign) BOOL netWorkAble;

/**
  网络请求类单利

 @return 初始化
 */
+ (XNNetWork *)shareInstance;


/**
 创建网络请求

 @param type 请求类型  post、get...
 @param url 请求地址URL
 @param params 参数
 @param refreshCache 是否获取缓存。无网络或者获取数据失败则获取本地缓存数据
 @param showHub 是否显示 加载菊花
 @param progress 加载进度
 @param successBlock 请求成功回调
 @param failBlock 失败回调
 @return 一个task对象
 */
+ (XNSessionTask *)initWithType:(XNNetworkType)type
                            url:(NSString *)url
                         params:(NSDictionary *)params
                   refreshCache:(BOOL)refreshCache
                        showHub:(BOOL)showHub
                       progress:(XNDownLoadProgress)progress
                   successblock:(XNSuccess)successBlock
                   failureBlcok:(XNFail)failBlock;


/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 默认路径是(GDHNetworkCaches)
 格式是:@"Documents/GDHNetworkCaches",只需要字符串即可。
 
 @param baseCache 默认路径是(GDHNetworkCaches)
 */
+ (void)updateBaseCacheDocuments:(NSString *)baseCache;

/**
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *
 *	清除缓存
 */
- (BOOL)clearCaches;

/*!
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *  更新 根url
 *  用于指定网络请求接口的基础url，如：
 *  http://www.google.com
 *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
 *  于多个服务器，可以调用更新
 *
 @param baseUrl 新的url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;

/**
 配置跟rl

 @param type 环境类型
 */
+ (void)configerBaseUrl:(XNBaseUrlType)type;

/**
 设置公共参数
 
 @param param 公共参数
 @return 公共参数
 */
+ (NSDictionary *)configerPublicParam:(NSDictionary *)param;

/**!
 项目中默认的网络缓存路径,也可以当做项目中的缓存路线,根据需求自行设置
 
 @return 格式是:@"Documents/GDHNetworkCaches"
 */
+ (NSString *)baseCache;

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
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;


/**
 处理url的
 
 @param path 除跟地址外的现象对地址
 @return 拼接完成的地址
 */
+ (NSString *)absoluteUrlWithPath:(NSString *)path;

/**
 监听网络状态的变化
 
 @param statusBlock 返回网络枚举类型:GDHNetworkStatus
 */
+ (void)StartMonitoringNetworkStatus:(XNNetworkStatusBlock)statusBlock;

/**
 *
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的HYBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *
 *	取消所有请求
 */
+ (void)cancelAllRequest;

//获取所有的请求
/**
 获取所有网络请求

 @return 网络请求数组
 */
+ (NSMutableArray *)allTasks;

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
                 showHUD:(BOOL)showHUD;

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
                   showHUD:(BOOL)showHUD;


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
                          fail:(XNFail)xn_failBlock;

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
                   fail:(XNFail)xn_Fail;


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
                     fail:(XNFail)xn_fail;


@end
