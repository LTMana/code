//
//  RankingTableViewCell.m
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "RankingTableViewCell.h"

@implementation RankingTableViewCell
@synthesize NameLabel,IndexLabel;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
