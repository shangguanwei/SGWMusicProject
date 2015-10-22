//
//  SGWMusicModel.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <Foundation/Foundation.h>
//3-1.要想把自定义的对象进行归档，首先遵循NSCoding协议
@interface SGWMusicModel : NSObject <NSCoding>
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *time;
@property (copy,nonatomic) NSString *index;
@property (copy,nonatomic) NSString *singer;

@property(assign, nonatomic, getter=iswillBeDelete)BOOL willBeDelete; //编辑栏子功能实现：全选
@property(assign, nonatomic, getter=iseditBarShow)BOOL editBarShow;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
+(instancetype)musicModelWithDictionary:(NSDictionary *)dict;

//网络音乐模型
@property (nonatomic,copy)NSString *imgURL;
+(instancetype)netMusicModelWithDictionary:(NSDictionary *)dict;

//电台
@property (nonatomic,copy)NSString *musicURL;
+(instancetype)diantaiMusicModelWithDictionary:(NSDictionary *)dict;


@end
