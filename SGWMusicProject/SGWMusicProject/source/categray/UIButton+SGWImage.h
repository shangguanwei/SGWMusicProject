//
//  UIButton+SGWImage.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SGWImage)

//按照image名字返回设置的普通和高亮状态button
+(instancetype)buttonWithNormalImage:(NSString *)imageNormal andHighlightImage:(NSString *)imageHighlight target:(id) targit action:(SEL)action;

//按照image名字返回普通和selected状态button
+(instancetype)buttonwithNormalImage:(NSString*)imageNormal selectedImage:(NSString*)imageSelected target:(id) target action:(SEL)action;

@end
