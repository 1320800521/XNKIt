//
//  XNBlueToothViewController.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/29.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNBlueToothViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface XNBlueToothViewController ()<MCSessionDelegate,MCBrowserViewControllerDelegate>

@property (nonatomic, strong) MCSession *session;

@property (nonatomic, strong) MCBrowserViewController *browsrVC;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation XNBlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // http://blog.csdn.net/songrotek/article/details/46443965 蓝牙
    // http://www.cocoachina.com/ios/20161018/17785.html   网络封装

}

// 发送数据
- (IBAction)sendData:(id)sender {
    UIImage *image = [UIImage imageNamed:@"000.png"];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataUnreliable error:nil];
}

// 搜索附近设备
- (IBAction)find:(id)sender {
    
    MCPeerID *peer = [[MCPeerID alloc]initWithDisplayName:@"小鸟"];
    MCSession *session = [[MCSession alloc]initWithPeer:peer];
    self.session = session;
    session.delegate = self;
    
    MCBrowserViewController *browsrVC = [[MCBrowserViewController alloc]initWithServiceType:@"😄" session:session];
    self.browsrVC = browsrVC;
    browsrVC.delegate = self;
    [self presentViewController:browsrVC animated:YES completion:nil];
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [browserViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    switch (state) {
        case MCSessionStateConnecting:
            NSLog(@"正在建立连接");
            break;
        case MCSessionStateConnected:
            NSLog(@"成功建立连接");
            break;
        case MCSessionStateNotConnected:
            NSLog(@"断开连接");
            break;
        default:
            NSLog(@"异常情况");
            break;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"正在传输图片");
        UIImage *image = [UIImage imageWithData:data];
    
            NSLog(@"%@",[NSThread currentThread]);
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                self.imageView.image = image;
            }];
//        对线程的判断
        if ([NSThread currentThread] != [NSThread mainThread]) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                self.imageView.image = image;
            }];
        }else
        {
            self.imageView.image = image;
        }

}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{

}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{

}

- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
