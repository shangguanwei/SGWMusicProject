//
//  SGWNetMusicViewController.m
//  SGWMusicProject
//
//  Created by neuedu on 15/10/19.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWNetMusicViewController.h"
#import "AFNetworking.h"
#import "SGWMusicModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#define kSearchMusicURL @"https://api.douban.com/v2/music/search"

@interface SGWNetMusicViewController () <UITableViewDataSource,UITabBarControllerDelegate,UISearchBarDelegate> {
    NSMutableArray *_netMusicListArray;
    NSString * _searchText;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SGWNetMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"歌手";
    
    _netMusicListArray = [NSMutableArray array];
    
    //上拉下拉刷新初始化
    [self setupRefresh];
    
    _searchText = @"周杰伦";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _netMusicListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"geshou";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    //data
    SGWMusicModel *model = _netMusicListArray[indexPath.row];
    
    //setting cell
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.singer;
    NSURL *url = [NSURL URLWithString:model.imgURL];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];
    
    return cell;
}



#pragma mark - SearchBar代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder]; //退出键盘
    
    if (_searchText != searchBar.text) {
        [_netMusicListArray removeAllObjects];  //数组元素置空
    }
    
    _searchText = searchBar.text;
    
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSString *start = [NSString stringWithFormat:@"%li",_netMusicListArray.count];
    NSDictionary *parameters = @{
                                 @"q":_searchText,
                                 @"start":start,
                                 @"count":@5
                                 };
    
    [manage GET:kSearchMusicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temparray = responseObject[@"musics"];
        [temparray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            //NSLog(@"歌曲名为%@",dict[@"title"]);
            //NSLog(@"图片为%@",dict[@"image"]);
            //NSLog(@"歌手为%@",dict[@"attrs"][@"singer"][0]);
            
            //网络音乐模型
            SGWMusicModel *model = [SGWMusicModel netMusicModelWithDictionary:dict];
            [_netMusicListArray addObject:model];
        }];
//        NSLog(@"歌手为%@",responseObject[@"musics"][0][@"attrs"][@"singer"][0]);
//        NSLog(@"歌曲为%@",responseObject[@"musics"][0][@"attrs"][@"title"][0]);
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}




/**
 *  集成刷新控件
 */
#pragma mark - 下拉，上拉刷新 (MJRefresh第三方框架使用)
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"MJ哥正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSString *start = [NSString stringWithFormat:@"%li",_netMusicListArray.count];
    NSDictionary *parameters = @{
                                 @"q":_searchText,
                                 @"start":start,
                                 @"count":@5
                                 };
    
    [manage GET:kSearchMusicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temparray = responseObject[@"musics"];
        [temparray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            //NSLog(@"歌曲名为%@",dict[@"title"]);
            //NSLog(@"图片为%@",dict[@"image"]);
            //NSLog(@"歌手为%@",dict[@"attrs"][@"singer"][0]);
            
            //网络音乐模型
            SGWMusicModel *model = [SGWMusicModel netMusicModelWithDictionary:dict];
            [_netMusicListArray addObject:model];
        }];
        //        NSLog(@"歌手为%@",responseObject[@"musics"][0][@"attrs"][@"singer"][0]);
        //        NSLog(@"歌曲为%@",responseObject[@"musics"][0][@"attrs"][@"title"][0]);
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)footerRereshing
{
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSString *start = [NSString stringWithFormat:@"%li",_netMusicListArray.count];
    NSDictionary *parameters = @{
                                 @"q":_searchText,
                                 @"start":start,
                                 @"count":@5
                                 };
    
    [manage GET:kSearchMusicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temparray = responseObject[@"musics"];
        [temparray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            //NSLog(@"歌曲名为%@",dict[@"title"]);
            //NSLog(@"图片为%@",dict[@"image"]);
            //NSLog(@"歌手为%@",dict[@"attrs"][@"singer"][0]);
            
            //网络音乐模型
            SGWMusicModel *model = [SGWMusicModel netMusicModelWithDictionary:dict];
            [_netMusicListArray addObject:model];
        }];
        //        NSLog(@"歌手为%@",responseObject[@"musics"][0][@"attrs"][@"singer"][0]);
        //        NSLog(@"歌曲为%@",responseObject[@"musics"][0][@"attrs"][@"title"][0]);
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}


@end
