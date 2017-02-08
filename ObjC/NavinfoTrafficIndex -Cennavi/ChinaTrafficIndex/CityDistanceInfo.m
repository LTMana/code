//
//  CityDistanceInfo.m
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "CityDistanceInfo.h"

@implementation CityDistanceInfo
@synthesize cName,code,coordinate,list,weatherCode;



+ (NSArray *)getCityListInfo
{
    NSMutableArray *cities = [[NSMutableArray alloc]init];
    
    SBJsonParser *SBJson = [[SBJsonParser alloc]init];
    NSError *error;
    
    NSString *textFileContents = [NSString
                                  stringWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:@"cities"
                                                            ofType:@"txt"]
                                  encoding:NSUTF8StringEncoding
                                  error: & error];
    NSArray *reJson = [SBJson objectWithString:textFileContents];
    
    
    //增加查询城市天气ID
    NSString *weatherCode = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                      pathForResource:@"weatherCode"
                                                      ofType:@"txt"]
                            encoding:NSUTF8StringEncoding
                            error: & error];
    
    NSDictionary *Codes = [SBJson objectWithString:weatherCode];
    
    for (int i = 0;i<reJson.count;i++)
    {
        NSDictionary *dic = [reJson objectAtIndex:i];
       
        
        CityDistanceInfo *info = [[CityDistanceInfo alloc]init];
        NSString *cityName = [dic objectForKey:@"cname"];
        info.cName = [cityName substringToIndex:cityName.length - 1];
        info.code = [dic objectForKey:@"code"];
        info.weatherCode = [Codes objectForKey:info.cName];
        
        Coordinate2D coor;
        coor.longitude = [[dic objectForKey:@"lon"] floatValue];
        coor.latitude = [[dic objectForKey:@"lat"] floatValue];
        info.coordinate = coor;
        
        NSMutableArray *Dis_list = [[NSMutableArray alloc]init];
        NSArray *dis = [dic objectForKey:@"list"];
        for (NSDictionary *dis_dic in dis)
        {
            DistanceInfo *disInfo = [[DistanceInfo alloc]init];
            disInfo.dName = [dis_dic objectForKey:@"cname"];
            disInfo.code = [dis_dic objectForKey:@"code"];
            Coordinate2D discoor;
            discoor.longitude = [[dis_dic objectForKey:@"lon"] floatValue];
            discoor.latitude = [[dis_dic objectForKey:@"lat"] floatValue];
            disInfo.coordinate = discoor;
            
            [Dis_list addObject:disInfo];
        }
        info.list = Dis_list;
        [cities addObject:info];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    [cities sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    return [NSArray arrayWithArray:cities];
}
@end
