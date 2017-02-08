//
//  IndexRangkingViewController.h
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-16.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolClass.h"
#import "AppDelegate.h"
#import "RankingTableViewCell.h"
@interface IndexRangkingViewController : UIViewController<getCityRankingDelegate>
{
    
    NSMutableArray *Ranking_Array;
    NSArray *cities;
}

@end
