//
//  XNAlbumViewController.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/17.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNAlbumViewController.h"
#import <Photos/Photos.h>
#import "XNPhotoCollectionViewCell.h"

@interface XNAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong) UICollectionView *collectionView;
// 获取相册数组
@property (nonatomic,strong) NSMutableArray *array;
// 选中图片
@property (nonatomic,strong) NSMutableArray *selectArray;

@end

@implementation XNAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectArray = [NSMutableArray array];
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
    
    [self getOriginalImages];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

//- (CGconte)

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNPhotoCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.img = self.array[indexPath.row]                                                                                               ;
    
    cell.tapImg = ^(UIImage *image,BOOL selected){
    
        if (selected) {
            [self.selectArray addObject:image];
        } else {
            [self.selectArray removeObject:image];
        }
        
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.selectArray addObject:self.array[indexPath.row]];
}

/**
 获取相册图片（原图）
 */
- (void)getOriginalImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

/**
 获取相册图片（缩略图）
 */
- (void)getThumbnailImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"图片信息：  %@", result);
            [self.array addObject:result];
        }];
    }
    
    [self.collectionView reloadData];
}

#pragma mark
#pragma mark block
- (void)originalBlock:(selectOriginalImages)block{
    self.originalBlock = block;
}

- (void)thumbnailBlock:(selectThumbnailImages)block{
    self.thumbnailBlock = block;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.originalBlock) {
        self.originalBlock(self.selectArray);
    }
    
    if (self.thumbnailBlock) {
        self.thumbnailBlock(self.selectArray);
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
