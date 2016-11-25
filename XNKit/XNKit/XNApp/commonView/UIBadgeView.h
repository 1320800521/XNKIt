//
//  UIBadgeView.h
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBadgeView : UIView

/**
  tip message count
 */
@property (nonatomic, copy) NSString *badgeValue;

+ (UIBadgeView *)viewWithBadgeTip:(NSString *)badgeValue;
+ (CGSize)badgeSizeWithStr:(NSString *)badgeValue font:(UIFont *)font;


/**
    

 @param badgeValue badgeValue

 @return text size
 */
- (CGSize)badgeSizeWithStr:(NSString *)badgeValue;

@end
