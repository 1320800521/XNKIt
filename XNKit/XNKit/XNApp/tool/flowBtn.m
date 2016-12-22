//
//  flowBtn.m
//  RongYiJu
//
//  Created by 🐷 on 15/10/19.
//  Copyright © 2015年 YangXIAOYU. All rights reserved.
//

#import "flowBtn.h"

@implementation flowBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        self.textTitle = [[UILabel alloc]initWithFrame:frame];
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(self.textTitle.frame.size.width + 8, self.titleLabel.frame.origin.y + 5, 15, 8)];
        self.textTitle.font = [UIFont systemFontOfSize:14.0];
        self.img.image = [UIImage imageNamed:@"pull_down_01"];
        self.textTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textTitle];
        [self addSubview:self.img];
    }

    return self;
}

-(void)setselectTitle:(NSString *)title
{
    self.textTitle.text = title;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    CGFloat text_x = (self.frame.size.width - size.width - 23)/2;
    
    self.textTitle.frame = CGRectMake(text_x, self.titleLabel.frame.origin.y, size.width, size.height);
    self.img.frame = CGRectMake(CGRectGetMaxX(self.textTitle.frame)+8, self.img.frame.origin.y, 15, 8);
    if (size.width+31>self.frame.size.width) {
        self.textTitle.frame = CGRectMake(4, self.titleLabel.frame.origin.y, self.frame.size.width-31, size.height);
    }
    self.textTitle.textColor = [UIColor colorWithRed:234.0/255 green:68.0/255 blue:40.0/255 alpha:1.0];
    self.img.image = [UIImage imageNamed:@"pull_down_02"];
}

-(void)setNomeltitle:(NSString *)title
{
    self.textTitle.text = title;
     CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    CGFloat text_x = (self.frame.size.width - size.width - 23)/2;

    self.textTitle.frame = CGRectMake(text_x, self.titleLabel.frame.origin.y, size.width, size.height);
    self.img.frame = CGRectMake(CGRectGetMaxX(self.textTitle.frame)+8, self.img.frame.origin.y, 15, 8);
    if (size.width+31>self.frame.size.width) {
        self.textTitle.frame = CGRectMake(4, self.titleLabel.frame.origin.y, self.frame.size.width-31, size.height);
    }
    self.textTitle.textColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1.0];
    self.img.image = [UIImage imageNamed:@"pull_down_01"];
}

@end
