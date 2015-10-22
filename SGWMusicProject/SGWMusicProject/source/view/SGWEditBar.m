//
//  SGWEditBar.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/24.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWEditBar.h"

@implementation SGWEditBar

+(instancetype)editBarWithItems:(NSArray *)items {
    SGWEditBar *editBar = [[SGWEditBar alloc]init];
    editBar.bounds = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 44);
    [editBar setupItems:items];
    
    return editBar;
}

#pragma mark - 设置barItem个数，自定义
-(void)setupItems:(NSArray *)items {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].applicationFrame.size.width/items.count;
    CGFloat h = 44;
    
    for (int i = 0; i < items.count; i++) {
        x = i * w;
        UIButton *button = items[i];
        button.frame = CGRectMake(x, y, w, h);
        button.backgroundColor = [UIColor lightGrayColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
}

@end
