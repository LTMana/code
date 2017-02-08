//
//  ToolClass.h
//  TrafficIndex
//
//  Created by Mickey on 14-9-4.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DeepGreen   [UIColor colorWithRed:104.0/255 green:200.0/255 blue:19.0/255 alpha:1]
#define lightGreen  [UIColor colorWithRed:61.0/255 green:206.0/255 blue:86.0/255 alpha:1]
#define yellow      [UIColor colorWithRed:191.0/255 green:206.0/255 blue:61.0/255 alpha:1]
#define Deepyellow  [UIColor colorWithRed:219.0/255 green:128.0/255 blue:38.0/255 alpha:1]
#define lightRed    [UIColor colorWithRed:254.0/255 green:59.0/255 blue:48.0/255 alpha:1]
#define DeepRed     [UIColor colorWithRed:148.0/255 green:12.0/255 blue:50.0/255 alpha:1]


@interface ToolClass : NSObject

//定义指数状态
+ (NSString *)IndexToStatue:(NSString *)CityIndex;

//定义指数颜色
+(UIColor *)IndexToColor:(NSString *)Index;

//NSString 转换成NSDate
+ (NSDate *)DateFromString:(NSString *)string;

//转换时间格式为yyyyMMdd
+ (NSString *)stringFromDate:(NSDate *)date;

//转换时间格式为yyyy年MM月dd日
+ (NSString *)stringFromDate_YYYY_MM_DD:(NSDate *)date;

//转换时间格式为yyyy-MM-dd HH:mm
+ (NSString *)stringFromDate_YYYY_MM_DD_HH_MM:(NSDate *)date;

//根据日期获取当前月初，月末日期
+ (NSString *)MonthStartToMonthEnd:(NSDate *)date;

////转换为百度坐标
//+ (CLLocationCoordinate2D )TranslateGpsToBaidu:(CLLocationCoordinate2D )coor;

//获取plist path
+ (NSString *)getDocument:(NSString *)fileName;

//存储到plist
+ (void)saveToPlist:(NSString *)fileName :(id)arrayOrDic;

////UIView转换成UIImage  百度地图自定义大头针用
//+(UIImage *)getImageFromView:(UIView *)view;
//
////UIview截图
//+ (UIImage *)ViewToImage:(UIView *)view;
@end
