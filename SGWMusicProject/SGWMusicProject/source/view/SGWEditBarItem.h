//
//  SGWEditBarItem.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/24.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGWEditBarItem : UIButton
+(instancetype)editBarItemWithImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action;

@end
