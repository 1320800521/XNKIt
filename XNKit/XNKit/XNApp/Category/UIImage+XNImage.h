//
//  UIImage+XNImage.h
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIColor+XNColor.h"

@interface UIImage (XNImage)

/**
 根据颜色生成image

 @param aColor 颜色

 @return image
 */
+(UIImage *)imageWithColor:(UIColor *)aColor;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imgSize;
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
+ (UIImage *)imageFromView:(UIView *)aView;
+ (UIImage *)imageFromAttributtedText:(NSAttributedString *)aAtt size:(CGSize)size;


/**
 根据颜色生成指定大小的图片

 @param aColor color
 @param aFrame frame

 @return image  
 */
+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
- (UIImage*)scaledToSize:(CGSize)targetSize;
- (UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
- (UIImage*)scaledToMaxSize:(CGSize )size;
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset;

@end
