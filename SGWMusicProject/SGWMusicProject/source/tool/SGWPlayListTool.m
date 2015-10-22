//
//  SGWPlayListTool.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWPlayListTool.h"
#import "NSArray+SGWPlist.h"

static SGWPlayListTool *tool;

@implementation SGWPlayListTool

+(instancetype)sharedSGWPlayListTool {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[SGWPlayListTool alloc]init];
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

#pragma mark - 取得本地音乐列表
-(void)searchMyMusicList {
    NSMutableArray *myMusicList = [NSMutableArray array];
    
    NSArray *array = [NSArray arrayWithPlist:@"myMusicList.plist"];
    for (NSDictionary*dict in array) {
        SGWMusicModel *model = [SGWMusicModel musicModelWithDictionary:dict];
        [myMusicList addObject:model];
    }
    _myPlayMusicList = myMusicList;
}


#pragma mark 下一首歌曲
-(SGWMusicModel *)nextPlayMusic {
    SGWMusicModel * nextMusic = [[SGWMusicModel alloc]init];
    
    //本地播放列表为空，直接返回
    if (_myPlayMusicList.count == 0) {
        return nil;
    }
    
    switch (_playMode) {
        case kPlayModeAllLoop:
            nextMusic = [self allLoopNextMusic];
            break;
        case kPlayModeRandom:
            nextMusic = [self randomNextMusic];
            break;
        case kPlayModeSequence:
            nextMusic = [self sequenceNextMusic];
            break;
        case kPlayModeOneLoop:
            nextMusic = [self oneLoopNextMusic];
            break;
        default:
            break;
    }
    
    _nextPlayMusic = nextMusic;
    return _nextPlayMusic;
}


#pragma mark － 取得当前歌曲
-(SGWMusicModel *)curPlayMusic {
    if (_curPlayMusic == nil) {
        _curPlayMusic = self.nextPlayMusic;
    }
    return _curPlayMusic;
}

#pragma mark － 当前播放音乐索引号
-(NSInteger)curPlayMusicIndex {
    //取得播放列表
    NSArray *allListArray = [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList;
    
    //取得正在播放音乐
    SGWMusicModel *curPlayMusic = [SGWPlayListTool sharedSGWPlayListTool].curPlayMusic;
    
    //定位当前播放歌曲在整个列表中的位置
    NSInteger row = [allListArray indexOfObject:curPlayMusic];
    return row;
}


#pragma mark 全选或全不选
-(void)allCheck:(BOOL)allCheck{
    NSArray *allList = [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList;
    for (SGWMusicModel *model in allList) {
        model.willBeDelete = allCheck;
    }
}


#pragma mark - 删除列表中选中项
-(void)deleteMusicList{
    NSArray *alllist = [[SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList copy];
    for (SGWMusicModel *mode in alllist) {
        if (mode.willBeDelete == YES) {
            [[SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList removeObject:mode];
        }
    }
    
}



#pragma mark - 将当前音乐列表归档到文件中
-(void)saveCurPlayListToDocument:(NSString *)filename{

    NSArray * allLocMusiList = [[SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList mutableCopy];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = paths[0];
    NSString * locMusicListFile = [documentPath stringByAppendingPathComponent:filename];
    NSLog(@"save filename is:%@ ", filename);
    NSLog(@"save document path is:%@", locMusicListFile);
    
    //将本地音乐列表归档到locMuscListFile中，这个文件位于sandBox的Document路径
    [NSKeyedArchiver archiveRootObject:allLocMusiList toFile:locMusicListFile];
}
#pragma mark 解档，读取当前播放列表
-(void)getCurPlayListFromDocument:(NSString *)filename{

    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = paths[0];
    NSString * locMusicListFile = [documentPath stringByAppendingPathComponent:filename];
    NSLog(@"get filename is%@", filename);
    NSLog(@"get document path is :%@ ", documentPath);
    
    //判断Document 路径下是否有本地音乐播放列表文件locMusicList.Data
    //如果有该文件则从文件中读取数据，否则“加载”所有的音乐
    if ([[NSFileManager defaultManager] fileExistsAtPath:locMusicListFile]) {
        NSArray* locMusicList =[NSKeyedUnarchiver unarchiveObjectWithFile:locMusicListFile];
        [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList = [locMusicList mutableCopy];
    }else{
        [[SGWPlayListTool sharedSGWPlayListTool] searchMyMusicList];
    }
}



//设置默认播放模式为列表循环
-(instancetype)init {
    if (self == [super init]) {
        _playMode = kPlayModeAllLoop;
    }
    
    return self;
}


#pragma mark - 全部循环播放歌曲
-(SGWMusicModel*) allLoopNextMusic {
 
    SGWMusicModel * nextMusic = [[SGWMusicModel alloc]init];
    
    if (_curPlayMusic == nil) {      //初始状态未播放时的处理 － 从有曲目的列表第一首开始播放
        if (_myPlayMusicList.count ==0) {
            return nil;
        }
        else{
            nextMusic = _myPlayMusicList[0];
        }
    }else{
        if (_myPlayMusicList.count == 1) {  //只有一首歌时的处理
            nextMusic = _curPlayMusic;
        }else{                              //有多首歌时的处理
            NSInteger curIndex = [_myPlayMusicList indexOfObject:_curPlayMusic]; //定位当前歌曲在数组中的位置
            if (curIndex + 1 <= _myPlayMusicList.count -1) {
                nextMusic = _myPlayMusicList[curIndex+1];
            }else{
                nextMusic = _myPlayMusicList[0];
            }
        }
    }
    
    return nextMusic;
    
}

#pragma mark - 随机循环
-(SGWMusicModel*) randomNextMusic {
    
    SGWMusicModel * nextMusic = [[SGWMusicModel alloc]init];
    
   NSInteger randomIndex = arc4random()%_myPlayMusicList.count;
    nextMusic = _myPlayMusicList[randomIndex];
    
    return nextMusic;
    
}

#pragma mark - 顺序播放
-(SGWMusicModel*) sequenceNextMusic {
    
    SGWMusicModel * nextMusic = [[SGWMusicModel alloc]init];
    
    if (_curPlayMusic == nil) {
        if (_myPlayMusicList.count ==0) {
            return nil;
        }
        else{
            nextMusic = _myPlayMusicList[0];
        }
    }else{
        if (_myPlayMusicList.count == 1) {
            nextMusic = nil;
        }else{
            NSInteger curIndex = [_myPlayMusicList indexOfObject:_curPlayMusic]; //定位当前歌曲在数组中的位置
            if (curIndex + 1 <= _myPlayMusicList.count -1) {
                nextMusic = _myPlayMusicList[curIndex+1];
            }else{
                nextMusic = nil;
            }
        }
    }
    
    return nextMusic;
}

#pragma mark - 单曲循环
-(SGWMusicModel*) oneLoopNextMusic {
    
    SGWMusicModel * nextMusic = [[SGWMusicModel alloc]init];
    
    nextMusic = _curPlayMusic;
    return nextMusic;
}


@end
