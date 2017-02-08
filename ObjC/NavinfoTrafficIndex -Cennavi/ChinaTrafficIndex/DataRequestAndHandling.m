//
//  DataRequestAndHandling.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-11-3.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "DataRequestAndHandling.h"
#import "CityDistanceInfo.h"
#import "CityListInfo.h"
#import "ToolClass.h"
#import "RankingInfo.h"
#define TIMEOUTSEC 30

@implementation DataRequestAndHandling

- (void)StartRequestQueue
{
    
    [self InitJsonParse];
    [self setNetworkQueue:[ASINetworkQueue queue]];
    [[self networkQueue] setDelegate:self];
    [[self networkQueue] setRequestDidFinishSelector:@selector(requestFinishedByQueue:)];
    [[self networkQueue] setRequestDidFailSelector:@selector(requestFailedByQueue:)];
    [[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    [[self networkQueue] setShouldCancelAllRequestsOnFailure:NO ];//取消一个请求不会取消队列中的所有请求
    [self networkQueue].maxConcurrentOperationCount = 3;//同时最多进行3个请求
    [[self networkQueue] go];
}

- (void)InitJsonParse
{
    self.cities = [CityDistanceInfo getCityListInfo];
    self.SBJson = [[SBJsonParser alloc]init];
}

- (NSString *)getCityNameByCode:(NSString *)code
{
    for (CityDistanceInfo *info in self.cities)
    {
        if ([info.code isEqualToString:code])
        {
            return info.cName;
        }
    }
    
    return nil;
}
- (NSArray *)getCurcityDistanceList:(NSString *)cityName
{
    for (CityDistanceInfo *info in self.cities)
    {
        if ([info.cName isEqualToString:cityName])
        {
            return info.list;
        }
    }
    return nil;
}
- (NSString *)IndexToStatue:(NSString *)CityIndex
{
    
    float index = [CityIndex floatValue];
    
    if (index < 2)
    {
        return @"畅通";
        
    }
    else if(index <4 && index >= 2)
    {
        return @"基本畅通";
        
        
    }
    else if(index<7 && index >=4)
    {
        return @"缓慢";
        
    }
    else if (index <10 && index>=7)
    {
        return @"拥堵";
    }
    else if (index <18 && index>=10)
    {
        return @"严重拥堵";
    }
    else
    {
        return @"路网瘫痪";
        
    }
    
}


#pragma mark DoRequest
- (void)doRequest_CityList:(NSDictionary *)params
{
   
    self.CityListRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.CityListRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    [self.CityListRequest setUsername:@"CityList"];
    [self.CityListRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.CityListRequest];
}

- (void)doRequest_SingleCityInfo:(NSDictionary *)params
{
    
    self.SingleCityInfoRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.SingleCityInfoRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    [self.SingleCityInfoRequest setUsername:@"SingleCityInfo"];
    [self.SingleCityInfoRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.SingleCityInfoRequest];
}

- (void)doRequest_CityRanking:(NSDictionary *)params
{
    self.CityRankingRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.CityRankingRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    [self.CityRankingRequest setUsername:@"CityRanking"];
    [self.CityRankingRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.CityRankingRequest];
}

- (void)doRequest_CityListWeather:(NSDictionary *)params
{
    
    self.CityCount = params.count;
    self.CityWeatherInfo = [[NSMutableArray alloc]init];
    
    
    for (NSString *cityname in [params allKeys])
    {
        NSString *url = [NSString stringWithFormat:@"%@/api/v4/getWeather?code=%@",TrafficEyeURL,[params objectForKey:cityname]];
        NSString *userName = [NSString stringWithFormat:@"Weather-%@",cityname];
        
        self.CItyListWeatherRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        self.CItyListWeatherRequest.timeOutSeconds = TIMEOUTSEC;
        [self.CItyListWeatherRequest setUsername:userName];
        [[self networkQueue]addOperation:self.CItyListWeatherRequest];
    }
}


- (void)doRequest_DayIndex:(NSDictionary *)params
{
    self.DayIndexRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.DayIndexRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    [self.DayIndexRequest setUsername:@"DayIndex"];
    [self.DayIndexRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.DayIndexRequest];
}

- (void)doRequest_MonthIndex:(NSDictionary *)params
{
    self.MonthIndexRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.MonthIndexRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    [self.MonthIndexRequest setUsername:@"MonthIndex"];
    [self.MonthIndexRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.MonthIndexRequest];
}

- (void)doRequest_YearIndex:(NSDictionary *)params
{
    self.YearIndexRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.YearIndexRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    [self.YearIndexRequest setUsername:@"YearIndex"];
    [self.YearIndexRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.YearIndexRequest];
}

- (void)doRequest_DistanceRanking:(NSDictionary *)params
{
    self.DistanceRankingRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.DistanceRankingRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    
    NSString *userName = [NSString stringWithFormat:@"DistanceRanking_%@",[params objectForKey:@"cityCode"]];
    [self.DistanceRankingRequest setUsername:userName];
    [self.DistanceRankingRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.DistanceRankingRequest];
}

- (void)doRequest_HotspotRanking:(NSDictionary *)params
{
    self.HotspotRankingRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.HotspotRankingRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    
    
    [self.HotspotRankingRequest setUsername:@"HotSpotRanking"];
    [self.HotspotRankingRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.HotspotRankingRequest];
}

- (void)doRequest_RoadRanking:(NSDictionary *)params
{
    self.RoadRankingRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.RoadRankingRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    
    
    [self.RoadRankingRequest setUsername:@"RoadRanking"];
    [self.RoadRankingRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.RoadRankingRequest];
}

- (void)doRequest_SingleRoadRanking:(NSDictionary *)params
{
    self.SingleRoadRankingRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.SingleRoadRankingRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    
    
    [self.SingleRoadRankingRequest setUsername:@"SingleRoad"];
    [self.SingleRoadRankingRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.SingleRoadRankingRequest];
}

- (void)doRequest_RoadTypeIndex:(NSDictionary *)params
{
    self.RoadTypeIndexRequest =  [ASIFormDataRequest requestWithURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置表单提交项
    for (NSString *key in [params allKeys])
    {
        [self.RoadTypeIndexRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    
    [self.RoadTypeIndexRequest setUsername:@"RoadTypeIndex"];
    [self.RoadTypeIndexRequest setNumberOfTimesToRetryOnTimeout:TIMEOUTSEC];
    [[self networkQueue]addOperation:self.RoadTypeIndexRequest];
}
#pragma mark -NetworkQueue
- (void)requestFinishedByQueue:(ASIHTTPRequest *)request
{
    
    //主页列表
    if ([request.username isEqualToString:@"CityList"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reJson = [self.SBJson objectWithString:result];
        
        NSMutableArray *ReArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in reJson)
        {
            CityListInfo *cityinfo = [[CityListInfo alloc]init];
            
            NSString *str = [dic objectForKey:@"city"];
            NSString *cityName = [str substringToIndex:str.length-3];
            cityinfo.name = cityName;
            float index = [[dic objectForKey:@"cIndex"] floatValue];
            cityinfo.index = [NSString stringWithFormat:@"%.1f",index];
            cityinfo.speed = [NSString stringWithFormat:@"%@km/h",[dic objectForKey:@"avgSpeed"]];
            NSString *time = [ToolClass stringFromDate_YYYY_MM_DD_HH_MM:[ToolClass DateFromString:[dic objectForKey:@"time"]]];
            cityinfo.time =  [NSString stringWithFormat:@"更新于%@",time];
            cityinfo.color = [ToolClass IndexToColor:cityinfo.index];
            cityinfo.statue = [self IndexToStatue:cityinfo.index];
           
            [ReArray addObject:cityinfo];
        }
        [self.CityList_delegate getCityListDidSuccess:ReArray];
    }
    else if ([request.username isEqualToString:@"SingleCityInfo"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        NSArray *reJson = [self.SBJson objectWithString:result];
        
        CityListInfo *info = [[CityListInfo alloc]init];
        
        for (int i = 0;i<reJson.count;i++)
        {
            NSDictionary *dic = [reJson objectAtIndex:i];
            if (i == 0)
            {
                info.name = [dic objectForKey:@"name"];
            }
            
            if ([[dic objectForKey:@"name"] isEqualToString:@"市中心"])
            {
                float index = [[dic objectForKey:@"cIndex"] floatValue];
                info.index = [NSString stringWithFormat:@"%.1f",index];
                info.speed = [NSString stringWithFormat:@"%@km/h",[dic objectForKey:@"avgSpeed"]];
                
                NSString *time = [ToolClass stringFromDate_YYYY_MM_DD_HH_MM:[ToolClass DateFromString:[dic objectForKey:@"time"]]];
                info.time =  [NSString stringWithFormat:@"更新于%@",time];
                info.color = [ToolClass IndexToColor:info.index];
                info.statue = [ToolClass IndexToStatue:info.index];
                break;
            }
        }
        
        [self.SingleCityInfo_delegate getSingleCityInfoSuccess:info];

        
    }
    //城市排行榜
    else if ([request.username isEqualToString:@"CityRanking"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reString = [self.SBJson objectWithString:result];
        NSMutableArray *ReArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in reString)
        {
            RankingInfo *info = [[RankingInfo alloc]init];
            NSString *cityName = [dic objectForKey:@"city"];
            info.name = [cityName substringToIndex:cityName.length-3];
            info.index = [dic objectForKey:@"cIndex"];
            //查询当前行政区中心点坐标
            for (CityDistanceInfo *cityInfo in self.cities)
            {
                if ([cityInfo.cName isEqualToString:info.name])
                {
                    info.coordinate = cityInfo.coordinate;
                    break;
                }
            }
            [ReArray addObject:info];
        }
        [self.CityRanking_delegate getCityRankingDidSuccess:ReArray];
    }
    
    else if ([request.username isEqualToString:@"DayIndex"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reJson = [self.SBJson objectWithString:result];
        
        NSMutableArray *reArray = [[NSMutableArray alloc]init];
        if (reJson == nil)
        {
            return;
        }
        
        NSString *cIndexs = [[reJson objectAtIndex:0] objectForKey:@"cIndex"];
        NSArray *arr = [cIndexs componentsSeparatedByString:@","];
        
        float total = 0;
        float count = 0;
        int hour = 0;
        for (int i = 0; i<arr.count; i++)
        {
            total = total + [[arr objectAtIndex:i] floatValue];
            count++;
            if ((i+1)%12 == 0 || i == arr.count -1)
            {
                hour++;
                NSNumber *avgHour = [NSNumber numberWithFloat:total/count];
                [reArray addObject:avgHour];
                total = 0;
                count = 0;
            }
        }
        
        [self.DayIndex_delegate getDayIndexSuccess:reArray];
    }
    else if ([request.username isEqualToString:@"MonthIndex"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reJson = [self.SBJson objectWithString:result];
        NSMutableArray *reArray = [[NSMutableArray alloc]init];
        
        if (reJson == nil)
        {
            return;
        }
        
        for (NSDictionary *dic in reJson)
        {
            if (![[dic objectForKey:@"cIndex"] isEqual:[NSNull null]])
            {
                [reArray addObject:[dic objectForKey:@"cIndex"]];
            }
        }
        
        [self.MonthIndex_delegate getMonthIndexSuccess:reArray];
    }
    else if ([request.username isEqualToString:@"YearIndex"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reJson = [self.SBJson objectWithString:result];
        NSMutableArray *reArray = [[NSMutableArray alloc]init];
        if (reJson == nil)
        {
            return;
        }
        NSMutableArray *yearsName = [[NSMutableArray alloc]init];
        NSMutableArray *year = [[NSMutableArray alloc]init];
        NSInteger monthNum = 1;
        for (NSDictionary *dic in reJson)
        {
            if (monthNum%12 == 0 || monthNum == reJson.count)
            {
                [year addObject:[dic objectForKey:@"cIndex"]];
                [reArray addObject:[NSArray arrayWithArray:year]];
                NSString *time = [dic objectForKey:@"time"];
                [yearsName addObject:[time substringToIndex:time.length-2]];
                
                [year removeAllObjects];
            }
            else
            {
                [year addObject:[dic objectForKey:@"cIndex"]];
            }
            monthNum++;
        }
        [self.YearIndex_delegate getYearIndexSuccess:reArray];
    }
    else if ([request.username hasPrefix:@"DistanceRanking"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reJson = [self.SBJson objectWithString:result];
        NSMutableArray *reArray = [[NSMutableArray alloc]init];
        
        NSArray *array = [request.username componentsSeparatedByString:@"_"];
        
        for (NSDictionary *dic in reJson)
        {
            RankingInfo *info  = [[RankingInfo alloc]init];
            info.name = [dic objectForKey:@"name"];
            info.index = [dic objectForKey:@"cIndex"];
            
            
            //查询当前行政区中心点坐标
            for (DistanceInfo *disInfo in [self getCurcityDistanceList:[self getCityNameByCode:[array objectAtIndex:1]]])
            {
                if ([disInfo.dName isEqualToString:info.name])
                {
                    info.coordinate = disInfo.coordinate;
                    break;
                }
            }
            [reArray addObject:info];
        }
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO];
        [reArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        [self.DistanceRanking_delegate getDistanceRankingSuccess:reArray];
    }
    else if ([request.username isEqualToString:@"HotSpotRanking"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reJson = [self.SBJson objectWithString:result];
        NSMutableArray *reArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in reJson)
        {
            RankingInfo *info  = [[RankingInfo alloc]init];
            info.name = [dic objectForKey:@"name"];
            Coordinate2D coor;
            coor.longitude = [[dic objectForKey:@"lon"] doubleValue];
            coor.latitude = [[dic objectForKey:@"lat"] doubleValue];
            info.coordinate = coor;
            info.index = [dic objectForKey:@"cIndex"];
            
            [reArray addObject:info];
        }
        
        [self.HotspotRanking_delegate getHotspotRankingSuccess:reArray];
    }
    else if ([request.username isEqualToString:@"RoadRanking"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reJson = [self.SBJson objectWithString:result];
        NSMutableArray *reArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in reJson)
        {
            RankingInfo *info  = [[RankingInfo alloc]init];
            info.name = [dic objectForKey:@"name"];
            info.index = [dic objectForKey:@"cIndex"];
            info.RoadID = [dic objectForKey:@"code"];
            info.kind = [dic objectForKey:@"kind"];
            [reArray addObject:info];
        }
        
        [self.RoadRanking_delegate getRoadRankingSuccess:reArray];
    }
    else if ([request.username isEqualToString:@"SingleRoad"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *roads = [self.SBJson objectWithString:result];
        NSString *latlons = [[roads firstObject] objectForKey:@"rticLonlats"];
        NSArray *rtics = [latlons componentsSeparatedByString:@","];
        
        [self.SingleRoadRanking_delegate getSingleRoadSuccess:rtics];
    }
    else if ([request.username isEqualToString:@"RoadTypeIndex"])
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSArray *reArray = [self.SBJson objectWithString:result];
        [self.RoadTypeIndex_delegate getRoadTypeIndexSuccess:reArray];
    }
    
    
    //实时天气
    NSRange range = [request.username rangeOfString:@"Weather"];
    
    if (range.location != NSNotFound)
    {
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSRange range;
        range.location = 5;
        range.length = result.length-6;
        NSString *weatherResult = [result substringWithRange:range];
        NSDictionary *reJson = [self.SBJson objectWithString:weatherResult];
        NSDictionary *weatherInfo = [reJson objectForKey:@"weatherInfo"];

        
        NSArray *array = [request.username componentsSeparatedByString:@"-"];
        NSString *cityName = [array objectAtIndex:1];
        
        CityListInfo *cityinfo = [[CityListInfo alloc]init];
        cityinfo.name = cityName;
        cityinfo.temperature = [weatherInfo objectForKey:@"t1Temperature"];
        cityinfo.weatherType = [weatherInfo objectForKey:@"t1WeatherDesc"];
        
        [self.CityWeatherInfo addObject:cityinfo];
        
        if (self.CityWeatherInfo.count == self.CityCount)
        {
            [self.CityListWeather_delegate getCityListWeatherInfoSuccess:self.CityWeatherInfo];
        }
    }
}

- (void)requestFailedByQueue:(ASIHTTPRequest *)request
{
    
    NSString *error = [NSString stringWithFormat:@"%@",request.error];
    //主页列表
    if ([request.username isEqualToString:@"CityList"])
    {
        [self.CityList_delegate getCityListDidFailed:error];
    }
    else if ([request.username isEqualToString:@"SingleCityInfo"])
    {
        [self.SingleCityInfo_delegate getSingleCityInfoFail:error];
    }
    //城市排行榜
    else if ([request.username isEqualToString:@"CityRanking"])
    {
        [self.CityRanking_delegate getCityRankingDidFailed:error];
    }
    
    else if ([request.username isEqualToString:@"DayIndex"])
    {
        [self.DayIndex_delegate getDayIndexFailed:error];
    }
    else if ([request.username isEqualToString:@"MonthIndex"])
    {
        [self.MonthIndex_delegate getMonthIndexFailed:error];
    }
    else if ([request.username isEqualToString:@"YearIndex"])
    {
        [self.YearIndex_delegate getYearIndexFailed:error];
    }
    else if ([request.username hasPrefix:@"DistanceRanking"])
    {
        [self.DistanceRanking_delegate getDistanceRankingFail:error];
    }
    else if ([request.username isEqualToString:@"HotSpotRanking"])
    {
        [self.HotspotRanking_delegate getHotspotRankingFail:error];
    }
    else if ([request.username isEqualToString:@"RoadRanking"])
    {
        [self.RoadRanking_delegate getRoadRankingFail:error];
    }
    else if ([request.username isEqualToString:@"SingleRoad"])
    {
        [self.SingleRoadRanking_delegate getSingleRoadFail:error];
    }
    else if ([request.username isEqualToString:@"RoadTypeIndex"])
    {
        [self.RoadTypeIndex_delegate getRoadTypeIndexFail:error];
    }
    
    //实时天气
    NSRange range = [request.username rangeOfString:@"Weather"];
    
    if (range.location != NSNotFound)
    {
        [self.CityListWeather_delegate getCityListWeatherInfoFail:error];
    }
}

- (void)queueFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"queueFinished");
}
@end
