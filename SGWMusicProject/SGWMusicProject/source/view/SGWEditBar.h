//
//  SGWEditBar.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/24.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGWEditBar : UIView

//自定义editBar应具有可重用性和自适应性，即bar上按钮个数可变
+(instancetype)editBarWithItems:(NSArray *)items;

@end
