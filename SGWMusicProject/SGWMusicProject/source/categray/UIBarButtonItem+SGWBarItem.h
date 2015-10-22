//
//  UIBarButtonItem+SGWBarItem.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/22.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SGWBarItem)
+(instancetype)barButtonWithNormalItem:(NSString *)normal andSelectedImage:(NSString *)selected target:(id)target action:(SEL)action;

@end
