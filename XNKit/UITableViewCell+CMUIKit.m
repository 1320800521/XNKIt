//
//  UITableView+YCUIKit.m
//  yidao_driver
//
//  Created by YongCheHui on 2016/12/15.
//  Copyright © 2016年 yongche. All rights reserved.
//

#import "UITableViewCell+CMUIKit.h"
#import <objc/runtime.h>

@implementation UITableViewCell (CMUIKit)
+(NSString*)cellIdentifier
{
    return NSStringFromClass(self.class);
}

-(void)yc_setModelData:(id)data
{
}

static const char * yc_cellIndexPathKey = "ycCellIndexPathKey";

-(void)yc_setIndexPath:(NSIndexPath*)indexPath
{
     objc_setAssociatedObject(self, yc_cellIndexPathKey, indexPath, OBJC_ASSOCIATION_ASSIGN);
}

-(NSIndexPath*)yc_indexPath
{
    return objc_getAssociatedObject(self, yc_cellIndexPathKey);
}

+(CGFloat)yc_cellHeightWithModel:(id)model
{
    return 44.f;
}

+(CGFloat)yc_cellSectionHeaderHeightWithSection:(NSInteger)section
{
    return 28.0;
}

+(CGFloat)yc_cellSectionFooterHeightWithSection:(NSInteger)section
{
    return 0.0f;
}

@end
