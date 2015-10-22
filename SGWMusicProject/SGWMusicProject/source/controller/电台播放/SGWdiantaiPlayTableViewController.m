//
//  SGWdiantaiPlayTableViewController.m
//  SGWMusicProject
//
//  Created by neuedu on 15/10/20.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWdiantaiPlayTableViewController.h"
#import "SGWdiantaiChannel.h"
#import "AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "SGWMusicModel.h"
#import "UIImageView+WebCache.h"
#import "SGWPlayerTool.h"
#import "SGWPlayListTool.h"

#define kSongListURL @"http://www.douban.com/j/app/radio/people"

@interface SGWdiantaiPlayTableViewController () {
    NSMutableArray *_diantaiMusics;
}

@end

@implementation SGWdiantaiPlayTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = _channel.name;
    _diantaiMusics = [[NSMutableArray alloc]init];
    
    //系统下拉刷新函数
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    self.refreshControl = refresh;
    
    [refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
}

-(void)refreshAction {
    [self webRequest];
    [self.refreshControl endRefreshing];
}


-(void)viewWillAppear:(BOOL)animated {
    
    //接收新播放歌曲的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusicNotify:) name:@"startPlayMusic" object:nil];
    
    //音乐播放来源修改为电台
    [SGWPlayerTool sharedSGWPlayerTool].musicSource = kmusicSourceDiantai;
    [self webRequest];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [SGWPlayerTool sharedSGWPlayerTool].musicSource = kmusicSourceLocal;
    
    //移除播放音乐的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - //2.接受新的播放歌曲的通知，并作处理
-(void)playMusicNotify:(NSNotification *)notify {
    
    //让tableview选中某一行，具体所在行由当前的歌曲决定，坐在组从0开始
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[SGWPlayListTool sharedSGWPlayListTool].curPlayMusicIndex inSection:0];
    
    //切换到指定行
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}


//网络请求
-(void)webRequest {
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"app_name":@"radio_desktop_win",
                                 @"version":@100,
                                 @"channel":_channel.channel_id,
                                 @"type":@"n"
                                 };
    
    [manage GET:kSongListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject[@"song"]);
        NSArray *tempArray = responseObject[@"song"];
        [tempArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            SGWMusicModel *model = [SGWMusicModel diantaiMusicModelWithDictionary:dict];
            [_diantaiMusics addObject:model];
        }];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIAlertView showAlertViewForRequestOperationWithErrorOnCompletion:operation delegate:self];
    }];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _diantaiMusics.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"diantaiplay";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    SGWMusicModel *model = _diantaiMusics[indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.singer;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"歌曲被选中");
    [[SGWPlayerTool sharedSGWPlayerTool] playMusic:_diantaiMusics[indexPath.row]];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
