//
//  flowBtn.h
//  RongYiJu
//
//  Created by 🐷 on 15/10/19.
//  Copyright © 2015年 YangXIAOYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface flowBtn : UIButton

// 标题
@property (nonatomic,strong) UILabel *textTitle;
// 图片
@property (nonatomic,strong) UIImageView *img;

-(id)initWithFrame:(CGRect)frame;

-(void)setselectTitle:(NSString *)title;

-(void)setNomeltitle:(NSString *)title;

@end
