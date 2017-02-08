//
//  DetailViewController.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "CityListInfo.h"
#import "SBJson.h"
#import "ToolClass.h"
#import "httpRequest.h"
#import "MChartView.h"
#import "RankingTableViewCell.h"
#import "RankingInfo.h"
#import "CityDistanceInfo.h"
#import "ZSYPopoverListView.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "RMDateSelectionViewController.h"
#import "MBProgressHUD.h"
#import "RWBarChartView.h"
#import "CNMKMapView.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MChartViewDelegate,ZSYPopoverListDatasource, ZSYPopoverListDelegate,RMDateSelectionViewControllerDelegate,RWBarChartViewDataSource,getDayIndexDelegate,getMonthIndexDelegate,getYearIndexDelegate,getRoadRankingDelegate,getDistanceRankingDelegate,getHotspotRankingDelegate,getSingleRoadRankingDelegate,getRoadTypeIndexDelegate,CNMKMapViewDelegate,NoteCBDelegate>
{
    
    AppDelegate *_appDelegate;
    
    NSArray *cities;
  
    NSInteger page;   //道路排行的页数
    NSMutableArray *Rank_Array;
    NSMutableArray *AllRoad_Array;
    NSString *cityCode;
    
    NSMutableArray *Anns_Array;
    NSMutableArray *Overlays_Array;
    //滑动图标显示指数，数组
    NSMutableArray *DayArray;
    NSMutableArray *YearArray;
    NSMutableArray *MonthArray;

    ZSYPopoverListView *listView;
    
    NSMutableArray *RoadTypes;
    NSMutableDictionary *RoadType_statue;
    NSString *roadLevel;
    NSDate *selectDate;
    RMDateSelectionViewController *dateSelectionVC;
    MJRefreshBaseView *refreshView;
}
@property(nonatomic,retain)UIColor *roadColor;
@property(nonatomic,retain)CityListInfo *CurCityInfo;
@property(nonatomic,retain)NSMutableDictionary *singleItems;
@property(nonatomic,assign)BOOL TenMax;    //柱状图 Y轴最大值 Yes = 10   No = 20
@property(nonatomic,assign)NSInteger IndexMax;  //指数最大值
@end
