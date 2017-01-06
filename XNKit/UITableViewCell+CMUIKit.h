//
//  UITableView+YCUIKit.h
//  yidao_driver
//
//  Created by YongCheHui on 2016/12/15.
//  Copyright © 2016年 yongche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (CMUIKit)
+(NSString*)cellIdentifier;
+(CGFloat)yc_cellHeightWithModel:(id)model;
+(CGFloat)yc_cellSectionHeaderHeightWithSection:(NSInteger)section;
+(CGFloat)yc_cellSectionFooterHeightWithSection:(NSInteger)section;

-(void)yc_setIndexPath:(NSIndexPath*)indexPath;
-(NSIndexPath*)yc_indexPath;
-(void)yc_setModelData:(id)data;
@end
