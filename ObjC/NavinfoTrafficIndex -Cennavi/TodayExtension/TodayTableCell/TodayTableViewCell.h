//
//  TodayTableViewCell.h
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-12-15.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *IndexLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end
