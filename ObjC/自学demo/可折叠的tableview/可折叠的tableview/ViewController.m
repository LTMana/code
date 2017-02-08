//
//  ViewController.m
//  可折叠的tableview
//
//  Created by 刘博通 on 16/12/8.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import "SenctionView.h"
#import "SectionModel.h"
#import "CellModel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    [self.tableView registerClass:[SenctionView class] forHeaderFooterViewReuseIdentifier:@"header"];
  }


//懒加载
//- (NSMutableArray *)sectionData{
//    if (_sectionData == nil) {
//       
//        _sectionData = [[NSMutableArray alloc]init];
//        for (int i=0; i<20; i++) {
//            SectionModel *model = [[SectionModel alloc]init];
//            model.title = [NSString stringWithFormat:@"%d",i];
//            model.isExpand = NO;
//            NSMutableArray *array = [[NSMutableArray alloc]init];
//            for (int j=0; j<10; j++) {
//                CellModel *cell = [[CellModel alloc]init];
//                cell.title = [NSString stringWithFormat:@"LivenCell==Section:%d,Row:%d",i,j];
//                [array addObject:cell];
//            }
//            model.cellArray = array;
//            [_sectionData addObject:model];
//        }
//    }
//    return _sectionData;
//    
//}


- (NSMutableArray *)sectionData{
    if (_sectionData == nil) {
        
        NSArray *fileArr =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sesion" ofType:@"plist"] ];
        
        _sectionData = [[NSMutableArray alloc]init];
        for (int i=0; i<fileArr.count; i++) {
            NSDictionary *tep = fileArr[i];
            SectionModel *model = [[SectionModel alloc]init];
            model.title = tep[@"title"];
            model.isExpand = NO;
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            NSArray *tmp =tep[@"cellArry"];

            for (int j=0; j<tmp.count; j++) {
                CellModel *cell = [[CellModel alloc]init];
                cell.title = tmp[j];
                [array addObject:cell];
            }
            model.cellArray = array;
            
            [_sectionData addObject:model];
        }
    }
    return _sectionData;
    
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SectionModel *model = _sectionData[section];
    return model.isExpand?model.cellArray.count:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    NSLog(@"section:%ld,row:%ld",(long)indexPath.section,(long)indexPath.row);
    SectionModel *section = _sectionData[indexPath.section];
    CellModel *model = section.cellArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SenctionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    SectionModel *model = _sectionData[section];
    view.model = model;
    //更变了section的cell数量，所以要刷新
    view.block = ^(BOOL isExpanded){
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    };
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
