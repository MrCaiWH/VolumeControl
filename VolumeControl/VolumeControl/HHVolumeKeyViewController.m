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
/** 音量View*/
@property (nonatomic, strong) MPVolumeView *volumeView;
/** 设置音量滚动View*/
@property (nonatomic, strong) UISlider *volumeViewSlider;
@end

@implementation HHVolumeKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_getVolumeView];
    
    [self p_hiddIcon];
    
    [self p_addObserver];
    
    //获取当前系统音量
    float volume = [[AVAudioSession sharedInstance] outputVolume];
    self.volumeLabel.text = [NSString stringWithFormat:@"%f",volume];
}

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
 *  点击音量键出发事件
 */
- (void)volumeChanged:(NSNotification *)notification {

    //获取当前系统音量
    NSDictionary *dic = [notification userInfo];
    self.volumeLabel.text = [NSString stringWithFormat:@"%@",dic[@"AVSystemController_AudioVolumeNotificationParameter"]];
    

    
    //    // retrieve system volume
    //    //    float systemVolume = volumeViewSlider.value;
    //
    //    // change system volume, the value is between 0.0f and 1.0f
    //    [volumeViewSlider setValue:1.0f animated:NO];
    //
    //    // send UI control event to make the change effect right now.
    //    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
