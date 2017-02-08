//
//  CityListInfo.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-18.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CityListInfo : NSObject
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *location;   //在数组中位置信息
@property(nonatomic,retain)NSString *code;
@property(nonatomic,retain)NSString *weatherCode; //查询天气城市ID
@property(nonatomic,retain)NSString *index;
@property(nonatomic,retain)NSString *speed;
@property(nonatomic,retain)NSString *statue;
@property(nonatomic,retain)NSString *time;
@property(nonatomic,retain)UIColor *color;
@property(nonatomic,retain)NSString *Json;   //当前城市返回数据Json  Detail页面用到
@property(nonatomic,retain)NSString *temperature;
@property(nonatomic,retain)NSString *weatherType;
@end
