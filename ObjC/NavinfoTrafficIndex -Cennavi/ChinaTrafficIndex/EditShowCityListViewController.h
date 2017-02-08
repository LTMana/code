//
//  EditShowCityListViewController.h
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-14.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityDistanceInfo.h"
#import "CityListInfo.h"

@interface EditShowCityListViewController : UIViewController
{
    
}
@property (nonatomic,retain) NSMutableArray *CityList;
@property (strong, nonatomic) CityListInfo *locCityInfo;     //定位城市

@end
