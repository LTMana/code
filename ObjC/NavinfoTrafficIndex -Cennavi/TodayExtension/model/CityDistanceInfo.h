//
//  CityDistanceInfo.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistanceInfo.h"
#import "SBJson.h"
@interface CityDistanceInfo : NSObject


@property(nonatomic,retain)NSString *cName;
@property(nonatomic,retain)NSString *code;
@property(nonatomic,retain)NSString *weatherCode;
@property(nonatomic,assign)Coordinate2D coordinate;
@property(nonatomic,retain)NSArray *list;  //行政区列表


+ (NSArray *)getCityListInfo;
@end
