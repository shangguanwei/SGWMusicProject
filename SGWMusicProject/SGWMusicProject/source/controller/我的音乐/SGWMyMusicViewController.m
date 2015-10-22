//
//  SGWMyMusicViewController.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/17.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWMyMusicViewController.h"
#import "NSArray+SGWPlist.h"
#import "SGWMyMusicTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIBarButtonItem+SGWBarItem.h"
#import "SGWMusicModel.h"
#import "SGWPlayListTool.h"
#import "SGWPlayerTool.h"
#import "SGWEditBar.h"
#import "SGWEditBarItem.h"
#import "SGWPlayBar.h"
#import "KxMenu.h"

@interface SGWMyMusicViewController ()<UITableViewDataSource,UITableViewDelegate,SGWMyMusicTableViewCellDelegate> {
    AVAudioPlayer *_audioPlayer;
    SGWEditBar *_editBar;
    BOOL _isEditBarShow; //隐藏和显示editBar
}
//@property (nonatomic,strong) NSMutableArray *myMusicModelList;
@property (weak,nonatomic) UITableView *tableView;

@end

@implementation SGWMyMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    [self setupNavBar];
    
    //接收新播放歌曲的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusicNotify:) name:@"startPlayMusic" object:nil];
    
    //设置编辑栏
    [self setupEditBar];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [[SGWPlayListTool sharedSGWPlayListTool] getCurPlayListFromDocument:@"locMusicList.data"];
}



#pragma mark - 将要退出页面时确保playBar显示,文件归档解档操作
-(void)viewWillDisappear:(BOOL)animated {
    
    if (_isEditBarShow == YES) {
        
        _isEditBarShow = NO;
        [self editBarCanNotSee];
    }
    
    
    [[SGWPlayListTool sharedSGWPlayListTool]saveCurPlayListToDocument:@"locMusicList.data"];
}




#pragma mark - 通知移除，防止内存泄漏
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startPlayMusic" object:nil];
}

#pragma mark - 加载自定义导航栏
-(void)setupNavBar {
    self.navigationItem.title = @"我的音乐";

    UIBarButtonItem *editItem = [UIBarButtonItem barButtonWithNormalItem:@"pencil-2x" andSelectedImage:@"pencil-2x" target:self action:@selector(showEditBar:)];
    
    UIBarButtonItem *lyricItem = [UIBarButtonItem barButtonWithNormalItem:@"musical-geci-2x" andSelectedImage:@"musical-geci-2x" target:self action:@selector(showLyricBar:)];
    
    NSArray *array = @[editItem,lyricItem];
    self.navigationItem.rightBarButtonItems = array;
    
}




-(void)showEditBar:(UIBarButtonItem *)item {
    
    _isEditBarShow = !_isEditBarShow;
    
    if (_isEditBarShow) {
        
        [self editBarCanSee];
        
    }else{
        
        [self editBarCanNotSee];
    }
}

-(void)editBarCanSee {
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = [SGWPlayBar sharedPlayBar].frame;
        frame.origin.y = frame.origin.y + 44;
        [SGWPlayBar sharedPlayBar].frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _editBar.frame;
            frame.origin.y = frame.origin.y - 44;
            _editBar.frame = frame;
        }];
        
    }];
}

-(void)editBarCanNotSee {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGRect frame = _editBar.frame;
        frame.origin.y = frame.origin.y + 44;
        _editBar.frame = frame;
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = [SGWPlayBar sharedPlayBar].frame;
            frame.origin.y = frame.origin.y - 44;
            [SGWPlayBar sharedPlayBar].frame = frame;
        }];
        
    }];
}
-(void)showLyricBar:(UIBarButtonItem *)item {
    NSLog(@"这里有歌词");
}


#pragma mark 设置编辑栏
-(void)setupEditBar{
    SGWEditBarItem * btn1 = [SGWEditBarItem editBarItemWithImage:@"loop-2x" title:@"模式" target:self action:@selector(modeSel:)];
    SGWEditBarItem * btn2 = [SGWEditBarItem editBarItemWithImage:@"allcheck-2x" title:@"全选" target:self action:@selector(allCheck:)];
    SGWEditBarItem * btn3 = [SGWEditBarItem editBarItemWithImage:@"reload-2x" title:@"加载" target:self action:@selector(loadLocList)];
    SGWEditBarItem * btn4 = [SGWEditBarItem editBarItemWithImage:@"trash-2x" title:@"删除" target:self action:@selector(deleteList)];
    
    NSArray * editItems = @[btn1, btn2, btn3, btn4];
    SGWEditBar * editBar = [SGWEditBar editBarWithItems:editItems];
    _editBar = editBar;
    
    
    CGRect tmpframe = editBar.frame;
    tmpframe.origin.x = 0;
    tmpframe.origin.y = [UIScreen mainScreen].bounds.size.height;
    //    NSLog(@"%lf",[UIScreen mainScreen].applicationFrame.size.height);
    editBar.frame = tmpframe;
    
    [self.view addSubview:editBar];
    _isEditBarShow = NO;
    
}


