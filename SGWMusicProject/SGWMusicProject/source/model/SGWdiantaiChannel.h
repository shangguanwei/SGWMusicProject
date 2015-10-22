//
//  SGWdiantaiChannel.h
//  SGWMusicProject
//
//  Created by neuedu on 15/10/20.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGWdiantaiChannel : NSObject
@property(nonatomic,copy) NSString* channel_id;
@property(nonatomic,copy) NSString * name;

+(instancetype)diantaiChannelWithDictionary:(NSDictionary *)dict;

@end
