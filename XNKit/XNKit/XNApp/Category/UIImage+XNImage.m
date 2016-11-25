//
//  UIImage+XNImage.m
//  XNKit
//
//  Created by 小鸟 on 16/11/2.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "UIImage+XNImage.h"
//#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (XNImage)

+ (UIImage *)imageWithColor:(UIColor *)aColor{
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


//对图片尺寸进行压缩--
- (UIImage*)scaledToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;
    
    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self scaledToSize:targetSize];
}

- (UIImage *)scaledToMaxSize:(CGSize)size{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    // 如果不需要缩放
    if (scaleFactor > 1.0) {
        return self;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];//fullScreenImage已经调整过方向了
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    return img;
}

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)imgSize{
    CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillRect(ctx, rect);
    UIImage *_img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _img;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


////加模糊效果，image是图片，blur是模糊度
//- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
//{
//    // Check pre-conditions.
//    if (self.size.width < 1 || self.size.height < 1) {
//        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
//        return nil;
//    }
//    if (!self.CGImage) {
//        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
//        return nil;
//    }
//    if (image && !image.CGImage) {
//        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", image);
//        return nil;
//    }
//    
//    CGRect imageRect = { CGPointZero, self.size };
//    UIImage *effectImage = self;
//    
//    BOOL hasBlur = 10 > __FLT_EPSILON__;
//    BOOL hasSaturationChange = fabs(blur - 1.) > __FLT_EPSILON__;
//    if (hasBlur || hasSaturationChange) {
//        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
//        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
//        CGContextScaleCTM(effectInContext, 1.0, -1.0);
//        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
//        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
//        
//        vImage_Buffer effectInBuffer;
//        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
//        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
//        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
//        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
//        
//        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
//        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
//        vImage_Buffer effectOutBuffer;
//        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
//        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
//        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
//        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
//        
//        if (hasBlur) {
//            // A description of how to compute the box kernel width from the Gaussian
//            // radius (aka standard deviation) appears in the SVG spec:
//            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
//            //
//            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
//            // successive box-blurs build a piece-wise quadratic convolution kernel, which
//            // approximates the Gaussian kernel to within roughly 3%.
//            //
//            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
//            //
//            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
//            //
//            CGFloat inputRadius = 30 * [[UIScreen mainScreen] scale];
//            NSUInteger radius = floor(inputRadius * 3. * sqrt(22 * M_PI) / 4 + 0.5);
//            if (radius % 2 != 1) {
//                radius += 1; // force radius to be odd so that the three box-blur methodology works.
//            }
//            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
//            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
//            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
//        }
//        BOOL effectImageBuffersAreSwapped = NO;
//        if (hasSaturationChange) {
//            CGFloat s = blur;
//            CGFloat floatingPointSaturationMatrix[] = {
//                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
//                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
//                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
//                0,                    0,                    0,  1,
//            };
//            const int32_t divisor = 256;
//            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
//            int16_t saturationMatrix[matrixSize];
//            for (NSUInteger i = 0; i < matrixSize; ++i) {
//                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
//            }
//            if (hasBlur) {
//                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
//                effectImageBuffersAreSwapped = YES;
//            }
//            else {
//                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
//            }
//        }
//        if (!effectImageBuffersAreSwapped)
//            effectImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        if (effectImageBuffersAreSwapped)
//            effectImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    
//    // Set up output context.
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
//    CGContextRef outputContext = UIGraphicsGetCurrentContext();
//    CGContextScaleCTM(outputContext, 1.0, -1.0);
//    CGContextTranslateCTM(outputContext, 0, -self.size.height);
//    
//    // Draw base image.
//    CGContextDrawImage(outputContext, imageRect, self.CGImage);
//    
//    // Draw effect image.
//    if (hasBlur) {
//        CGContextSaveGState(outputContext);
//        if (image) {
//            CGContextClipToMask(outputContext, imageRect, image.CGImage);
//        }
//        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
//        CGContextRestoreGState(outputContext);
//    }
//    
//    // Add in color tint.
//    
//    CGContextSaveGState(outputContext);
//    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1.0 alpha:0.3].CGColor);
//    CGContextFillRect(outputContext, imageRect);
//    CGContextRestoreGState(outputContext);
//    
//    // Output image is ready.
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return outputImage;
//}

+ (UIImage *)imageFromView:(UIView *)orgView{
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromAttributtedText:(NSAttributedString *)aAtt size:(CGSize)size
{
    NSAssert(size.width>0&&size.height>0, @"imageFromAttributtedText 申请的图片size为0");
    size = CGSizeMake(size.width*2, size.height*2);
    UIGraphicsBeginImageContext(size);
    [aAtt drawInRect:CGRectMake((size.width-aAtt.size.width)/2.0f, (size.height-aAtt.size.height)/2.0f, aAtt.size.width, aAtt.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:image.imageOrientation];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
