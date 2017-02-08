//
//  ViewController.m
//  MainWorkingPlace
//
//  Created by Yes-Cui on 16/8/24.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "ViewController.h"

#import <CommonModule/CommonPutLogs.h>
#import <ModuleOne/PartOneInterface.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonPutLogs sayHelloLogs];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPartOne:(id)sender{
    UIViewController *vc = [PartOneInterface showPartOneVC];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
