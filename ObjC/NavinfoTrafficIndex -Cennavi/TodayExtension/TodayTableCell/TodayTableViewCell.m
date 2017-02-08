//
//  TodayTableViewCell.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-12-15.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "TodayTableViewCell.h"

@implementation TodayTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.colorView.layer.cornerRadius = 7.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
