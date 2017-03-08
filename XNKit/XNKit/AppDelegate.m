//
//  AppDelegate.m
//  XNKit
//
//  Created by 小鸟 on 16/10/31.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "AppDelegate.h"
#import "XNAlbumViewController.h"
#import "testConViewController.h"
#import "XNPlayerViewController.h"
#import "XNVideoLaunchViewController.h"
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "MBProgressHUD+XNHub.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //设置启动图时间
    [NSThread sleepForTimeInterval:1.0];
    
    ViewController *root = [[ViewController alloc] init];
     UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    self.window.rootViewController = nav;
    
    
   
    
    // 推送
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }];
        }else{
        
        
        }
    }];
    
    // 创建应用图标上的#D touch选项
    [self creatShortcutItem];
    
    UIApplicationShortcutItem *shortCutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    
    // 如果从3dTouch标签启动app，则根据不同表示执行不同的炒作。然会NO， (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
    
    if (shortCutItem) {
    // 如果是设置的3d touch快捷选项标签标，根据不同的标示执行不同的操作
        if([shortCutItem.type isEqualToString:@"com.mycompany.myapp.one"]){
//            NSArray *arr = @[@"hello 3D Touch"];
//            UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
           
            [nav pushViewController:[[ViewController alloc]init] animated:YES];
        } else if ([shortCutItem.type isEqualToString:@"com.mycompany.myapp.search"]) {//进入搜索界面
          
        } else if ([shortCutItem.type isEqualToString:@"com.mycompany.myapp.share"]) {//进入分享界面
           
            
        }
        return NO;

    }
    
    [MBProgressHUD addTextTip:@"测试"];
    
    return YES;
}


#pragma mark 3dTouch

//创建应用图标上的3D touch快捷选项
- (void)creatShortcutItem {
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    
    //    //创建自定义图标的icon
    //    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"分享.png"];
    
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.mycompany.myapp.share" localizedTitle:@"分享" localizedSubtitle:@"分享副标题" icon:icon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];
}




//如果app在后台，通过快捷选项标签进入app，则调用该方法，如果app不在后台已杀死，则处理通过快捷选项标签进入app的逻辑在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *mainView = [storyboard instantiateViewControllerWithIdentifier:@"mainController"];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainView];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    
    //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
    if([shortcutItem.type isEqualToString:@"com.mycompany.myapp.one"]){
//        NSArray *arr = @[@"hello 3D Touch"];
//        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
//        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//        }];
    } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.search"]) {//进入搜索界面
//        SearchViewController *childVC = [storyboard instantiateViewControllerWithIdentifier:@"searchController"];
//        [mainNav pushViewController:childVC animated:NO];
    } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.share"]) {//进入分享界面
//        SharedViewController *childVC = [storyboard instantiateViewControllerWithIdentifier:@"sharedController"];
//        [mainNav pushViewController:childVC animated:NO];
    }
    
    if (completionHandler) {
        completionHandler(YES);
    }
}


- (NSSet *)createNotificationCateryActions{

    //定义按钮的交互button action
    UNNotificationAction * likeButton = [UNNotificationAction actionWithIdentifier:@"see1" title:@"I love it~😘" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction * dislikeButton = [UNNotificationAction actionWithIdentifier:@"see2" title:@"I don't care~😳" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //定义文本框的action
    UNTextInputNotificationAction * text = [UNTextInputNotificationAction actionWithIdentifier:@"text" title:@"How about it~?" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //将这些action带入category
    UNNotificationCategory * choseCategory = [UNNotificationCategory categoryWithIdentifier:@"seeCategory" actions:@[likeButton,dislikeButton] intentIdentifiers:@[@"see1",@"see2"] options:UNNotificationCategoryOptionNone];
    UNNotificationCategory * comment = [UNNotificationCategory categoryWithIdentifier:@"seeCategory1" actions:@[text] intentIdentifiers:@[@"text"] options:UNNotificationCategoryOptionNone];
    return [NSSet setWithObjects:choseCategory,comment,nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString  *mydeviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceToken is %@",mydeviceToken);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

#pragma mark 
#pragma mark 通知代理
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    UNNotificationRequest *request = notification.request; // 原始请求
    NSDictionary *userInfo = notification.request.content.userInfo;
    UNNotificationContent *content = request.content;
    NSString *title = content.title;
    NSString *subTitle = content.subtitle;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    UNNotificationSound *sound = content.sound;
    
    if ([notification isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSLog(@"iOS 10 远程通知");
    }else{
        NSLog(@"iOS 10 本地通知");
    }
    
     completionHandler(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert);
}

//用户与通知进行交互后的response，比如说用户直接点开通知打开App、用户点击通知的按钮或者进行输入文本框的文本
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    UNNotificationRequest *request = response.notification.request; // 原始请求
    NSDictionary * userInfo = request.content.userInfo;//userInfo数据
    UNNotificationContent *content = request.content; // 原始内容
    NSString *title = content.title;  // 标题
    NSString *subtitle = content.subtitle;  // 副标题
    NSNumber *badge = content.badge;  // 角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;
    //在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    //可根据actionIdentifier来做业务逻辑
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        UNTextInputNotificationResponse * textResponse = (UNTextInputNotificationResponse*)response;
        NSString * text = textResponse.userText;
        //do something
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"文本框输入" message:text preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    else{
        if ([response.actionIdentifier isEqualToString:@"see1"]) {
            //I love it~😘的处理
        }
        if ([response.actionIdentifier isEqualToString:@"see2"]) {
            //I don't care~😳
            [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[response.notification.request.identifier]];
        }
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"文本框输入" message:response.notification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    completionHandler(); //可根据actionIdentifier来做业务逻辑

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    NSString *prefix = @"";
    
    if ([[url absoluteString]rangeOfString:prefix].location != NSNotFound) {
        NSString *action = [[url absoluteString] substringFromIndex:prefix.length];
        
        if ([action isEqualToString:@"cameLibirary"]) {
            XNPlayerViewController *player = [[XNPlayerViewController alloc]init];
            self.window.rootViewController = player;

        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
