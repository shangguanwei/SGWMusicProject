//
//  SGWMyMusicTableViewCell.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWMyMusicTableViewCell.h"
#import "UIButton+SGWImage.h"
#import "UIView+SGWMoreAttribute.h"
#import "SGWMusicModel.h"
#import "SGWPlayListTool.h"
#import "SGWEditBarItem.h"



@implementation SGWMyMusicTableViewCell


+(instancetype)myMusicTableViewCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"myMusicCell";
    SGWMyMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SGWMyMusicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
//重写方法，实现自定义cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];  //在此函数实现自定义cell布局
    }
    return self;
}

-(void)setupContentView {
    //1.左侧按钮
    UIButton *leftButton = [UIButton buttonwithNormalImage:@"all_favorite_btn_check_on_default" selectedImage:@"all_favorite_btn_check_on_pressed" target:self action:@selector(leftButtonClick:)];
    leftButton.frame = CGRectMake(0, 0, self.height, self.height);
    [self.contentView addSubview:leftButton];
    
    // cell重复利用问题
    _leftButton = leftButton;
    
//    [leftButton setBackgroundColor:[UIColor blackColor]];
    
    //2.显示歌曲名label
    UILabel *musicNameLabel = [[UILabel alloc]init];
    CGFloat musicNameLabelx = leftButton.right;
    CGFloat musicNameLabely = 0;
    CGFloat musicNameLabelw = self.width - 2*leftButton.width;
    CGFloat musicNameLabelh = self.height;
    musicNameLabel.frame = CGRectMake(musicNameLabelx, musicNameLabely, musicNameLabelw, musicNameLabelh);
    [self.contentView addSubview:musicNameLabel];
    
    _mymusicNameLabel = musicNameLabel;
    
    //3.负责下拉菜单button
    UIButton *rightButton = [UIButton buttonwithNormalImage:@"arrow_up" selectedImage:@"arrow_down" target:self action:@selector(rightButtonClick:)];
    rightButton.frame =CGRectMake(musicNameLabel.right, 0, self.height, self.height);
    [self.contentView addSubview:rightButton];
    
    _rightButton = rightButton;
    
    [self setupEditBar];
    
}

-(void)leftButtonClick:(UIButton *)button {
    
    button.selected = !button.selected;
    //cell重复使用问题
    SGWMusicModel *model = [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList[_indexPath.row];
    model.willBeDelete = button.selected;
    
    
}

-(void)rightButtonClick:(UIButton *)button {
    
    button.selected = !button.selected;
    
    SGWMusicModel *model = [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList[_indexPath.row];
    model.editBarShow = button.selected;
    
    
    //3-3根据具体条件调用代理方法
    if ([_delegate respondsToSelector:@selector(myMusicTableViewCell:didUpDateTableView:)]) {
        [_delegate myMusicTableViewCell:self didUpDateTableView:_indexPath];
    }
}



#pragma mark 设置编辑栏
-(void)setupEditBar{
    SGWEditBarItem * btn1 = [SGWEditBarItem editBarItemWithImage:@"heart-2x" title:@"我喜欢" target:self action:@selector(myLoveList)];
    SGWEditBarItem * btn2 = [SGWEditBarItem editBarItemWithImage:@"plus-2x" title:@"收藏" target:self action:@selector(saveList)];
    SGWEditBarItem * btn3 = [SGWEditBarItem editBarItemWithImage:@"trash-2x" title:@"删除" target:self action:@selector(deleteMusic)];
    SGWEditBarItem * btn4 = [SGWEditBarItem editBarItemWithImage:@"trash-2x" title:@"信息" target:self action:@selector(showInfo)];
    
    NSArray * editItems = @[btn1, btn2, btn3, btn4];
    SGWEditBar * editBar = [SGWEditBar editBarWithItems:editItems];
    
    _editBar = editBar;

    editBar.frame = CGRectMake(0, _leftButton.buttom, self.width, self.height);
    
    [self.contentView addSubview:editBar];
    
    
}


#pragma mark 我喜欢
-(void)myLoveList {
    NSLog(@"我喜欢");
}

#pragma mark - 收藏
-(void)saveList {
    NSLog(@"收藏");
}

#pragma mark - 删除
-(void)deleteMusic {
    NSLog(@"删除");

}

#pragma mark - 信息
-(void)showInfo{
    NSLog(@"信息");
    
}


@end
