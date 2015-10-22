//
//  UIView+SGWMoreAttribute.m
//  SGWMusicProject
//
//  Created by neuedu on 15/9/15.
//  Copyright (c) 2015年 neuedu. All rights reserved.
//

#import "UIView+SGWMoreAttribute.h"

@implementation UIView (SGWMoreAttribute)
-(CGFloat)width {
    return self.frame.size.width;
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)left {
    return self.frame.origin.x;
}

-(CGFloat)top {
    return self.frame.origin.y;
}

-(CGFloat)buttom {
    return self.frame.origin.y + self.frame.size.height;
}

@end
