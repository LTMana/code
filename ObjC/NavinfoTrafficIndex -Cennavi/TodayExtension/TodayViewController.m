//
//  TodayViewController.m
//  TodayExtension
//
//  Created by 米航 on 14-12-18.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayTableViewCell.h"
#import "ToolClass.h"
#import "CityDistanceInfo.h"
#import "SBJson.h"
#import "CityListInfo.h"

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>
{
    SBJsonParser *SBJson;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray    *dataSourceArray;

@end

@implementation TodayViewController

- (void)loadView
{
    [super loadView];
   
    
    [self.view addSubview:self.tableView];
}




// 一般默认的View是从图标的右边开始的...如果你想变换,就要实现这个方法
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    // 完全靠到了左边....
    return UIEdgeInsetsMake(0.0, 0.0, 0, 0);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    SBJson = [[SBJsonParser alloc]init];
    self.dataSourceArray = [NSMutableArray arrayWithArray:[self ReadCityListFile]];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self loadNewDataCompletion:^(NCUpdateResult result) {
        if (result == NCUpdateResultNewData) {
            [self resetTableView];
            
        }else if (result == NCUpdateResultFailed) {
            NSLog(@"网络下载出错啦！");
            
        }else if (result == NCUpdateResultNoData) {
            NSLog(@"没有最新数据！");
        }
    }];
}


- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context
{
    
}

- (void)resetTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        CGFloat height = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0] * 60;
        [self setPreferredContentSize:CGSizeMake(self.view.frame.size.width, height)];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    [self loadNewDataCompletion:^(NCUpdateResult result) {
        
        if (result == NCUpdateResultNewData) {
            [self resetTableView];
        }
        completionHandler(result);
    }];
}


- (void)loadNewDataCompletion:(void (^)(NCUpdateResult result))handler
{
    
    NSMutableString *citysCode = [[NSMutableString alloc]init];
    for(CityListInfo *city in self.dataSourceArray)
    {
        if (citysCode.length < 1)
        {
            [citysCode appendString:city.code];
        }
        else
        {
            [citysCode appendFormat:@",%@",city.code];
        }
    }
    
   
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    NSString *post = [NSString stringWithFormat:@"cityCodes=%@&byJamRanking=true&area=98&timeRange=0&method=1",citysCode];
    
    NSLog(@"post:%@",post);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:TrafficIndexURL]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    
    
   // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:TrafficIndexURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (error) {
                                   handler(NCUpdateResultFailed);
                                   
                               } else {
                                  
                                   NSString *downloadString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSError *localError = nil;
                                   if (downloadString == nil || downloadString.length < 20) {
                                       localError = [[NSError alloc] init];
                                       handler(NCUpdateResultNoData);
                                       
                                   }else {
                    
                                       NSArray *reJson = [SBJson objectWithString:downloadString];
                                       
                                       for (NSDictionary *dic in reJson)
                                       {
                                           NSString *str = [dic objectForKey:@"city"];
                                           NSString *cityName = [str substringToIndex:str.length-3];
                                           
                                           for (CityListInfo *cityinfo in self.dataSourceArray)
                                           {
                                               if ([cityinfo.name isEqualToString:cityName])
                                               {
                                                   float index = [[dic objectForKey:@"cIndex"] floatValue];
                                                   cityinfo.index = [NSString stringWithFormat:@"%.1f",index];
                                                   cityinfo.speed = [NSString stringWithFormat:@"%@km/h",[dic objectForKey:@"avgSpeed"]];
                                                   NSString *time = [ToolClass stringFromDate_YYYY_MM_DD_HH_MM:[ToolClass DateFromString:[dic objectForKey:@"time"]]];
                                                   cityinfo.time =  [NSString stringWithFormat:@"更新于%@",time];
                                                   cityinfo.color = [ToolClass IndexToColor:cityinfo.index];
                                                   cityinfo.statue = [ToolClass IndexToStatue:cityinfo.index];
                                                   break;
                                               }
                                           }
                                       }
                                       
                                       [self resetTableView];
                                       
                                   }
                               }
                           }];
    
}

- (NSArray *)ReadCityListFile
{
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.cennavi.NaviInfoTrafficIndex"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *keys = [defaults objectForKey:@"CityNames"];
    
    for (NSString *cityName in keys)
    {
        NSDictionary *dictionary = [defaults objectForKey:cityName];
        CityListInfo *cityInfo = [[CityListInfo alloc]init];
        cityInfo.name = cityName;
        cityInfo.code = [dictionary objectForKey:@"code"];
        cityInfo.speed = [dictionary objectForKey:@"speed"];
        cityInfo.index = [dictionary objectForKey:@"index"];
        cityInfo.time = [dictionary objectForKey:@"time"];
        cityInfo.Json = [dictionary objectForKey:@"json"];
        cityInfo.location = [dictionary objectForKey:@"location"];
        cityInfo.weatherCode = [dictionary objectForKey:@"weatherCode"];
        cityInfo.color = [ToolClass IndexToColor:cityInfo.index];
        cityInfo.statue = [ToolClass IndexToStatue:cityInfo.index];
       
        [array addObject:cityInfo];
    }
    
    //根据位置信息排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //列表中没有数据，添加默认城市北、上、广、深。
    if (keys == nil)
    {
        
        
        CityListInfo *beijing = [[CityListInfo alloc]init];
        beijing.name = @"北京";
        beijing.code = @"110000";
        beijing.location = @"0";
        beijing.weatherCode = @"101010100";
        CityListInfo *shanghai = [[CityListInfo alloc]init];
        shanghai.name = @"上海";
        shanghai.code = @"310000";
        shanghai.location = @"1";
        shanghai.weatherCode = @"101020100";
        CityListInfo *guangzhou = [[CityListInfo alloc]init];
        guangzhou.name = @"广州";
        guangzhou.code = @"440100";
        guangzhou.location = @"2";
        guangzhou.weatherCode = @"101280101";
        CityListInfo *shenzhen = [[CityListInfo alloc]init];
        shenzhen.name = @"深圳";
        shenzhen.code = @"440300";
        shenzhen.location = @"3";
        shenzhen.weatherCode = @"101280601";
        
        [array addObject:beijing];
        [array addObject:shanghai];
        [array addObject:guangzhou];
        [array addObject:shenzhen];
        beijing = nil;
        shanghai = nil;
        guangzhou = nil;
        shenzhen = nil;
       
    }
    return array;
}





#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSDictionary *newsDict = self.dataSourceArray[indexPath.row];
    NSString *urlString = newsDict[@"url"];
    [self.extensionContext openURL:[NSURL URLWithString:urlString] completionHandler:nil];
    */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    });
    
    [self.extensionContext openURL:[NSURL URLWithString:@"NaviInfoTrafficIndex://"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
     
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
}

#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayTableViewCell *cell;
    
    static NSString *CellIdentifier = @"TodayTableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"TodayTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CityListInfo *info = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = info.name;
    cell.statueLabel.text = info.statue;
    cell.IndexLabel.text = info.index;
    cell.colorView.backgroundColor = info.color;
    
    return cell;

}
@end
