//
//  SGWNavigationController.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "SGWNavigationController.h"
#import "SGWPlayBar.h"
#import "UIView+SGWMoreAttribute.h"

@interface SGWNavigationController ()

@end

@implementation SGWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载播放栏至导航控制器
    [self setupPlayBar];
    
    
    [SGWPlayBar sharedPlayBar].frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44);
    [self.view bringSubviewToFront:[SGWPlayBar sharedPlayBar]];
    
    //自定义导航栏设置
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"arrow-thick-left-2x"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"arrow-thick-left-2x"];
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
}

#pragma mark 导航控制器下端加一个playbar，切换到其他控制器中时也能够显示
-(void)setupPlayBar{
    SGWPlayBar * playBar = [SGWPlayBar sharedPlayBar];
    
    CGFloat w = playBar.bounds.size.width;
    CGFloat h = 44;
    CGFloat x = 0;
    CGFloat y = self.view.height - h;
    
    playBar.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:playBar];
}



-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //调用父类方法
    [super pushViewController:viewController animated:animated];
    
    if (self.topViewController != self.viewControllers[0]) {
        self.navigationBar.hidden = NO;
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
