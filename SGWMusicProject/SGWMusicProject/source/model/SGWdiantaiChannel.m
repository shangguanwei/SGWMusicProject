//
//  SGWdiantaiChannel.m
//  SGWMusicProject
//
//  Created by neuedu on 15/10/20.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWdiantaiChannel.h"

@implementation SGWdiantaiChannel
+(instancetype)diantaiChannelWithDictionary:(NSDictionary *)dict {
    SGWdiantaiChannel *channel = [[SGWdiantaiChannel alloc]init];
    channel.channel_id = [NSString stringWithFormat:@"%@",dict[@"channel_id"]];
    channel.name = dict[@"name"];
    return channel;
}

@end
