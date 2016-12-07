//
//  XNVideoLaunchViewController.m
//  XNKit
//
//  Created by 小鸟 on 2016/11/29.
//  Copyright © 2016年 小鸟. All rights reserved.
//

#import "XNVideoLaunchViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "PrefixHeader.pch"
#import "ViewController.h"

@interface XNVideoLaunchViewController ()
//@property(nonatomic,strong)MPMoviePlayerController *player;
@property (nonatomic, strong) AVPlayer *player;
@property(nonatomic ,strong)AVAudioSession *avaudioSession;

@property(nonatomic, strong) AVPlayerItem *playerItem;

/**
 背景View
 */
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**
 登录
 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/**
 注册
 */
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

/**
 icon View
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

/**
 分页控制
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

/**
 循环scroller
 */
@property (weak, nonatomic) IBOutlet UIScrollView *XNScrollView;

/**
 引导页第一页文字
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLeftSpace;

/**
 第二页左边距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secLeftSpace;

/**
 第三页左边距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLeftSpace;

/**
 第四页左边距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foreLeftSpace;

/**
 页面控制
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation XNVideoLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置其他软件的音频文件不被打断，继续播放
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    
//    self.view.backgroundColor = [UIColor redColor];
//    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"1.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];

    self.playerItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREENH_HEIGHT);
    playerLayer.borderColor = [UIColor redColor].CGColor;
//    self.bottomSpace.constant = KSCREENH_HEIGHT - 200;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    [self.player play];
    
    [self addObserver];
    
    self.XNScrollView.contentSize = CGSizeMake(KSCREEN_WIDTH * 4, KSCREENH_HEIGHT);
}

#pragma mark -  添加进度观察 - addProgressObserver
- (void)addObserver {
    
    __block BOOL isjeep = NO;
    __weak __block XNVideoLaunchViewController* weakself = self;
    //      设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue: NULL usingBlock:^(CMTime time) {
        //  获取当前时间
        CMTime currentTime = weakself.player.currentItem.currentTime;
        
        // 转化成秒
       float currentSec = (CGFloat)currentTime.value / currentTime.timescale;
        //  总时间
        CMTime totalTime = weakself.playerItem.duration;
        // 转化成秒
        float totalTimeSec = (CGFloat)totalTime.value / totalTime.timescale;

       
        if (totalTimeSec == currentSec && isjeep == NO) {
            
            isjeep = YES;
            
            NSLog(@" ------------ 1");
            
            NSLog(@" %f  %f",totalTimeSec,currentSec);
            
            ViewController *viewVC = [[ViewController alloc]init];
            [weakself.navigationController pushViewController:viewVC animated:YES];
        }

    }];
    
}


- (IBAction)regist:(id)sender {

}

- (IBAction)login:(id)sender {
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
