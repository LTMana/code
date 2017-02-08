//
//  SenctionView.h
//  可折叠的tableview
//
//  Created by 刘博通 on 16/12/8.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectionModel;
typedef void(^CallBackBlock)(BOOL);
@interface SenctionView : UITableViewHeaderFooterView

@property (nonatomic,strong) SectionModel *model;
@property (nonatomic,strong) CallBackBlock block;

@end
