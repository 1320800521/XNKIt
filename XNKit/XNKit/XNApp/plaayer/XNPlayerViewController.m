//
//  XNPlayerViewController.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/23.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PrefixHeader.pch"
#import "XNTouchButton.h"

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

@interface XNPlayerViewController ()<UIGestureRecognizerDelegate,XNTouchButtonDelegate>
//@property (nonatomic, strong) AVPlayerHelper *playerHelper;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playItem;
@property (nonatomic, strong) AVPlayer *player;

/**
 工具栏
 */
@property (weak, nonatomic) IBOutlet UIView *VBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *centerPlayBtn;

/**
 上一曲
 */
@property (weak, nonatomic) IBOutlet UIButton *VBackBtn;

/**
 播放
 */
@property (weak, nonatomic) IBOutlet UIButton *VPlayBtn;

/**
 下一曲
 */
@property (weak, nonatomic) IBOutlet UIButton *VNextBtn;

@property (nonatomic, strong) XNTouchButton *controlBtn;

@property (assign, nonatomic) Direction direction;

@property (assign, nonatomic) NSTimeInterval total;

@property (assign, nonatomic) CGPoint startPoint; // 开始触碰点

@property (strong, nonatomic) UISlider* volumeViewSlider;//控制音量

@property (assign, nonatomic) CGFloat currentRate;//当期视频播放的进度

@property (assign, nonatomic) CGFloat startVB;

@property (assign, nonatomic) CGFloat startVideoRate;

/**
 是否正在播放
 */
@property (nonatomic,assign) BOOL isPlay;

/**
 单次点击
 */
@property (nonatomic,assign) BOOL isFirstClick;

/**
 调节声音或亮度   
 
 isValue = YES 调节声音
 
 isValue = NO 调节亮度
 */
@property (nonatomic,assign) BOOL isValue;


@end

@implementation XNPlayerViewController

- (void)dealloc{
    
    self.player = nil;
    self.playItem = nil;
    self.playerLayer = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.VBackBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.VPlayBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.VNextBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.centerPlayBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    // 屏幕旋转
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    //
    [self configerPlayer];
    
    self.controlBtn = [XNTouchButton buttonWithType:UIButtonTypeCustom];
    self.controlBtn.backgroundColor = [UIColor clearColor];
    self.controlBtn.frame = self.view.frame;
    self.controlBtn.touchDelegate = self;
    [self.view addSubview:self.controlBtn];
    
    
    // 添加点击手势 /* 播放暂停*/
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
    //    tapGes.delegate = self;
    tapSingle.numberOfTapsRequired = 1;
    [self.controlBtn addGestureRecognizer:tapSingle];
    
    // 添加点击手势 /* 播放暂停*/
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
    //    tapGes.delegate = self;
    tapDouble.numberOfTapsRequired = 2;
    [self.controlBtn addGestureRecognizer:tapDouble];
    
    
}


#pragma mark - 自定义Button的代理***********************************************************
#pragma mark - 开始触摸
/*************************************************************************/
- (void)touchesBeganWithPoint:(CGPoint)point {
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是音量，右边是亮度
    if (self.startPoint.x <= self.controlBtn.frame.size.width / 2.0) {
        //音/量
        self.startVB = self.volumeViewSlider.value;
    } else {
        //亮度
        self.startVB = [UIScreen mainScreen].brightness;
    }
    //方向置为无
    self.direction = DirectionNone;
    //记录当前视频播放的进度
    CMTime ctime = self.player.currentTime;
    self.startVideoRate = ctime.value / ctime.timescale / CMTimeGetSeconds(self.player.currentItem.duration);;
    
}

#pragma mark - 结束触摸
- (void)touchesEndWithPoint:(CGPoint)point {
    if (self.direction == DirectionLeftOrRight) {
        [self.player seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(self.player.currentItem.duration) * self.currentRate, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            //在这里处理进度设置成功后的事情
        }];
    }
}

