//
//  HHCombinedViewController.m
//  VolumeControl
//
//  Created by 蔡万鸿 on 16/5/7.
//  Copyright © 2016年 黄花菜. All rights reserved.
//

#import "HHCombinedViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface HHCombinedViewController ()
/** 系统当前音量Label*/
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
/** 点击耳机中间键触发开关变化 */
@property (weak, nonatomic) IBOutlet UISwitch *middleSwitch;
/** 音量View*/
@property (nonatomic, strong) MPVolumeView *volumeView;
/** 设置音量滚动View*/
@property (nonatomic, strong) UISlider *volumeViewSlider;
/** 音频播放器 */
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation HHCombinedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"耳机手机同时控制";
    
    //1.获取音量监听视图
    [self p_getVolumeView];
    
    //2.隐藏音量Icon
    [self p_hiddIcon];
    
    //3.监听点击音量键事件
    [self p_addObserver];
    
    //4.监听打开控制中心
    [self p_addObserverControlCenter];
    
    //5.获取当前系统音量
    [self p_getSystemVolume];
    
    //6.耳机中间键远程遥控需要播放一段音频激活，否则无法使用
    [self.player play];
    
    //7.开始接收远程遥控事件,耳机中间键
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - Private
/**
 *  获取音量监听视图
 */
- (void)p_getVolumeView {
    self.volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider*)view;
            break;
        }
    }
}

/**
 *  隐藏音量Icon
 */
- (void)p_hiddIcon {
    self.volumeView.frame = CGRectMake(-1000, -100, 100, 100);
    self.volumeView.hidden = NO;
    [self.view  addSubview:self.volumeView];
}

/**
 *  监听点击音量键事件
 */
- (void)p_addObserver {
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

/**
 *  应用程序失效或者再次进入前台，会走以下两个通知
 */
- (void)p_addObserverControlCenter {
    //应用程序将要进入后台之前
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //应用程序切回到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 *  获取系统音量
 */
- (void)p_getSystemVolume {
    float volume = [[AVAudioSession sharedInstance] outputVolume];
    self.volumeLabel.text = [NSString stringWithFormat:@"%f",volume];
}

#pragma mark - NSNotification Event
/**
 *  点击音量键触发事件
 */
- (void)volumeChanged:(NSNotification *)notification {
    //获取当前系统音量
    NSDictionary *dic = [notification userInfo];
    self.volumeLabel.text = [NSString stringWithFormat:@"%@",dic[@"AVSystemController_AudioVolumeNotificationParameter"]];
}

/**
 *  APP挂起时，取消对音量键的监听
 */
- (void)willResignActive {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

    //结束远程遥控
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

/**
 *  重新进去前台
 */
- (void)didBecomeActive {
    //重新监听音量改变事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    //进入前台后，重新设置player状态为播放
    [self.player play];
    
    //开始远程遥控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

/**
 *  耳机中间键远程遥控事件
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    self.middleSwitch.on = !self.middleSwitch.on;
}

#pragma mark - Lazy
/**
 *  加载音频播放文件
 */
- (AVPlayer *)player {
    if (_player == nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"silent.m4a" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        _player = [[AVPlayer alloc] initWithURL:url];
        [_player setVolume:0.0];
    }
    return _player;
}
@end
