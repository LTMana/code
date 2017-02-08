//
//  PartOneViewController.m
//  ModuleOne
//
//  Created by Yes-Cui on 16/8/4.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "PartOneViewController.h"
#import <testMoudle2/ModuleTwoInterface.h>

@interface PartOneViewController ()

@property (nonatomic,weak) IBOutlet UIImageView *imageView;

@end

@implementation PartOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [ModuleTwoInterface iconImage];
    
    // Do any additional setup after loading the view.
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPartTwoPage{
    UIViewController *twoVC = [ModuleTwoInterface showModuleTwoVC];
    [self.navigationController pushViewController:twoVC animated:YES];
}

- (void)notice:(id)notice{
    NSLog(@"tongzhi:%@",notice);
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
