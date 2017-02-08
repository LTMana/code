//
//  LTView.m
//  MVVMDEMO
//
//  Created by 刘博通 on 16/11/14.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "LTView.h"
#import "LTViewModel.h"
#import "LTTableViewCell.h"

@interface LTView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

/** VIewModel */
@property (nonatomic ,strong) LTViewModel *viewModel;

@end


@implementation LTView


-(instancetype)initWithViewModel:(id<ViewModelProtocol>)viewModel
{
    self.viewModel = (LTViewModel *)viewModel;
    
    return [super initWithViewModel:viewModel];
}

-(void)lt_setupViews
{
    [self addSubview:self.tableView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)lt_bindViewModel
{
    [self.viewModel.refreshDataCommand execute:nil];
     @weakify(self)
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        @strongify(self)
        
        [self.tableView reloadData];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        
        switch ([x integerValue]) {
            case LSHeaderRefresh_HasMoreData:
                
                [self.tableView.mj_header endRefreshing];
                if (!self.tableView.mj_footer) {
                    self.tableView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        @strongify(self)
                        
                        [self.viewModel.refreshDataCommand execute:nil];
                    }];
                }
                break;
            case LSHeaderRefresh_HasNoMoreData:
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer = nil;
               
                break;
            case LSFooterRefresh_HasMoreData:
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
                [self.tableView.mj_footer endRefreshing];
                
                break;
            case LSFooterRefresh_HasNoMoreData:
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
                break;
             case LSRefreshError:
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                
                
                break;
            default:
                break;
        }
        
        
    }];
    
    
}

-(void)updateConstraints
{
    WS(weakself)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
    [super updateConstraints];
}

#pragma mark - delegate

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LTTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LTTableViewCell class]) forIndexPath:indexPath];
    
    if (self.viewModel.dataArray.count >indexPath.row) {
        cell.model = self.viewModel.dataArray[indexPath.row];
        
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel.cellClickSubject sendNext:nil];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LTTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LTTableViewCell class])];
        
        WS(weakSelf);
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        
         _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         
              [weakSelf.viewModel.refreshDataCommand execute:nil];
         
         }];
        
    }
    
    return _tableView;
}

@end
