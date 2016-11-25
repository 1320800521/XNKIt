//
//  XNQRCodeViewController.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/11.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScanWidth 200
#define lineTop 120
#define PreviewWidth 160


@interface XNQRCodeViewController ()<UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    BOOL _upOrdown;
    NSTimer *_timer;
    int _num;
    UIImageView *_line;
}

@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong) UIImageView *scanLineImageView;
@property (nonatomic,strong) UIImageView *scanView;

/**
 保存扫描图层
 */
@property (nonatomic,strong) CALayer *containerLayer;

@end

@implementation XNQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(photo:)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 50);
    [btn setTitle:@"开灯" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(turnTorchOn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // 3.开始扫描二维码
    [self initSubviews];
    [self buildCamera];
    
}

#pragma mark 
#pragma mark 闪光灯
- (void)turnTorchOn:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (btn.selected) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}


- (void)photo:(UIButton *)btn {
    
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 4.设置代理
    ipc.delegate = self;
    
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -------- UIImagePickerControllerDelegate---------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    // 2.从选中的图片中读取二维码数据
    // 2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    // 2.3取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        NSLog(@"%@",result.messageString);
        NSString *urlStr = result.messageString;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    
    // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}
-(void)initSubviews{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.000];
    
    _scanView = [[UIImageView alloc] init];
    _scanView.frame = CGRectMake((kScreenWidth-ScanWidth)/2, 100, ScanWidth, ScanWidth);
    _scanView.image = [UIImage imageNamed:@"bg_scanner"];
    [self.view addSubview:_scanView];
    
    _upOrdown = NO;
    _num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-ScanWidth)/2, lineTop,ScanWidth , 1)];
    _line.backgroundColor = [UIColor greenColor];
    _line.layer.cornerRadius = 8;
    [self.view addSubview:_line];
    
}

-(void)scanAnimation
{
    if (_upOrdown == NO) {
        _num ++;
        [UIView animateWithDuration:.1 animations:^{
            
            _line.frame = CGRectMake((kScreenWidth-ScanWidth)/2, lineTop+2*_num, ScanWidth, 1);
        }];
        
        
        if (2*_num >= 160) {
            _upOrdown = YES;
        }
    }
    else {
        _num --;
        [UIView animateWithDuration:.1 animations:^{
            
            _line.frame = CGRectMake((kScreenWidth-ScanWidth)/2, lineTop+2*_num, ScanWidth, 1);
        }];
        
        
        if (_num == 0) {
            _upOrdown = NO;
        }
    }
    
}

- (void)buildCamera
{
    if (!self.device) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if (!self.input) {
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    
    if (!self.output) {
        self.output = [[AVCaptureMetadataOutput alloc]init];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    
    if (!self.session) {
        self.session = [[AVCaptureSession alloc]init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 预览层
    if (!self.previewLayer) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = CGRectMake((kScreenWidth-PreviewWidth)/2,
                                   lineTop,
                                   PreviewWidth,
                                   PreviewWidth);
        
        self.previewLayer.backgroundColor = [UIColor orangeColor].CGColor;
        [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    }
    
    
//    _resultTextView.text = @"";
    if (!_timer.isValid) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
    }
    
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self.session stopRunning];
    
//    _resultTextView.text = stringValue;
    
    NSLog(@"扫描结果----------- %@",stringValue);
    
    _line.hidden = YES;
    [_timer invalidate];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"扫码成功" preferredStyle:UIAlertControllerStyleAlert];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
