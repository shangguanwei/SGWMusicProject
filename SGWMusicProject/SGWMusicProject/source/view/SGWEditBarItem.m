//
//  SGWEditBarItem.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/24.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWEditBarItem.h"


@implementation SGWEditBarItem

+(instancetype)editBarItemWithImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action {
    
    SGWEditBarItem *item = [[SGWEditBarItem alloc]init];
    [item setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateNormal];
    
    item.titleLabel.textAlignment = NSTextAlignmentCenter;  //文字居中，黑颜色，大小
    item.titleLabel.textColor = [UIColor blackColor];
    item.titleLabel.font = [UIFont systemFontOfSize:13];
    item.imageView.contentMode = UIViewContentModeCenter;
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return item;
    
}

#pragma mark 自定义Button title/image的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height/3;
    CGFloat x = 0;
    CGFloat y = contentRect.size.height*3/5;
    CGRect rect = CGRectMake(x, y, w, h);
    return rect;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat w = contentRect.size.height/3;
    CGFloat h = contentRect.size.height/3;
    CGFloat x = (contentRect.size.width - w)/2;
    CGFloat y = contentRect.size.height/9;
    CGRect rect = CGRectMake(x, y, w, h);
    return rect;
}







@end
