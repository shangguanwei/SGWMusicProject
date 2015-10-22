//
//  SGWPlayBar.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWPlayBar.h"
#import "UIView+SGWMoreAttribute.h"
#import "UIButton+SGWImage.h"
#import <AVFoundation/AVFoundation.h>
#import "SGWPlayerTool.h"
#import "SGWMusicModel.h"
#import "NSArray+SGWPlist.h"
#import "SGWPlayListTool.h"

#define kImageWidthRadio 44/320
#define kImageHeightRatio 44/568
#define screenWidth  [UIScreen mainScreen].applicationFrame.size.width
#define screenHeight [UIScreen mainScreen].applicationFrame.size.height

static CGFloat curTime = 0;
static CGFloat totalTime = 0;

static SGWPlayBar * playBar;

@interface SGWPlayBar () {
    AVAudioPlayer *_audioPlayer;
//    SGWMusicModel *_defaultMusic;
    UIProgressView* _progress;
}

@end


@implementation SGWPlayBar

//+(instancetype)playBar {
//    SGWPlayBar *playbar = [[SGWPlayBar alloc]init];
//    playbar.bounds = CGRectMake(0, 0, screenWidth, screenHeight*kImageHeightRatio);
//    return playbar;
//}


+(instancetype)sharedPlayBar{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        playBar = [[SGWPlayBar alloc]init];
        playBar.bounds = CGRectMake(0, 0, screenWidth, screenHeight*kImageHeightRatio);
    });
    
    return  playBar;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        playBar = [super allocWithZone:zone];
    });
    return playBar;
}


-(instancetype)init{
    
    if (self = [super init]) {
        //加载子控件
        [self setupSubViews];
    }
    
    //接收playMusic通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivePlayMusicNotify:) name:@"startPlayMusic" object:nil];
    
    //设置进度条更新
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    
    return self;
}


#pragma mark 接受playMusic通知更新歌曲信息label
-(void)receivePlayMusicNotify:(NSNotification*)notify{
    [self updateMusicInfoLabel];
}


#pragma mark 获取正在播放歌曲的信息label
-(void)updateMusicInfoLabel{
    _musicNameLabel.text = [SGWPlayListTool sharedSGWPlayListTool].curPlayMusic.name;
    _singerLabel.text = [SGWPlayListTool sharedSGWPlayListTool].curPlayMusic.singer;
    _playButton.selected = YES;
    totalTime = [[SGWPlayListTool sharedSGWPlayListTool].curPlayMusic.time floatValue];
    curTime = 0;
}


-(void)timeTick {
    if ([SGWPlayerTool sharedSGWPlayerTool].status == kPlayerPlaying) {
        curTime += 0.01;
        _progress.progress = curTime/totalTime;
    }
}



#pragma mark - 通知移除，防止内存泄漏
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startPlayMusic" object:nil];
}


#pragma mark 加载子控件
-(void)setupSubViews {
    
    //播放空间基本属性
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 0.8;
    //1.左边图标
    UIImageView * leftImage = [[UIImageView alloc]init];
    [leftImage setImage:[UIImage imageNamed:@"play_bar_singerbg"]];
    leftImage.frame = CGRectMake(0, 0, screenWidth*kImageWidthRadio, screenHeight*kImageHeightRatio);
    [self addSubview:leftImage];
    
    //2.进度条
    UIProgressView *progress = [[UIProgressView alloc]init];
    progress.progressViewStyle = UIProgressViewStyleDefault;
    progress.progressViewStyle = UIProgressViewStyleDefault;
    progress.progressTintColor = [UIColor yellowColor];
    progress.frame = CGRectMake(leftImage.right+2, 3, screenWidth-leftImage.right-4, 2);
    [self addSubview:progress];
    //progress.progress = 0.5; //简单调试
    _progress = progress;
    
    //3.下一曲
    UIButton * nextButton = [[UIButton alloc]init];
    [nextButton setImage:[UIImage imageNamed:@"play_next"] forState:UIControlStateNormal];
    CGFloat nextButtonH = leftImage.height - progress.height -3;
    CGFloat nextButtonW = nextButtonH;
    CGFloat nextButtonX = screenWidth - nextButtonW;
    CGFloat nextButtonY = progress.buttom +3;
    nextButton.frame = CGRectMake(nextButtonX, nextButtonY, nextButtonW, nextButtonH);
    [nextButton addTarget:self action:@selector(playNextMusicButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:nextButton];

    //4.播放
    UIButton * playButton = [UIButton buttonwithNormalImage:@"play_play" selectedImage:@"play_stop" target:self action:@selector(playMusicButton:)];
    _playButton = playButton;
    
    CGFloat playButtonH = nextButton.height;
    CGFloat playButtonW = nextButton.width;
    CGFloat playButtonX = nextButton.left - playButtonW;
    CGFloat playButtonY = nextButton.top;
    
    playButton.frame = CGRectMake(playButtonX, playButtonY, playButtonW, playButtonH);
    [self addSubview:playButton];
    
    //5.歌曲名label
    UILabel *musicNameLabel = [[UILabel alloc]init];
    
    _musicNameLabel = musicNameLabel;
    
    musicNameLabel.text = @"邓紫棋 - 泡沫";
    musicNameLabel.font = [UIFont systemFontOfSize:15];
    musicNameLabel.textColor = [UIColor blackColor];
    musicNameLabel.frame = CGRectMake(progress.left, progress.buttom, screenWidth - 2*nextButton.width, 18);
    
    [self addSubview:musicNameLabel];
    
    //6.歌手label
    UILabel *singerLabel = [[UILabel alloc]init];
    
    _singerLabel = singerLabel;
    
    singerLabel.text = @"邓紫棋";
    singerLabel.font = [UIFont systemFontOfSize:12];
    singerLabel.textColor = [UIColor blackColor];
    singerLabel.frame = CGRectMake(progress.left, musicNameLabel.buttom, screenWidth - 2*nextButton.width, leftImage.height-musicNameLabel.buttom);

    [self addSubview:singerLabel];
    
    
    //7.获取默认播放歌曲
//    NSArray *array = [NSArray arrayWithPlist:@"myMusicList.plist"];
//    NSDictionary *dict = array[0];
//    SGWMusicModel *model = [SGWMusicModel musicModelWithDictionary:dict];
//    _defaultMusic = model;
    
}

#pragma mark 播放下一曲
-(void)playNextMusicButton:(UIButton*)btn {
    
    [[SGWPlayerTool sharedSGWPlayerTool] playNextMusic];
//    [[SGWPlayerTool sharedSGWPlayerTool] playMusic:[SGWPlayListTool sharedSGWPlayListTool].nextPlayMusic];
    
    
}

#pragma mark 播放当前音乐
-(void)playMusicButton:(UIButton*)btn {
    
    btn.selected =! btn.selected; //改变按钮状态
    
    if ([SGWPlayerTool sharedSGWPlayerTool].status == kPlayerPlaying) {
        [[SGWPlayerTool sharedSGWPlayerTool] pauseMusic];
    }
    else if ([SGWPlayerTool sharedSGWPlayerTool].status == kPlayerPause) {
            [[SGWPlayerTool sharedSGWPlayerTool] resumeMusic];      //继续播放
    }else {
            [[SGWPlayerTool sharedSGWPlayerTool] playMusic:[SGWPlayerTool sharedSGWPlayerTool].defaultMusic]; //设置默认播放歌曲
    }
    
    
    
}

@end
