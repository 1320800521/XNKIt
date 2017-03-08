//
//  XNTreeViewController.m
//  XNKit
//
//  Created by 小鸟 on 2017/1/9.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import "XNTreeViewController.h"

@interface XNTreeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) UITableView *treeTableViewe;

@end

@implementation XNTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:@"node" ofType:@"plist"];
//    self.array = [[NSArray alloc] initWithContentsOfFile:nodePath];
    self.array = [NSArray arrayWithContentsOfFile:nodePath];
    
    self.treeTableViewe = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.treeTableViewe registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.treeTableViewe.backgroundColor = [UIColor clearColor];
    self.treeTableViewe.delegate = self;
    self.treeTableViewe.dataSource = self;
    [self.view addSubview:self.treeTableViewe];
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.array[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.array[indexPath.row][@"node"] count] > 0) {
        
        NSArray *arr = @[tableView.indexPathForSelectedRow];
        
        [self.treeTableViewe insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationRight];
    }
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
