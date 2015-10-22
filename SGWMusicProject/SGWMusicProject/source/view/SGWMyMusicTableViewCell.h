//
//  SGWMyMusicTableViewCell.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGWEditBar.h"

//通过代理实现：当点击cell右侧button时，刷新cell编辑栏高度
//3-1声明代理设计代理方法
@class SGWMyMusicTableViewCell;
@protocol SGWMyMusicTableViewCellDelegate <NSObject>

-(void)myMusicTableViewCell:(SGWMyMusicTableViewCell *)tableViewCell didUpDateTableView:(NSIndexPath *)indexPath;

@end


@interface SGWMyMusicTableViewCell : UITableViewCell


@property (nonatomic,weak) UILabel *mymusicNameLabel;
@property(strong, nonatomic) NSIndexPath* indexPath;  //解决cell复用问题
@property(weak, nonatomic) UIButton* leftButton;
@property(weak, nonatomic) UIButton* rightButton;
@property (weak,nonatomic) SGWEditBar *editBar;


//3-2属性中声明代理实例
@property(strong,nonatomic) id <SGWMyMusicTableViewCellDelegate> delegate;


+(instancetype)myMusicTableViewCellWithTableView:(UITableView *)tableView;


@end
