//
//  ViewController.m
//  基本模块
//
//  Created by 刘博通 on 16/11/18.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import <共用模块/CommonPutLogs.h>
#import <testMoudle1/PartOneInterface.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonPutLogs sayHelloLogs];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)showPartOne:(id)sender{
    UIViewController *vc = [PartOneInterface showPartOneVC];
   
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
