//
//  LTViewController.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "LTViewController.h"
#import "LTView.h"
#import "LTViewModel.h"

@interface LTViewController ()

@property (nonatomic, strong)  LTView      *mainView;
@property (nonatomic, strong)  LTViewModel *viewModel;

@end



@implementation LTViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - private

-(void)lt_addSubviews
{
    [self.view addSubview:self.mainView];
}

//导航栏标题
- (void)lt_layoutNavigation
{
    self.title = @"电影列表";
}




-(void)lt_bindViewModel
{
     @weakify(self);
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
         @strongify(self);
        ViewController *viewController = [[ViewController alloc]init];
         viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
          [self.navigationController pushViewController:viewController animated:YES];
    }];
    
}


-(void)updateViewConstraints
{
    WS(weakSelf)
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
        
    }];
    
    [super updateViewConstraints];

}


#pragma mark - layzLoad －－



- (LTView *)mainView {
    
    if (!_mainView) {
        
        _mainView = [[LTView alloc] initWithViewModel:self.viewModel];
    }
    
    return _mainView;
}


- (LTViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[LTViewModel alloc] init];
    }
    
    return _viewModel;
}

@end
