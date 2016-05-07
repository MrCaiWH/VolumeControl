# iOS监听点击音量实体键和耳机音量设置按钮实现方法

### 一.在APP中打开控制中心和关闭控制中心，与程序进入后台和进入前台有一定的区别

操作控制中心，只走这两个方法
![说明文本](2.png)

进入前后台，走以下四个方法
![说明文本](1.png)

### 二.单击Home键，退入后台，再次进入，耳机中间键不可用

AVPlayer的status属性是个枚举，有三个值

	//    AVPlayerStatusUnknown,
	//    AVPlayerStatusReadyToPlay,
	//    AVPlayerStatusFailed
	
##### 当APP进入后台后，音频播放状态会变为AVPlayerStatusUnknown，在再次进入前台后，需要重新播放音频，使其状态值变为AVPlayerStatusReadyToPlay，远程遥控才能正常使用。
 
 
### 三.打开控制中心，耳机中间键仍然可以使用
打开控制中心时，结束远程遥控

    //结束远程遥控
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    
 
 进入前台后，重新设置player状态为播放，并且开始远程遥控
 
     //进入前台后，重新设置player状态为播放
    [self.player play];
    
    //开始远程遥控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];


