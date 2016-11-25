//
//  XNQRCode.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/10.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNQRCode.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface XNQRCode ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic) AVCaptureDevice *device;

@property (strong,nonatomic) AVCaptureDeviceInput *input;

@property (strong,nonatomic) AVCaptureMetadataOutput *outPut;

@property (strong,nonatomic) AVCaptureSession *session;

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

/*** 专门用于保存描边的图层 ***/
@property (nonatomic,strong) CALayer *containerLayer;

@end

@implementation XNQRCode

- (UIImage *)QRLogoUrl:(NSString *)url QRCodeMessage:(NSString *)message{

    // 创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置为默认属性
    [filter setDefaults];
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrDate = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 为过滤器赋值
    [filter setValue:qrDate forKey:@"inputMessage"];
    // 获取过滤去的输出图片 同时放大图片
    CIImage *outputImage = [[filter outputImage] imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
   
    // 转化为UIImage
    UIImage *image1 = [UIImage imageWithCIImage:outputImage];
    
    //  为二维码添加中间logo
    // 开始绘图
    UIGraphicsBeginImageContext(image1.size);
    // 将二维码绘制到图层上
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];

    // 添加logo
    UIImage *logoImage;
    if (url == nil) {
        logoImage = [UIImage imageNamed:@""];
    } else {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        logoImage = [UIImage imageWithData:imageData];
    }
    
    CGFloat logoImageW = 100;
    CGFloat logoImageH = logoImageW;
    CGFloat logoImageX = (image1.size.width - logoImageW) * 0.5;
    CGFloat logoImageY = (image1.size.height - logoImageH) * 0.5;

    [logoImage drawInRect:CGRectMake(logoImageX, logoImageY, logoImageW, logoImageH)];
    
    // 获取完成的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭输出
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)openCameralCLick{

    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 4.设置代理
    ipc.delegate = self;
    
    // 5.modal出这个控制器
//    [self presentViewController:ipc animated:YES completion:nil];
}


// 开始扫描
- (void)startScan{
    
    // 判断输入能否加到绘画中
    if(![self.session canAddInput:self.input]){
        return;
    }
    
    // 2 判断输出能否添加到绘画中
    if (![self.session canAddOutput:self.outPut]) {
        return;
    }
    
    // 设置解析类型 (需要在输出对象添加到回话之后设置)
    self.outPut.metadataObjectTypes = self.outPut.availableMetadataObjectTypes;

    // 监听输出
    [self.outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    

    
    
}




- (NSString *)scanQRCode{

    return @"";
}

@end
