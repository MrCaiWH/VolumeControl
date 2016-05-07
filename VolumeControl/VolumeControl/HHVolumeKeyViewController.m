//
//  HHVolumeKeyViewController.m
//  VolumeControl
//
//  Created by 蔡万鸿 on 16/5/7.
//  Copyright © 2016年 黄花菜. All rights reserved.
//

#import "HHVolumeKeyViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface HHVolumeKeyViewController ()
/** 系统当前音量Label*/
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
/** 另一种方法获取系统当前音量Label*/
@property (weak, nonatomic) IBOutlet UILabel *otherVolumeLabel;
/** 音量View*/
@property (nonatomic, strong) MPVolumeView *volumeView;
/** 设置音量滚动View*/
@property (nonatomic, strong) UISlider *volumeViewSlider;
@end

@implementation HHVolumeKeyViewController

#pragma mark - ViewLife
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机实体按键";
    
    [self p_getVolumeView];
    
    [self p_hiddIcon];
    
    [self p_addObserver];
    
    [self p_addObserverControlCenter];

    [self p_getSystemVolume];
}

#pragma mark - IBActions
- (IBAction)ChangeSystemVolumeClick:(UIButton *)sender {
    //改变系统音量，这个值的范围为0.0f and 1.0f
    [self.volumeViewSlider setValue:1.0f animated:NO];
    
    //    // send UI control event to make the change effect right now.
    //    [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
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
 *  隐藏view
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
 *  应用程序打开控制中心时，会走以下两个通知
 */
- (void)p_addObserverControlCenter {
    //应用程序将要进入后台之前
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //应用程序切回到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 *  获取系统音量的两种办法
 */
- (void)p_getSystemVolume {
    //方法一
    float volume = [[AVAudioSession sharedInstance] outputVolume];
    self.volumeLabel.text = [NSString stringWithFormat:@"%f",volume];
    
    //方法二
    float systemVolume = self.volumeViewSlider.value;
    self.otherVolumeLabel.text = [NSString stringWithFormat:@"%f",systemVolume];
}

#pragma mark - NSNotification Event
/**
 *  点击音量键出发事件
 */
- (void)volumeChanged:(NSNotification *)notification {

    //获取当前系统音量
    NSDictionary *dic = [notification userInfo];
    self.volumeLabel.text = [NSString stringWithFormat:@"%@",dic[@"AVSystemController_AudioVolumeNotificationParameter"]];
    
    self.otherVolumeLabel.text = [NSString stringWithFormat:@"%@",dic[@"AVSystemController_AudioVolumeNotificationParameter"]];
}

/**
 *  打开控制中心，对音量键按钮的控制失效
 */
- (void)willResignActive {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

/**
 *  退出控制中心，重新控制音量键按钮
 */
- (void)didBecomeActive {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

@end
