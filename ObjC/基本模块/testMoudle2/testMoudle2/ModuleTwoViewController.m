//
//  ModuleTwoViewController.m
//  ModuleTwo
//
//  Created by Yes-Cui on 16/8/4.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "ModuleTwoViewController.h"

@implementation ModuleTwoViewController

- (void)viewDidLoad{
    [super viewDidLoad];    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil userInfo:@{@"1":@"123"}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

@end
