//
//  ClearToolBar.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-20.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "ClearToolBar.h"

@implementation ClearToolBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clearsContextBeforeDrawing = YES;
}


@end
