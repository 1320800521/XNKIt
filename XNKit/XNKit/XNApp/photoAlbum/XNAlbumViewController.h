//
//  XNAlbumViewController.h
//  XNKit
//
//  Created by 小鸟 on 2016/11/17.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNViewController.h"

/**
 获取相册图片（原图）

 @param array 选择的图片
 */
typedef void(^selectOriginalImages)(NSArray *array);

/**
 获取相册图片 （缩略图）

 @param array 选择的图片
 */
typedef void(^selectThumbnailImages)(NSArray *array);

@interface XNAlbumViewController : XNViewController

/**
 选择 原图
 */
@property (nonatomic,copy)selectOriginalImages originalBlock;

/**
 选择缩略图
 */
@property (nonatomic,copy)selectThumbnailImages thumbnailBlock;

- (void)originalBlock:(selectOriginalImages)block;

- (void)thumbnailBlock:(selectThumbnailImages)block;

@end
