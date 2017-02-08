//
//  MapIndexViewController.h
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-16.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNMKMapView.h"
#import "ToolClass.h"
#import "AppDelegate.h"
@interface MapIndexViewController : UIViewController<getCityRankingDelegate,CNMKMapViewDelegate,NoteCBDelegate>
{
   
    //CNMKMapView* _indexmapView;
    NSMutableArray *Ranking_Array;
    NSArray *cities;
}

@property (strong, nonatomic) CNMKMapView* indexmapView;
@end
