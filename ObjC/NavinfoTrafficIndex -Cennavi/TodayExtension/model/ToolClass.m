//
//  ToolClass.m
//  TrafficIndex
//
//  Created by Mickey on 14-9-4.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "ToolClass.h"
#import "GTMBase64.h"



@implementation ToolClass


+ (NSDate *)DateFromString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date=[dateFormatter dateFromString:string];
    
    return date;
}


+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString *)stringFromDate_YYYY_MM_DD:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
+ (NSString *)stringFromDate_YYYY_MM_DD_HH_MM:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//根据日期获取当前月初，月末日期
+ (NSString *)MonthStartToMonthEnd:(NSDate *)date
{
    NSInteger now_year,now_month,now_day,year,month;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    now_year = [comps year];
    now_month = [comps month];
    now_day = [comps day];
    
    comps = [calendar components:unitFlags fromDate:date];
    year = [comps year];
    month = [comps month];
    
    if (year != now_year || month != now_month)
    {
        if (month != 2)
        {
            // 如果上个月的月份为 4  6  9  11 月份，他们月末是30号
            if (month == 4 || month==6 || month ==9 || month ==11)
            {
                return [NSString stringWithFormat:@"%d%.2d01-%d%.2d30",year,month,year,month];
            }
            else
            {
               return [NSString stringWithFormat:@"%d%.2d01-%d%.2d31",year,month,year,month];
            }
        }
        else
        {
            if ((year%4==0 && year%100!=0) || year%400==0)
            {
                return [NSString stringWithFormat:@"%d%.2d01-%d%.2d29",year,month,year,month];
            }
            else
            {
                return [NSString stringWithFormat:@"%d%.2d01-%d%.2d28",year,month,year,month];
            }
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%d%.2d01-%d%.2d%.2d",year,month,now_year,now_month,now_day];
    }
}


//定义颜色状态
+ (NSString *)IndexToStatue:(NSString *)CityIndex
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

//定义指数颜色
+(UIColor *)IndexToColor:(NSString *)Index
{
    float index = [Index floatValue];
    
    if (index < 2)
    {
        return lightGreen;
    }
    else if(index <4 && index >= 2)
    {
        return DeepGreen;
    }
    else if(index<7 && index >=4)
    {
        return yellow;
    }
    else if (index <10 && index>=7)
    {
        return Deepyellow;
    }
    else if (index <18 && index>=10)
    {
        return [UIColor redColor];
    }
    else
    {
        return DeepRed;
    }

}


+(NSString*)getDocument:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *document = [paths objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:fileName];
    return path;
}

+ (void)saveToPlist:(NSString *)fileName :(id)arrayOrDic{
    NSString* filePath = [ToolClass getDocument:fileName];
    [arrayOrDic writeToFile:filePath atomically:YES];
}



@end
