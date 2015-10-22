//
//  UIViewController+SGWStoryBoard.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIViewController+SGWStoryBoard.h"

@implementation UIViewController (SGWStoryBoard)
+(instancetype)viewControllerWithStoryBoardID:(NSString *)storyBoardID {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:storyBoardID];
    return vc;
}

@end