#pragma mark - 拖动
- (void)touchesMoveWithPoint:(CGPoint)point {
    //得出手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    
        // Calculate offset
        float dx = point.x - self.startPoint.x;
        float dy = point.y - self.startPoint.y;
        CGPoint newcenter = CGPointMake(self.view.center.x + dx, self.view.center.y + dy);
        
        //设置移动区域
        // Bound movement into parent bounds
        float halfx = CGRectGetMidX(self.view.bounds);
        newcenter.x = MAX(halfx, newcenter.x);
        newcenter.x = MIN(self.view.bounds.size.width - halfx, newcenter.x);
        
        float halfy = CGRectGetMidY(self.view.bounds);
        newcenter.y = MAX(halfy, newcenter.y);
        newcenter.y = MIN(self.view.bounds.size.height - halfy, newcenter.y);
        
        // Set new location
        self.view.center = newcenter;
    
    //分析出用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = DirectionLeftOrRight;
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
        }
    }
    
    if (self.direction == DirectionNone) {
        return;
    } else if (self.direction == DirectionUpOrDown) {
        //音量和亮度
        if (self.startPoint.x <= self.controlBtn.frame.size.width / 2.0) {
            //音量
            if (panPoint.y > 0) {
                
                self.volumeViewSlider.hidden = NO;
                
                //增大音量
//                [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                if (self.startVB + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
                    
                    self.player.volume = self.startVB + (-panPoint.y / 30.0 / 10);
                }
                
                self.player.volume = self.startVB + (-panPoint.y / 30.0 / 10);
                
                NSLog(@"音量 +++++++++ %f",self.player.volume);
                
            } else {
                //减少音量
                [self.volumeViewSlider setValue:self.startVB - (panPoint.y / 30.0 / 10) animated:YES];
                
                self.player.volume = self.startVB - (panPoint.y / 30.0 / 10);
                
                NSLog(@"音量 --------- %f",self.player.volume);
            }
         
            self.volumeViewSlider.value = self.player.volume;
            
            [UIView animateWithDuration:3 animations:^{
//                处理隐藏
                self.volumeViewSlider.hidden = YES;
            } completion:^(BOOL finished)
             {
//                 动画结束处理  可以重新执行另一个动画
             }];
            
        } else if(YES){
            
            //调节亮度
            if (panPoint.y < 0) {
                //增加亮度
                [[UIScreen mainScreen] setBrightness:self.startVB + (-panPoint.y / 30.0 / 10)];
            } else {
                //减少亮度
                [[UIScreen mainScreen] setBrightness:self.startVB - (panPoint.y / 30.0 / 10)];
            }
        }
    } else if (self.direction == DirectionLeftOrRight ) {
        //进度
        CGFloat rate = self.startVideoRate + (panPoint.x / 30.0 / 20.0);
        if (rate > 1) {
            rate = 1;
        } else if (rate < 0) {
            rate = 0;
        }
        self.currentRate = rate;
    }
}

- (void)userTapGestureAction:(UITapGestureRecognizer *)xjTap{

}


#pragma mark - TBloaderURLConnectionDelegate


#pragma mark
#pragma mark 手势操作
- (void)tapGes:(UITapGestureRecognizer *)tap{
    
    if (tap.numberOfTapsRequired == 1) {
         [self play];
    } else {
        
    }
}


#pragma mark
#pragma mark 配置播放器
- (void)configerPlayer{
    
    self.playItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@"http://baobab.cdn.wandoujia.com/14464539635131446103741576t_x264.mp4"]];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, 200);
    self.playerLayer.borderColor = [UIColor redColor].CGColor;
    self.bottomSpace.constant = KSCREENH_HEIGHT - 200;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.playerLayer atIndex:0];
    [self addProgressObserver];
    
    [self.player play];
    
    self.volumeViewSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 100, 100, 2)];
    self.volumeViewSlider.minimumValue = 0;
    self.volumeViewSlider.maximumValue = 1;
    self.volumeViewSlider.hidden = YES;
    self.volumeViewSlider.center = CGPointMake(KSCREEN_WIDTH / 2, 100);
    self.volumeViewSlider.backgroundColor = [UIColor whiteColor];
    self.volumeViewSlider.minimumValueImage = [UIImage imageNamed:@"point"];
//    - (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state;
//    self.volumeViewSlider setmax
    self.volumeViewSlider.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.view addSubview:self.volumeViewSlider];
    
}

