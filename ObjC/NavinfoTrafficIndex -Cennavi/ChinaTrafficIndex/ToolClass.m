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

+(UIImage *)getImageFromView:(UIView *)view
{
    
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [ToolClass makeRoundCornerImage:image :10];
    
}

//UIImage圆角
+ (UIImage*)makeRoundCornerImage:(UIImage*)img :(int)cornerRadius
{
    
    UIImage * newImage = nil;
    if( nil != img)
    {
        
        int w = img.size.width;
        int h = img.size.height;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
        
        CGContextBeginPath(context);
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        addRoundedRectToPath(context, rect, cornerRadius, cornerRadius);
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        newImage = [UIImage imageWithCGImage:imageMasked];
        // 上面如果不retain ,会被释放掉！！
        CGImageRelease(imageMasked);
        
       
    }
    
    return newImage;
}
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)ViewToImage:(UIView *)theView
{
    
    
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(theView.frame.size);
    }
    
    //获取图像
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
    //UIScrollView截屏
    /*
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
        
    }
    
    UIGraphicsEndImageContext();
    
    return image;
    */
    
}
@end
