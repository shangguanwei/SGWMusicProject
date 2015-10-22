//
//  SGWPlayerTool.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/23.
//  Copyright (c) 2015年 neuedu. All rights reserved.

#pragma mark - 封装音乐播放工具类

#import <Foundation/Foundation.h>
#import "SGWMusicModel.h"

//枚举
typedef enum {
    kPlayerLoaded = 0,
    kPlayerPause,
    kPlayerPlaying
}PlayStatus;

// 本地音乐，电台音乐
typedef enum MusicSource {
    kmusicSourceLocal,
    kmusicSourceDiantai
}MusicSource;

@interface SGWPlayerTool : NSObject
@property (strong,nonatomic) SGWMusicModel *defaultMusic; //默认播放歌曲

@property (assign,nonatomic) PlayStatus status;  //用一个枚举纪录播放状态

@property(nonatomic,assign) MusicSource musicSource;

//创建一个音乐播放工具单例
+(instancetype) sharedSGWPlayerTool;

//1.播放音乐
-(void)playMusic:(SGWMusicModel *)music;

//2.暂停音乐
-(void)pauseMusic;

//3.断点续播
-(void)resumeMusic;

//4.下一首
-(void)playNextMusic;

//5.


@end
