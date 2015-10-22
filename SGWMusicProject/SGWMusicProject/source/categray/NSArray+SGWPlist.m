//
//  NSArray+SGWPlist.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/18.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "NSArray+SGWPlist.h"

@implementation NSArray (SGWPlist)
+(instancetype)arrayWithPlist:(NSString *)plistName {
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:plistName withExtension:nil];
    NSArray *array = [NSArray arrayWithContentsOfURL:url];
    return array;
}

@end
