//
//  SGWMusicModel.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWMusicModel.h"
//音乐模型归档 - 宏
#define keyName         @"name"
#define keySinger       @"singer"
#define keyTime         @"time"
#define keyIndex        @"index"
#define keyWillBeDelete @"willBeDelete"

@implementation SGWMusicModel
-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)musicModelWithDictionary:(NSDictionary *)dict {
//    SGWMusicModel *model = [[SGWMusicModel alloc]init];
//    [model setValuesForKeysWithDictionary:dict];
//    return model;
    return [[self alloc]initWithDictionary:dict];
}


//3-2.解档：重写initWithCoder 从文件中利用NSKeyedUnarchiver读取对象数据，还原时需要调用
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        _name = [aDecoder decodeObjectForKey:keyName];
        _singer = [aDecoder decodeObjectForKey:keySinger];
        _time = [aDecoder decodeObjectForKey:keyTime];
        _index = [aDecoder decodeObjectForKey:keyIndex];
        _willBeDelete = [aDecoder decodeObjectForKey:keyWillBeDelete];
    }
    return self;
}

//3-3.归档：重写endcodeWithCoder 把对象进行归档，将数据存储到文件中 NSKeyedArchiver
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:keyName];
    [aCoder encodeObject:_singer forKey:keySinger];
    [aCoder encodeObject:_time forKey:keyTime];
    [aCoder encodeObject:_index forKey:keyIndex];
    [aCoder encodeBool:_willBeDelete forKey:keyWillBeDelete];
}

#pragma mark - 网络音乐模型
+(instancetype)netMusicModelWithDictionary:(NSDictionary *)dict {
    SGWMusicModel *model = [[SGWMusicModel alloc]init];
    //[model setValuesForKeysWithDictionary:dict];
    
    //NSLog(@"歌曲名为%@",dict[@"title"]);
    //NSLog(@"图片为%@",dict[@"image"]);
    //NSLog(@"歌手为%@",dict[@"attrs"][@"singer"][0]);
    
    model.name = dict[@"title"];
    model.singer = dict[@"attrs"][@"singer"][0];
    model.imgURL = dict[@"image"];
    
    return model;
}


#pragma mark - 电台音乐模型
+(instancetype)diantaiMusicModelWithDictionary:(NSDictionary *)dict {
    SGWMusicModel *model = [[SGWMusicModel alloc]init];
    
    model.name = dict[@"title"];
    model.singer = dict[@"artist"];
    model.imgURL = dict[@"picture"];
    model.musicURL = dict[@"url"];
    model.time = dict[@"length"];
    
    return model;
}

@end
