//
//  XNTouchButton.h
//  XNKit
//
//  Created by 小鸟 on 2016/11/24.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNTouchButtonDelegate <NSObject>
/**
 * 开始触摸
 */
- (void)touchesBeganWithPoint:(CGPoint)point;

/**
 * 结束触摸
 */
- (void)touchesEndWithPoint:(CGPoint)point;

/**
 * 移动手指
 */
- (void)touchesMoveWithPoint:(CGPoint)point;

/**
 *  单击时/双击时,判断tap的numberOfTapsRequired
 */
- (void)userTapGestureAction:(UITapGestureRecognizer*)xjTap;

@end

@interface XNTouchButton : UIButton

/**
 * 传递点击事件的代理
 */
@property (weak, nonatomic) id <XNTouchButtonDelegate> touchDelegate;

@end
