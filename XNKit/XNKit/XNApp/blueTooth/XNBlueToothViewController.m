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

@end

@implementation XNBlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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
