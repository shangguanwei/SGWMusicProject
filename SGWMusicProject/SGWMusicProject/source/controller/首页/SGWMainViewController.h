//
//  SGWMainViewController.h
//  SGWMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGWMainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
- (IBAction)userMessage:(UIButton *)sender;
- (IBAction)userLogin:(UIButton *)sender;
- (IBAction)userSignin:(UIButton *)sender;
- (IBAction)userSwitch:(UISwitch *)sender;

- (IBAction)myMusic:(UIButton *)sender;
- (IBAction)netMusic:(UIButton *)sender;
- (IBAction)moreFunction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *selectMyMusic;
@property (weak, nonatomic) IBOutlet UIImageView *selectNetMusic;
@property (weak, nonatomic) IBOutlet UIImageView *selectMoreFunction;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *cellListMutableArray;
@property (strong,nonatomic) UITableViewCell *currentCell;

@end
