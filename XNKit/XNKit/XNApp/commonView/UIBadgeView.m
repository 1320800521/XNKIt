


//
//  UIBadgeView.m
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//


#define kMaxBadgeWith 100.0
#define kBadgeTextOffset 2.0
#define kBadgePading 2.0
#define kBadgeTipStr @"badgeTip"
#define kBadgeTextFont  [UIFont systemFontOfSize:12]
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "UIBadgeView.h"
#import "NSString+XNString.h"
#import "UIColor+XNColor.h"


@interface UIBadgeView ()

/**
 * Color used for badge's background.
 */
@property (strong) UIColor *badgeBackgroundColor;

/**
 * Color used for badge's text.
 */
@property (strong) UIColor *badgeTextColor;

/**
 * Font used for badge's text.
 */
@property (nonatomic) UIFont *badgeTextFont;

@end

@implementation UIBadgeView


+ (UIBadgeView *)viewWithBadgeTip:(NSString *)badgeValue{
    if (!badgeValue || badgeValue.length == 0) {
        return nil;
    }
    UIBadgeView *badgeV = [[UIBadgeView alloc] init];
    badgeV.frame = [badgeV badgeFrameWithStr:badgeValue];
    badgeV.badgeValue = badgeValue;
    
    return badgeV;
}
+ (CGSize)badgeSizeWithStr:(NSString *)badgeValue font:(UIFont *)font{
    if (!badgeValue || badgeValue.length == 0) {
        return CGSizeZero;
    }
    if (!font) {
        font = kBadgeTextFont;
    }
    CGSize badgeSize = [badgeValue getSizeWithFont:font constrainedToSize:CGSizeMake(kMaxBadgeWith, 20)];
    
    if (badgeSize.width < badgeSize.height) {
        badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
    }
    if ([badgeValue isEqualToString:kBadgeTipStr]) {
        badgeSize = CGSizeMake(4, 4);
    }
    return badgeSize;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    // Setup defaults
    [self setBackgroundColor:[UIColor clearColor]];
    _badgeBackgroundColor = UIColorFromRGB(0xf75388);
    _badgeTextColor = [UIColor whiteColor];
    _badgeTextFont = [UIFont systemFontOfSize:12];
}


// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Drawing code
    // Draw badges
    
    if ([[self badgeValue] length]) {
        CGSize badgeSize = [self badgeSizeWithStr:_badgeValue];
        
        
        
        CGRect badgeBackgroundFrame = CGRectMake(kBadgeTextOffset,
                                                 kBadgeTextOffset,
                                                 badgeSize.width + 2 * kBadgePading,
                                                 badgeSize.height + 2 * kBadgePading);
        CGRect badgeBackgroundPaddingFrame = CGRectMake(0, 0, badgeBackgroundFrame.size.width +2*kBadgePading, badgeBackgroundFrame.size.height +2*kBadgePading);
        
        if ([self badgeBackgroundColor]) {
            if (![self.badgeValue isEqualToString:kBadgeTipStr]) {//外白色描边
                CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                
                if (badgeSize.width > badgeSize.height) {
                    CGFloat circleWith = badgeBackgroundPaddingFrame.size.height;
                    CGFloat totalWidth = badgeBackgroundPaddingFrame.size.width;
                    CGFloat diffWidth = totalWidth - circleWith;
                    CGPoint originPoint = badgeBackgroundPaddingFrame.origin;
                    
                    
                    CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWith, circleWith);
                    CGRect centerFrame = CGRectMake(originPoint.x +circleWith/2, originPoint.y, diffWidth, circleWith);
                    CGRect rightCicleFrame = CGRectMake(originPoint.x +(totalWidth - circleWith), originPoint.y, circleWith, circleWith);
                    CGContextFillEllipseInRect(context, leftCicleFrame);
                    CGContextFillRect(context, centerFrame);
                    CGContextFillEllipseInRect(context, rightCicleFrame);
                    
                }else{
                    CGContextFillEllipseInRect(context, badgeBackgroundPaddingFrame);
                }
            }
            //            badge背景色
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
            if (badgeSize.width > badgeSize.height) {
                CGFloat circleWith = badgeBackgroundFrame.size.height;
                CGFloat totalWidth = badgeBackgroundFrame.size.width;
                CGFloat diffWidth = totalWidth - circleWith;
                CGPoint originPoint = badgeBackgroundFrame.origin;
                
                
                CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWith, circleWith);
                CGRect centerFrame = CGRectMake(originPoint.x +circleWith/2, originPoint.y, diffWidth, circleWith);
                CGRect rightCicleFrame = CGRectMake(originPoint.x +(totalWidth - circleWith), originPoint.y, circleWith, circleWith);
                CGContextFillEllipseInRect(context, leftCicleFrame);
                CGContextFillRect(context, centerFrame);
                CGContextFillEllipseInRect(context, rightCicleFrame);
            }else{
                CGContextFillEllipseInRect(context, badgeBackgroundFrame);
            }
        }
        
        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
            [badgeTextStyle setAlignment:NSTextAlignmentCenter];
            
            NSDictionary *badgeTextAttributes = @{
                                                  NSFontAttributeName: [self badgeTextFont],
                                                  NSForegroundColorAttributeName: [self badgeTextColor],
                                                  NSParagraphStyleAttributeName: badgeTextStyle,
                                                  };
            
            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + kBadgeTextOffset,
                                                     CGRectGetMinY(badgeBackgroundFrame) + kBadgeTextOffset,
                                                     badgeSize.width, badgeSize.height)
                           withAttributes:badgeTextAttributes];
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + kBadgeTextOffset,
                                                     CGRectGetMinY(badgeBackgroundFrame) + kBadgeTextOffset,
                                                     badgeSize.width, badgeSize.height)
                                 withFont:[self badgeTextFont]
                            lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentCenter];
#endif
        }
    }
    
    CGContextRestoreGState(context);
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    self.frame = [self badgeFrameWithStr:badgeValue];
    
    [self setNeedsDisplay];
}

- (CGSize)badgeSizeWithStr:(NSString *)badgeValue{
    return [UIBadgeView badgeSizeWithStr:badgeValue font:self.badgeTextFont];
}

- (CGRect)badgeFrameWithStr:(NSString *)badgeValue{
    CGSize badgeSize = [self badgeSizeWithStr:badgeValue];
    CGRect badgeFrame = CGRectMake(0, 0, badgeSize.width +8, badgeSize.height +8);//8=2*2（红圈-文字）+2*2（白圈-红圈）
    return badgeFrame;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
