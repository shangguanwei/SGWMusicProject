//
//  SGWNewFeatureViewController.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWNewFeatureViewController.h"
#import "UIView+SGWMoreAttribute.h"
#import "SGWNavigationController.h"

#define kRation                   0.85
#define kStartButtonYRadio        0.80
#define kStartButtonWidthRadio    244/320
#define kStartButtonHeightRadio   64/568

@interface SGWNewFeatureViewController ()

@end

@implementation SGWNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView.delegate = self;
    
    [self setNewFeatureScrollView];
    [self setPageControlPosition];
}

#pragma mark - 设置新特性页面
-(void)setNewFeatureScrollView {
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"newFeature.plist" withExtension:nil];
    NSArray *newFeature = [NSArray arrayWithContentsOfURL:url];
    

    for (int i = 0; i < newFeature.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *imageStr = newFeature[i];
        imageView.frame = CGRectMake(i*self.view.width, 0, self.view.width, self.view.height);
        [imageView setImage:[UIImage imageNamed:imageStr]];
        
        if (i == newFeature.count - 1) {
            [self addStarButton:imageView];
        }
        
        [_scrollView addSubview:imageView];
        
    }
    _scrollView.contentSize = CGSizeMake(newFeature.count * self.view.width, self.view.height);
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    
}



#pragma mark -  自定义button，进入主页
-(void)addStarButton:(UIImageView *) imageView {
    UIButton *startButton = [[UIButton alloc]init];
    
    
    [startButton setImage:[UIImage imageNamed:@"introduction_enter_nomal"] forState:UIControlStateNormal];
    [startButton setImage:[UIImage imageNamed:@"introduction_enter_press"] forState:UIControlStateHighlighted];

    CGFloat startY = self.view.height * kStartButtonYRadio;
    CGFloat startW = self.view.width * kStartButtonWidthRadio;
    CGFloat startH = self.view.height * kStartButtonHeightRadio;
    CGFloat startX = (self.view.width - startW)/2;
    
    startButton.frame = CGRectMake(startX, startY, startW, startH);
    
    [startButton addTarget:self action:@selector(startMainView:) forControlEvents:UIControlEventTouchUpInside];
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:startButton];
}


#pragma mark - 开始主页
-(void)startMainView:(UIButton *)startButton {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SGWNavigationController *nav = [storyBoard instantiateViewControllerWithIdentifier:@"SGWNavigationController1"];
    self.view.window.rootViewController = nav;
}



#pragma mark - 设置pagecontrol
-(void)setPageControlPosition {
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"newFeature.plist" withExtension:nil];
    NSArray *newFeature = [NSArray arrayWithContentsOfURL:url];
    _pageControl.numberOfPages = newFeature.count;
    _pageControl.currentPage = 0;
    _pageControl.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height - 30, 0, 0);
    
}



#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = _scrollView.contentOffset.x/_scrollView.frame.size.width;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
