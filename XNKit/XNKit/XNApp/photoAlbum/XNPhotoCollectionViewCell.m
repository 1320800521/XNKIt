//
//  XNPhotoCollectionViewCell.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/17.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNPhotoCollectionViewCell.h"

@implementation XNPhotoCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photoImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgView:)];
    tap.delegate = self;
    [self.contentView addGestureRecognizer:tap];
    
}

- (void)setImg:(UIImage *)img{
    
//    self.photoImageView.image = [UIImage imageNamed:@"user_added_02"];
    
    self.photoImageView.image = img;
}


- (void)tapImgView:(id)sender {
    
    self.selected = !self.selected;
    
    if (self.selected) {
        self.selectedBtn.image = [UIImage imageNamed:@"user_added_02"];
    }else{
        self.selectedBtn.image = [UIImage imageNamed:@"user_added_01"];
    }
    
    if (self.tapImg) {
        self.tapImg(self.photoImageView.image,self.selected);
    }
}

@end