#pragma mark 模式选择
-(void)modeSel:(UIButton *)sender{
    NSLog(@"选择模式");
    
    [self showMenu:sender];  //开源代码集成
}


#pragma mark 全部选择
-(void)allCheck: (UIButton*)btn{
    btn.selected = !btn.selected;
    
    [[SGWPlayListTool sharedSGWPlayListTool]allCheck:btn.selected];
    [_tableView reloadData];
}

#pragma mark 加载本地音乐
-(void)loadLocList{
//    NSLog(@"加载本地音乐");
    [[SGWPlayListTool sharedSGWPlayListTool] searchMyMusicList];
    [_tableView reloadData];
    
}

#pragma mark 删除
-(void)deleteList{
    [[SGWPlayListTool sharedSGWPlayListTool]deleteMusicList];
    [_tableView reloadData];
    
}



-(void)showMenu:(UIButton *)sender {
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"全部循环"
                     image:[UIImage imageNamed:@"loop-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"随机循环"
                     image:[UIImage imageNamed:@"random-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"顺序播放"
                     image:[UIImage imageNamed:@"seqence-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"单曲循环"
                     image:[UIImage imageNamed:@"loop-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    //修正显示位置
    CGRect frame = sender.frame;
    frame.origin.y = self.view.frame.size.height - sender.frame.size.height;
    [KxMenu setTintColor:[UIColor yellowColor]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(KxMenuItem*)sender
{
    NSLog(@"%@", sender);
    NSDictionary * dict = @{@"全部循环":@0, @"随机循环":@1,@"顺序播放":@2,@"单曲循环":@3};
    NSInteger index = [(NSString*)dict[sender.title] integerValue];
    [SGWPlayListTool sharedSGWPlayListTool].playMode = (PlayMode)index;
}


#pragma mark - 创建tableView
-(void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-108)];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    tableView.dataSource = self;
    tableView.delegate = self;
}



#pragma mark - 懒加载音乐播放列表
//-(NSMutableArray *)myMusicModelList {
//    if (_myMusicModelList == nil) {
//        _myMusicModelList = [NSMutableArray arrayWithPlist:@"myMusicList.plist"];
//        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
//        for (NSDictionary *dict in _myMusicModelList) {
//            SGWMusicModel *musicModel = [SGWMusicModel musicModelWithDictionary:dict];
//            [tempArray addObject:musicModel];
//        }
//        _myMusicModelList = tempArray;
//    }
//    return _myMusicModelList;
//}





#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.myMusicModelList.count;
    return [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGWMyMusicTableViewCell *cell = [SGWMyMusicTableViewCell myMusicTableViewCellWithTableView:tableView];
    
    cell.delegate = self;
    
    SGWMusicModel *musicModel = [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList[indexPath.row];

    cell.mymusicNameLabel.text = musicModel.name;
    
    //cell重复利用问题 begin
    cell.indexPath = indexPath;           //将indexPath值传到cell中
    
    cell.leftButton.selected = musicModel.willBeDelete;  //?????
    
    cell.rightButton.selected = musicModel.editBarShow;
    cell.editBar.hidden = !musicModel.editBarShow;  //编辑栏初始状态设置为隐藏
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    //1.获取歌曲资源名
//    SGWMusicModel *musicModel = self.myMusicModelList[indexPath.row];
//    NSString *musicName = [musicModel.name stringByAppendingString:@".mp3"];
//    
//    //2.通过路径获取歌曲
//    NSURL *url = [[NSBundle mainBundle]URLForResource:musicName withExtension:nil];
//    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    
//    //3.做一个播放缓存，然后进行歌曲播放
//    [_audioPlayer prepareToPlay];
//    [_audioPlayer play];
    
    [[SGWPlayerTool sharedSGWPlayerTool]playMusic:[SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList[indexPath.row]];
    
    if (_isEditBarShow == YES) {
        
        _isEditBarShow = NO;
        [self editBarCanNotSee];
    }

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGWMusicModel *model = [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList[indexPath.row];
    return model.iseditBarShow?(2*kHeightRatio*kScreenHeight):(kHeightRatio*kScreenHeight);
}



#pragma mark 我的音乐cell的代理方法，用于点击右侧按钮时刷新tableView
-(void)myMusicTableViewCell:(SGWMyMusicTableViewCell *)tableViewCell didUpDateTableView:(NSIndexPath *)indexPath {
    [_tableView reloadData];
//    SGWMusicModel *model = [SGWPlayListTool sharedSGWPlayListTool].myPlayMusicList[indexPath.row];
//    model.editBarShow = !model.editBarShow;
    
}





#pragma mark - 根据当前播放的歌曲切换到对应的cell
-(void)playMusicNotify:(NSNotification *)notify {
    
    //让tableview选中某一行，具体所在行由当前的歌曲决定，坐在组从0开始
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[SGWPlayListTool sharedSGWPlayListTool].curPlayMusicIndex inSection:0];
    
    //切换到指定行
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}



#pragma mark - 其他
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