#pragma mark -  添加进度观察 - addProgressObserver
- (void)addProgressObserver {
    //      设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue: NULL usingBlock:^(CMTime time) {
        //        NSLog(@"进度观察 + %f", self.playProgress.value);
        //  获取当前时间
        CMTime currentTime = self.player.currentItem.currentTime;
        //  转化成秒数
        CGFloat currentPlayTime = (CGFloat)currentTime.value / currentTime.timescale;
        //  总时间
        CMTime totalTime = self.playItem.duration;
        //  转化成秒
        //        _totalMovieDuration = (CGFloat)totalTime.value / totalTime.timescale;
        //        //  相减后
        //        self.playProgress.value = CMTimeGetSeconds(currentTime) / _totalMovieDuration;
        //        self.progressSlider = CMTimeGetSeconds(currentTime) / _totalMovieDuration;
        //                NSLog(@"%f", _topProgressSlider.value);
        //        NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970: currentPlayTime];
        ////        self.playTime.text = [self getTimeByDate:pastDate byProgress: currentPlayTime];
        //        if (self.isFirstTap) {
        //            [self setTopRightBottomViewShowToHidden];
        //        } else {
        //            [self setTopRightBottomViewHiddenToShow];
        //        }
    }];
    //      设置topProgressSlider图片
    UIImage *thumbImage = [UIImage imageNamed:@"slider-metal-handle.png"];
    //    [self.playProgress setThumbImage:thumbImage forState:UIControlStateHighlighted];
    //    [self.playProgress setThumbImage:thumbImage forState:UIControlStateNormal];
}


/**
 检测屏幕旋转
 */
- (void)didRotate{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        
        self.playerLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREENH_HEIGHT);
        self.bottomSpace.constant = 0;
        
        self.volumeViewSlider.center = CGPointMake(KSCREEN_WIDTH / 2, KSCREENH_HEIGHT / 2);
        
        NSLog(@"KSCREENH_HEIGHT  =  %f KSCREEN_WIDTH = %f",KSCREENH_HEIGHT,KSCREEN_WIDTH);
    }
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.playerLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREENH_HEIGHT);
        
        self.volumeViewSlider.center = CGPointMake(KSCREEN_WIDTH / 2, KSCREENH_HEIGHT / 2);
        
        self.bottomSpace.constant = 0;
        
        NSLog(@"KSCREENH_HEIGHT  =  %f KSCREEN_WIDTH = %f",KSCREENH_HEIGHT,KSCREEN_WIDTH);
    }
    if (orientation == UIInterfaceOrientationPortrait) {
        //  竖屏的时候
        NSLog(@"KSCREENH_HEIGHT  =  %f KSCREEN_WIDTH = %f",KSCREENH_HEIGHT,KSCREEN_WIDTH);
        
        self.playerLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, 200);
        self.bottomSpace.constant =  KSCREENH_HEIGHT - 200;
        
        self.volumeViewSlider.center = CGPointMake(KSCREEN_WIDTH / 2,100);
        
    }
}

/**
 *  重置界面UI
 */
- (void)reConfiger{
    
    //    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //    if (orientation == UIInterfaceOrientationLandscapeRight) {
    ////        [self setPlayerLayerFrame];
    //        //        self.isFirstRotatorTap = YES;
    ////        [self setTopRightBottomFrame];
    //    }
    //    if (orientation == UIInterfaceOrientationLandscapeLeft) {
    ////        [self setPlayerLayerFrame];
    ////
    ////        [self setTopRightBottomFrame];
    //    }
    //    if (orientation == UIInterfaceOrientationPortrait) {
    //        //  竖屏的时候
    ////        [self setVerticalFrame];
    ////        //        self.isFirstRotatorTap = YES;
    ////        [self setTopRightBottomFrame];
    //    }
}

- (void)bottmRight{
    
}


/**
 上一曲
 
 @param sender 上一曲
 */
- (IBAction)backBtnClik:(id)sender {
    
}


/**
 播放
 
 @param sender 播放
 */

- (IBAction)playBtnClick:(id)sender {
    
    [self play];
}

/**
 播放

 @param sender 屏幕中央
 */
- (IBAction)playCenterBtn:(id)sender {
}

/**
 下一曲
 
 @param sender 下一曲
 */
- (IBAction)nextBtnClick:(id)sender {
}

#pragma mark
#pragma mark 操作播放器

/**
 播放暂停
 */
- (void)play{
    self.isPlay = !self.isPlay;
    
    if (self.isPlay) {
        [self.player pause];
    }else{
        [self.player play];
    }
}


/**
    快退
 */
- (void)back{

}

/**
 快进
 */
- (void)next{

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    [self configerPlayer];
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
