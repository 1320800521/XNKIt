
//
//  ViewController.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/28.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "ViewController.h"
#import "XNBlueToothViewController.h"
#import "XNPlayerViewController.h"
#import "XNNetWork.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong)   XNNetWork *netWork;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.array = [NSArray arrayWithObjects:@"视频启动图", @"视频播放器",@"蓝牙",nil];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 60;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    
   self.netWork = [[XNNetWork alloc]init];
    
    [XNNetWork updateBaseUrl:@"https://api.rongyiju.com"];
    
    NSDictionary *dict =  [NSDictionary dictionaryWithObjectsAndKeys:@"RYJ-MOBILE-IOS",@"appId",@"32c3704dc4e74bde85a8fb462d5e1bc2",@"appKey",@"2.2.0",@"appVersion",@"1601061200",@"build",@"AppStore",@"channel",@"CBFE3302-DAB3-4D8B-8629-DB959245A064",@"deviceId",@"x86_64",@"deviceName",@"ios",@"os",@"e10adc3949ba59abbe56e057f20f883e",@"password",@"com.rongyiju.platform",@"productId",@"1.0",@"version", nil];
    
    [XNNetWork configerPublicParam:dict];
//    [XNNetWork configCommonHttpHeaders:dict];
    
//    [XNNetWork absoluteUrlWithPath:<#(NSString *)#>];

    [self test];
}

- (void)test{
    
    
//    NSDictionary *dict = {
//        appId = "RYJ-MOBILE-IOS";
//        appKey = 32c3704dc4e74bde85a8fb462d5e1bc2;
//        appVersion = "2.2.0";
//        build = 1601061200;
//        channel = AppStore;
//        deviceId = "CBFE3302-DAB3-4D8B-8629-DB959245A064";
//        deviceName = "x86_64";
//        mobile = 18900129097;
//        os = ios;
//        password = e10adc3949ba59abbe56e057f20f883e;
//        productId = "com.rongyiju.platform";
//        version = "1.0";
//    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"18900129097",@"mobile", nil];
    
    
    [XNNetWork postReqeustWithURL:@"/api/member/login" params:dict successBlock:^(id json) {
        
        NSLog(@"%@  %@",json,json[@"msg"]);
        
        
        
    } failureBlock:^(NSError *error) {
        
    } progress:^(int64_t bytessRead, int64_t totalBytesRead, int64_t totalBytesToRead) {
        
    } refreshCache:YES showHUD:NO];

}

- (void)test1{
    
//     DTLog(@"[GDHNetworkObject baseCache] ========%@===========",[XNNetWork baseCach]);
     NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/xntest.zip"]];//
    [XNNetWork downloadWithUrl:@"https://codeload.github.com/gdhGaoFei/GDHNetwork/zip/master" savePath:path showHub:YES progress:^(int64_t bytessRead, int64_t totalBytesRead, int64_t totalBytesToRead) {
        
        NSLog(@" ------------   %lld",totalBytesRead);
    } success:^(id returnData) {
        
    } fail:^(NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            XNBlueToothViewController *blueToothVC = [[XNBlueToothViewController alloc]init];
            [self.navigationController pushViewController:blueToothVC animated:YES];
            
        }
            break;
        case 1:
        {
            XNPlayerViewController *blueToothVC = [[XNPlayerViewController alloc]init];
            [self.navigationController pushViewController:blueToothVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
