//
//  UIBarButtonItem+SGWBarItem.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIBarButtonItem+SGWBarItem.h"
#import "UIButton+SGWImage.h"

@implementation UIBarButtonItem (SGWBarItem)
+(instancetype)barButtonWithNormalItem:(NSString *)normal andSelectedImage:(NSString *)selected target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonwithNormalImage:normal selectedImage:selected target:target action:action];
    button.bounds = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *Item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return Item;
}

@end
