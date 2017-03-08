

//
//  XNRunTestViewController.m
//  XNKit
//
//  Created by 小鸟 on 2017/2/13.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import "XNRunTestViewController.h"
#import "XNRuntime.h"
#import <objc/runtime.h>
#import <objc/objc-runtime.h>

@interface XNRunTestViewController ()

@property (nonatomic,strong) XNRuntime *runTest;

@end

@implementation XNRunTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.runTest = [[XNRuntime alloc]init];
    
    [self test1];
    
}




/**
 运行时，向类中动态添加新方法
 */
- (void)test1{

    class_addMethod([self.runTest class], @selector(testAddMethod), (IMP)testAddMethod, "");
    
    [self.runTest performSelector:@selector(testAddMethod)];
    
    [self.runTest Logtest];

    
}


void testAddMethod(id self, SEL _cmd){


    NSLog(@"-----------------------添加方法");
    
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
