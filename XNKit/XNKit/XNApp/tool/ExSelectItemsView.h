//
//  ExSelectItemsView.h
//  RongYiJu
//
//  Created by tvie on 15/5/9.
//  Copyright (c) 2015年 YangXIAOYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExSelectItemsViewDelegate;


@interface ExSelectItemsView : UIView
@property (weak, nonatomic) id<ExSelectItemsViewDelegate>delegate;
- (void)setupWithArr:(NSArray *)arr;
@end

@protocol ExSelectItemsViewDelegate <NSObject>
@optional
- (NSDictionary *)selectItemsInView:(ExSelectItemsView *)view;
- (void)selectItemsAtLine:(NSInteger)line atIndex:(NSInteger)index andSelectInfo:(NSArray *)arr;
- (UIView *)getContainer;
@end
