//
//  DataRequestAndHandling.h
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-11-3.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "SBJson.h"
#import "CityListInfo.h"

//主页城市列表
@protocol getCityListDelegate <NSObject>
- (void)getCityListDidSuccess:(NSArray*)array;
- (void)getCityListDidFailed:(NSString*)mes;
@end


//主页城市天气信息
@protocol getCityListWeatherInfoDelegate <NSObject>
- (void)getCityListWeatherInfoSuccess:(NSArray *)array;
- (void)getCityListWeatherInfoFail:(NSString *)mes;
@end

//单个城市信息
@protocol getSingleCityInfoDelegate <NSObject>
- (void)getSingleCityInfoSuccess:(CityListInfo *)info;
- (void)getSingleCityInfoFail:(NSString *)mes;

@end

//城市排行
@protocol getCityRankingDelegate <NSObject>
- (void)getCityRankingDidSuccess:(NSArray*)array;
- (void)getCityRankingDidFailed:(NSString*)mes;
@end

//每日指数
@protocol getDayIndexDelegate <NSObject>
- (void)getDayIndexSuccess:(NSArray*)array;
- (void)getDayIndexFailed:(NSString*)mes;
@end

//每月指数
@protocol getMonthIndexDelegate <NSObject>
- (void)getMonthIndexSuccess:(NSArray*)array;
- (void)getMonthIndexFailed:(NSString*)mes;
@end

//每年指数
@protocol getYearIndexDelegate <NSObject>
- (void)getYearIndexSuccess:(NSArray*)array;
- (void)getYearIndexFailed:(NSString*)mes;
@end

//行政区排名
@protocol getDistanceRankingDelegate <NSObject>
- (void)getDistanceRankingSuccess:(NSArray *)array;
- (void)getDistanceRankingFail:(NSString *)mes;
@end

//热点区域排名
@protocol getHotspotRankingDelegate <NSObject>
- (void)getHotspotRankingSuccess:(NSArray *)array;
- (void)getHotspotRankingFail:(NSString *)mes;
@end

//道路排名
@protocol getRoadRankingDelegate <NSObject>
- (void)getRoadRankingSuccess:(NSArray *)array;
- (void)getRoadRankingFail:(NSString *)mes;
@end

//单条道路
@protocol getSingleRoadRankingDelegate <NSObject>
- (void)getSingleRoadSuccess:(NSArray *)array;
- (void)getSingleRoadFail:(NSString *)mes;
@end

//道路类型指数
@protocol getRoadTypeIndexDelegate <NSObject>
- (void)getRoadTypeIndexSuccess:(NSArray *)array;
- (void)getRoadTypeIndexFail:(NSString *)mes;
@end

@interface DataRequestAndHandling : NSObject

@property (nonatomic, retain) SBJsonParser *SBJson;
@property (nonatomic, retain) ASINetworkQueue *networkQueue;
@property (nonatomic, retain) NSArray *cities;
@property (nonatomic, assign) NSUInteger CityCount;                    //城市数量
@property (nonatomic, retain) NSMutableArray *CityWeatherInfo;

@property (nonatomic, retain) ASIFormDataRequest *CityListRequest;      //主页城市列表
@property (nonatomic, retain) ASIFormDataRequest *SingleCityInfoRequest; //单个城市信息
@property (nonatomic, retain) ASIFormDataRequest *CityRankingRequest;   //城市排行
@property (nonatomic, retain) ASIHTTPRequest *CItyListWeatherRequest;   //城市天气
@property (nonatomic, retain) ASIFormDataRequest *DayIndexRequest;      //每天指数
@property (nonatomic, retain) ASIFormDataRequest *MonthIndexRequest;    //每月指数
@property (nonatomic, retain) ASIFormDataRequest *YearIndexRequest;     //每年指数
@property (nonatomic, retain) ASIFormDataRequest *DistanceRankingRequest; //行政区排行
@property (nonatomic, retain) ASIFormDataRequest *HotspotRankingRequest; //行政区排行
@property (nonatomic, retain) ASIFormDataRequest *RoadRankingRequest; //道路排行
@property (nonatomic, retain) ASIFormDataRequest *SingleRoadRankingRequest; //单条道路排行
@property (nonatomic, retain) ASIFormDataRequest *RoadTypeIndexRequest; //各道路类型指数


//
@property (nonatomic, retain) id<getCityListDelegate> CityList_delegate;
@property (nonatomic, retain) id<getSingleCityInfoDelegate>SingleCityInfo_delegate;
@property (nonatomic, retain) id<getCityRankingDelegate> CityRanking_delegate;
@property (nonatomic, retain) id<getCityListWeatherInfoDelegate>CityListWeather_delegate;
@property (nonatomic, retain) id<getDayIndexDelegate>DayIndex_delegate;
@property (nonatomic, retain) id<getMonthIndexDelegate>MonthIndex_delegate;
@property (nonatomic, retain) id<getYearIndexDelegate>YearIndex_delegate;
@property (nonatomic, retain) id<getDistanceRankingDelegate>DistanceRanking_delegate;
@property (nonatomic, retain) id<getHotspotRankingDelegate>HotspotRanking_delegate;
@property (nonatomic, retain) id<getRoadRankingDelegate>RoadRanking_delegate;
@property (nonatomic, retain) id<getSingleRoadRankingDelegate>SingleRoadRanking_delegate;
@property (nonatomic, retain) id<getRoadTypeIndexDelegate>RoadTypeIndex_delegate;

//开启请求队列
- (void)StartRequestQueue;

- (void)doRequest_CityList:(NSDictionary *)params;
- (void)doRequest_SingleCityInfo:(NSDictionary *)params;
- (void)doRequest_CityRanking:(NSDictionary *)params;
- (void)doRequest_CityListWeather:(NSDictionary *)params;
- (void)doRequest_DayIndex:(NSDictionary *)params;
- (void)doRequest_MonthIndex:(NSDictionary *)params;
- (void)doRequest_YearIndex:(NSDictionary *)params;
- (void)doRequest_DistanceRanking:(NSDictionary *)params;
- (void)doRequest_HotspotRanking:(NSDictionary *)params;
- (void)doRequest_RoadRanking:(NSDictionary *)params;
- (void)doRequest_SingleRoadRanking:(NSDictionary *)params;
- (void)doRequest_RoadTypeIndex:(NSDictionary *)params;
@end
