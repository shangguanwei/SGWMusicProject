//
//  SGWMainViewController.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWMainViewController.h"
#import "UIViewController+SGWStoryBoard.h"

//区别不同模式的枚举类型
typedef enum musicMode
{
    musicModeLocal,
    musicModeNet,
    musicModeMore
    
}musicMode;


@interface SGWMainViewController () {
    musicMode _mode;
}

@end

@implementation SGWMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationController.navigationBarHidden = YES;  //隐藏navigationBar
    
    [self setIndicator];
    [self setMyMusicCell];

    
    //只显示既定cell的下划线
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//主页控制器显示时隐藏导航栏
-(void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}




#pragma mark - 设置指示器的实现
-(void)setIndicator {
    self.selectMyMusic.hidden = NO;
    self.selectNetMusic.hidden = YES;
    self.selectMoreFunction.hidden = YES;
}



#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellListMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //storyBoard中cell的ID来加载cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    cell.textLabel.text =_cellListMutableArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.将已经选中cell变成白色
    if (_currentCell != nil) {
        _currentCell.textLabel.textColor = [UIColor whiteColor];
    }
    
    //2.将当前选中项变成黄色
    UITableViewCell *selectcell = [tableView cellForRowAtIndexPath:indexPath];
    selectcell.textLabel.textColor = [UIColor yellowColor];
    _currentCell = selectcell;
    
    //3.更新选中项
    switch (_mode) {
        case musicModeLocal:
            [self handleMyMusic:indexPath.row];
            break;
        case musicModeNet:
            [self handleNetMusic:indexPath.row];
            break;
        case musicModeMore:
            [self handleMoreFunc:indexPath.row];
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark - 界面迁移
-(void)handleMyMusic:(NSInteger)row {    //本地音乐界面的切换
    switch (row) {
        case 0:
        {
            //切换到本地音乐
            UIViewController *myvc = [UIViewController viewControllerWithStoryBoardID:@"SGWMyMusicViewController1"];
            [self.navigationController pushViewController:myvc animated:YES];
            break;
        }
        case 1:
            NSLog(@"我喜欢");
            break;
        case 2:
            NSLog(@"收藏列表");
            break;
        case 3:
            NSLog(@"下载管理");
            break;
        case 4:
            NSLog(@"最近播放");
            break;
        default:
            break;
    }
    
}


-(void)handleNetMusic:(NSInteger)row {     //网络音乐界面的切换
    switch (row) {
        case 0:
        {
            //切换到歌手搜索
            UIViewController *myvc = [UIViewController viewControllerWithStoryBoardID:@"SGWNetMusicViewController1"];
            [self.navigationController pushViewController:myvc animated:YES];
            //[self performSegueWithIdentifier:@"main2net" sender:self];
//            NSLog(@"歌手");
            break;
        }
        case 1:
//            NSLog(@"电台");
            [self performSegueWithIdentifier:@"main2diantai" sender:self];
            break;
        default:
            break;
    }
    
}


-(void)handleMoreFunc:(NSInteger)row {
    NSLog(@"更多功能。。。");
    
}




#pragma mark - 按钮点击相应事件
- (IBAction)userMessage:(UIButton *)sender {
}

- (IBAction)userLogin:(UIButton *)sender {
}

- (IBAction)userSignin:(UIButton *)sender {
}

- (IBAction)userSwitch:(UISwitch *)sender {
}

- (IBAction)myMusic:(UIButton *)sender {
    _mode = musicModeLocal;
    
    self.selectMyMusic.hidden = NO;
    self.selectNetMusic.hidden = YES;
    self.selectMoreFunction.hidden = YES;
    [self setMyMusicCell];
    [self.tableView reloadData]; //界面刷新
}

- (IBAction)netMusic:(UIButton *)sender {
    _mode = musicModeNet;
    
    self.selectMyMusic.hidden = YES;
    self.selectNetMusic.hidden = NO;
    self.selectMoreFunction.hidden = YES;
    [self setNetMusicCell];
    [self.tableView reloadData]; //界面刷新
    
}

- (IBAction)moreFunction:(UIButton *)sender {
    _mode = musicModeMore;
    
    self.selectMyMusic.hidden = YES;
    self.selectNetMusic.hidden = YES;
    self.selectMoreFunction.hidden = NO;
    [self setMoreFunctionCell];
    [self.tableView reloadData];
}


- (IBAction)switch:(UISwitch *)sender {
}



#pragma mark - cell设置
//myMusic中的cell设置
-(void)setMyMusicCell {
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"myMusicCellList.plist" withExtension:nil];
    NSArray *myMusicListArray = [NSArray arrayWithContentsOfURL:url];
    _cellListMutableArray = (NSMutableArray *)myMusicListArray;
}


//netMusic中的cell设置
-(void)setNetMusicCell {
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"netMusicCellList.plist" withExtension:nil];
    NSArray *netMusicListArray = [NSArray arrayWithContentsOfURL:url];
    _cellListMutableArray = (NSMutableArray *)netMusicListArray;
}

//netMusic中的cell设置
-(void)setMoreFunctionCell {
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"moreFunctionCellList.plist" withExtension:nil];
    NSArray *moreFunctionListArray = [NSArray arrayWithContentsOfURL:url];
    _cellListMutableArray = (NSMutableArray *)moreFunctionListArray;
}






@end
