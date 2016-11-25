//
//  XNPhotoCollectionViewCell.h
//  XNKit
//
//  Created by 小鸟 on 2016/11/17.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNPhotoCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;


@property (weak, nonatomic) IBOutlet UIImageView *selectedBtn;

@property (nonatomic,strong) UIImage *img;

@property (nonatomic,copy) void(^tapImg)(UIImage *image,BOOL selected);

@end
