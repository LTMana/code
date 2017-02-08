//
//  HomeListViewController.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-18.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "httpRequest.h"
#import "SBJson.h"
#import "CityListInfo.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeListViewController : UIViewController<CLLocationManagerDelegate,getCityListDelegate,getCityListWeatherInfoDelegate,getSingleCityInfoDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    httpRequest *http;
    SBJsonParser *SBJson;
    CityListInfo *CurCityInfo;
    BOOL isSingleCity;
    BOOL isToEditView;
    MJRefreshBaseView *refreshHeaderView;
    CLLocationManager *locationManager;
   
}
@property (strong, nonatomic) UITableView *MenuTable;

@property(nonatomic,retain)NSMutableArray *CityList;

//+ (NSString *)IndexToStatue:(NSString *)CityIndex;
@end
