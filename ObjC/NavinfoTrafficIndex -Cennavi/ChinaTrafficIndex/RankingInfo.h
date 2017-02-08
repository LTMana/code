//
//  RankingInfo.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistanceInfo.h"
@interface RankingInfo : NSObject
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *index;
@property(nonatomic,retain)NSString *RoadID;               //道路ID
@property(nonatomic,retain)NSString *kind;               //道路等级
@property(nonatomic,assign)Coordinate2D coordinate;        //行政区、热点区域中心点坐标
@end
