//
//  HHEarphoneViewController.m
//  VolumeControl
//
//  Created by 蔡万鸿 on 16/5/7.
//  Copyright © 2016年 黄花菜. All rights reserved.
//

#import "HHEarphoneViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface HHEarphoneViewController ()
/** 音频播放器 */
@property (nonatomic, strong) AVPlayer *player;
/** 点击耳机中间键触发开关变化 */
@property (weak, nonatomic) IBOutlet UISwitch *middleSwitch;
@end

@implementation HHEarphoneViewController

#pragma mark - ViewLife
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"耳机中间键";
    
    //远程遥控需要播放一段音频激活，否则无法使用
    [self.player play];
    
    //当APP进入后台后，音频播放状态会变为未知AVPlayerStatusUnknown，在再次进入前台后，需要重新播放音频，远程遥控才能正常使用
    [self p_addObserver];
    
    //开始接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - Private
/**
 *  耳机中间键远程遥控事件
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    self.middleSwitch.on = !self.middleSwitch.on;
}

/**
 *  监听点击音量键事件
 */
- (void)p_addObserver {
    //应用程序切回到前台
    //此处用 UIApplicationWillEnterForegroundNotification 或者 UIApplicationDidBecomeActiveNotification都可以
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 *  退出控制中心，重新控制音量键按钮
 */
- (void)didBecomeActive {
    [self.player play];
}

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

#pragma mark - NSObject
- (void)dealloc {
    //结束远程事件
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

@end
