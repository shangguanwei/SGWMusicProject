//
//  SGWPlayBar.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/21.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGWPlayBar : UIView

//+(instancetype)playBar;
+(instancetype)sharedPlayBar;

//音乐播放标签同步更新
@property(weak, nonatomic) UILabel* musicNameLabel;
@property(weak, nonatomic) UILabel* singerLabel;
@property(weak, nonatomic) UIButton* playButton;

@end
