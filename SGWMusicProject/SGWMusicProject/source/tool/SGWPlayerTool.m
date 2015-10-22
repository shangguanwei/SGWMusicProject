//
//  SGWPlayerTool.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/23.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWPlayerTool.h"
//#import <AVFoundation/AVFoundation.h>
#import "SGWPlayListTool.h"
#import "SGWPlayBar.h"
#import <MediaPlayer/MediaPlayer.h>

static SGWPlayerTool *tool;

@interface SGWPlayerTool () {
//    AVAudioPlayer *_audioPlayer;
    MPMoviePlayerController *_player;
}

@end

@implementation SGWPlayerTool

//播放器工具设置为单例，保证整个应用程序之用一个播放器工具
+(instancetype)sharedSGWPlayerTool {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[SGWPlayerTool alloc]init];
    });
    return tool;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}



-(void)musicPlayEndAction:(NSNotification *)notify {
    
    [self playNextMusic];
}


//移除通知
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//1.播放音乐
-(void)playMusic:(SGWMusicModel *)music {
    //所有的音乐播放都在此处，切忌不能在什么地方点播就在什么地方设置，
    //这样会导致当前播放音乐设置的地方过多，难以维护，可维护性差
    
    if (music == nil) {
        return;
    }
    
    [SGWPlayListTool sharedSGWPlayListTool].curPlayMusic = music;
    _defaultMusic = music;
    
#warning 如何将上次播放歌曲存入沙盒中，下次启动调用？
    
    //接受音乐播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musicPlayEndAction:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    
    
    NSURL *url;
    
    if (_musicSource == kmusicSourceLocal) {
        //准备本地播放的URL
        NSString *musicName = music.name;
        musicName = [musicName stringByAppendingString:@".mp3"];
        //通过路径获取歌曲
        NSURL *localurl = [[NSBundle mainBundle]URLForResource:musicName withExtension:nil];
        url = localurl;

    }else {
        //准备网络播放的URL
        url =[NSURL URLWithString:music.musicURL];
    }
    
    //播放器
    if (_player == nil) {
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:url];
        _player = player;
    } else {
        
        [_player setContentURL:url];
    }
    
    
    [_player play];
    
    
    
/*
    //获取歌曲资源名
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url fileTypeHint:nil error:nil];
    _audioPlayer = audioPlayer;
    
    //做一个播放缓存，然后进行歌曲播放
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
*/
    
    _status = kPlayerPlaying;  //纪录播放状态
    
    
    //发送一个开始播放音乐的通知，需要更新信息的地方接受此通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"startPlayMusic" object:self];
}


//2.暂停音乐
-(void)pauseMusic {
    
    if (_status == kPlayerPlaying) {
        [_player pause];
        _status = kPlayerPause;
    }
    
/*
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer pause];
        _status = kPlayerPause;
    }
*/
}

//3.断点续播
-(void)resumeMusic {
    
    if (_status == kPlayerPause) {
        [_player play];
        _status = kPlayerPlaying;
    }
    
/*
    if (![_audioPlayer isPlaying]) {
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        _status = kPlayerPlaying;
    }
*/
    
}

//4.下一首
-(void)playNextMusic {
    [self playMusic:[SGWPlayListTool sharedSGWPlayListTool].nextPlayMusic];
}




@end
