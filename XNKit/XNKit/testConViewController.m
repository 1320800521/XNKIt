//
//  testConViewController.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/7.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "testConViewController.h"
#import "XNPhotoCollectionViewCell.h"
#import "XNAlbumViewController.h"

@interface testConViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *array;

@end

@implementation testConViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *barBtm = [[UIBarButtonItem alloc]initWithTitle:@"选照片" style:UIBarButtonItemStylePlain target:self action:@selector(selectPhoto)];
    self.navigationItem.rightBarButtonItem = barBtm;
    
    
    self.array = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"XNPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
}

- (void)selectPhoto{

    XNAlbumViewController *albumVC = [[XNAlbumViewController alloc]init];
    
    albumVC.thumbnailBlock = ^(NSArray *array){
        self.array = array;
        [self.collectionView reloadData];
    };
    
    [self.navigationController pushViewController:albumVC animated:YES];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNPhotoCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.img = self.array[indexPath.row]                                                                                               ;
    
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    

    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    int input = [textField.text intValue];
    
    [self output:input];
}

- (void)output:(int)input{

//    int m ,n,input;
//
//    scanf(" 请输入整数n；\n %d ",&input);
//    
//    while (n--) {
//        printf("#");
//    }
//    
//    m = input / 2;
//    
//    for (int i = 0; i < m; i ++) {
//        printf("\n*");
//        
//        if (i== m - 1) {
//            printf("\n");
//        }
//    }
//    
//    n = input;
//    while (n--) {
//        printf("#");
//    }
//    
//    m = input - m;
//    for (int i = 0; i < m; i ++) {
//         printf("\n#");
//    }
//    
//
    
//    {
//        int m;
//        scanf(" 请输入整数n；\n %d ",&input);
//       m = input;
//        while (m-- >= 0) {
//            printf("#");
//        }
//        m = input / 2;
//        
//        for (int i = 0; i < m; i ++) {
//            printf("\n*");
//            if (i== m - 1) {
//                printf("\n");
//            }
//        }
//        m = input;
//        while (m-- >= 0) {
//            printf("#");
//        }
//        m = input - input / 2;
//        for (int i = 0; i < m; i ++) {
//            printf("\n#");
//        }
//    }
    
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
