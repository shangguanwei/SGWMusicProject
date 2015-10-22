//
//  AppDelegate.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "AppDelegate.h"
#import "UIViewController+SGWStoryBoard.h"
#import "SGWPlayListTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //版本信息判断，根据版本号判断是否启动新特性
    [self startNewFVControllerByVerson];
    
    
    //搜索并创建所有本地音乐列表
    [self searchAllMyMusicList];
    
    
    return YES;
}

-(void)searchAllMyMusicList {
    [[SGWPlayListTool sharedSGWPlayListTool]searchMyMusicList];
}


#pragma mark -根据版本号判断是否启动新特性
-(void)startNewFVControllerByVerson {
    //1.取得旧版本信息
    NSString *oldBundleVerson = [[NSUserDefaults standardUserDefaults]valueForKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"oldBundleVerson is %@",oldBundleVerson );
    //2.取得新版本信息
    NSDictionary *infonDict = [[NSBundle mainBundle]infoDictionary]; //取得info.plist
    NSString *bundleVersion = [infonDict objectForKey:(NSString*)kCFBundleVersionKey];
    NSLog(@"bundleVersion is %@",bundleVersion );
    //3.版本变化启动新特性界面
    if (![oldBundleVerson isEqualToString:bundleVersion]) {
        UIViewController *newVerson = [UIViewController viewControllerWithStoryBoardID:@"SGWNewFeatureViewController1"];
        self.window.rootViewController = newVerson;
        
        //保存
        [[NSUserDefaults standardUserDefaults]setValue:bundleVersion forKey:(NSString *)kCFBundleVersionKey];
        //同步
        [[NSUserDefaults standardUserDefaults]synchronize];

    }
    else {
//        UIViewController *main = [UIViewController viewControllerWithStoryBoardID:@"SGWNavigationController1"];
//        self.window.rootViewController = main;
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nav = [storyBoard instantiateViewControllerWithIdentifier:@"SGWNavigationController1"];
        self.window.rootViewController = nav;
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
