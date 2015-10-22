//
//  UIButton+SGWImage.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIButton+SGWImage.h"

@implementation UIButton (SGWImage)

+(instancetype)buttonWithNormalImage:(NSString *)imageNormal andHighlightImage:(NSString *)imageHighlight target:(id)targit action:(SEL)action {
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateHighlighted];
    
    [button addTarget:targit action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+(instancetype)buttonwithNormalImage:(NSString*)imageNormal selectedImage:(NSString*)imageSelected target:(id) target action:(SEL)action
{
    UIButton *button  =[[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
