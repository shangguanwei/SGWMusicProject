//
//  SGWPlayListTool.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//
#pragma mark - 封装播放列表类

#import <Foundation/Foundation.h>
#import "SGWMusicModel.h"

typedef enum{
    kPlayModeAllLoop = 0,
    kPlayModeRandom,
    kPlayModeSequence,
    kPlayModeOneLoop
}PlayMode;

@interface SGWPlayListTool : NSObject

@property(strong, nonatomic) SGWMusicModel* curPlayMusic;   //当前歌曲
@property(strong, nonatomic) SGWMusicModel* nextPlayMusic;  //下一首歌曲
@property(strong, nonatomic) NSMutableArray * myPlayMusicList;  //本地音乐播放列表
@property(assign,nonatomic) NSInteger curPlayMusicIndex; // 当前播放音乐索引号

@property(assign, nonatomic) PlayMode playMode;  //开源代码集成

//创建一个播放列表的单例
+(instancetype)sharedSGWPlayListTool;

//1.获取本地音乐列表
-(void)searchMyMusicList;

//2.创建本地音乐列表
//-(void)loadhMyMusicList;
//3.从本地音乐列表删除歌曲
//-(void)deleteOneMusicFromMyMusicList:(SGWMusicModel *)music;

//4.全选或全不选
-(void)allCheck:(BOOL)allCheck;

//5.删除列表中选中项
-(void)deleteMusicList;


//将音乐列表归档到文件中
-(void)saveCurPlayListToDocument:(NSString*) filename;
//从音乐列表归档文件中读取当前的播放列表
-(void)getCurPlayListFromDocument:(NSString*) filename;



@end
