//
//  DetailViewController.m
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "DetailViewController.h"
#import "MyScrollView.h"
#import "CNMKPinView.h"
#import "CNMKShapeView.h"
//#define IndexMax 20

@interface DetailViewController ()
- (IBAction)backBtn:(id)sender;
- (IBAction)shareBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *CityNameLabel;
@property (weak, nonatomic) IBOutlet MyScrollView *ScrollView;

//城市概况信息
@property (weak, nonatomic) IBOutlet UILabel *IndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatueLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
//城市道路指数信息
@property (weak, nonatomic) IBOutlet UILabel *RoadIndex_Label_1;
@property (weak, nonatomic) IBOutlet UIImageView *RoadIndex_Image_1;
@property (weak, nonatomic) IBOutlet UILabel *RoadIndex_Label_2;
@property (weak, nonatomic) IBOutlet UIImageView *RoadIndex_Image_2;
@property (weak, nonatomic) IBOutlet UILabel *RoadIndex_Label_3;
@property (weak, nonatomic) IBOutlet UIImageView *RoadIndex_Image_3;
@property (weak, nonatomic) IBOutlet UILabel *RoadIndex_Label_4;
@property (weak, nonatomic) IBOutlet UIImageView *RoadIndex_Image_4;
//历史数据指数信息
@property (weak, nonatomic) IBOutlet UIButton *DateBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *TimeRange;
- (IBAction)historyDataTimeRange:(id)sender;

@property (weak, nonatomic) IBOutlet RWBarChartView *BarChart;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ChartActivity;
- (IBAction)SelectTimeBtn:(id)sender;
//地图显示
@property (strong, nonatomic) CNMKMapView *citymapView;
@property (weak, nonatomic) IBOutlet UIView *underMapView;
//列表显示
- (IBAction)RankingKind:(id)sender;
- (IBAction)ChangeRoadType:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *RankingKind_Seg;
@property (weak, nonatomic) IBOutlet UITableView *RankingTable;
@property (weak, nonatomic) IBOutlet UIButton *RoadTypeBtn;


@end

@implementation DetailViewController
@synthesize CurCityInfo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SelectRoadType:) name:@"SelectRoadType" object:nil];
    
    cities = [CityDistanceInfo getCityListInfo];
   
    
    NSMutableArray *TemDayArray = [[NSMutableArray alloc]init];
    DayArray = TemDayArray;
    
    NSMutableArray *TemYearArray = [[NSMutableArray alloc]init];
    YearArray = TemYearArray;
    
    NSMutableArray *TemMonthArray = [[NSMutableArray alloc]init];
    MonthArray = TemMonthArray;
    
    NSMutableArray *TemAllRoad_Array = [[NSMutableArray alloc]init];
    AllRoad_Array = TemAllRoad_Array;
    
    NSMutableArray *TemRank_Array = [[NSMutableArray alloc]init];
    Rank_Array = TemRank_Array;
    
    NSMutableArray *TemAnns_Array = [[NSMutableArray alloc]init];
    Anns_Array = TemAnns_Array;
    
    NSMutableArray *TemOverlays_Array = [[NSMutableArray alloc]init];
    Overlays_Array = TemOverlays_Array;
    
    NSArray *array = @[@"高速道路",@"城市快速路",@"地面主要道路",@"城市微循环"];
    RoadTypes = [[NSMutableArray alloc]initWithArray:array];
    RoadType_statue = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1",@"高速道路",@"1",@"城市快速路",@"1",@"地面主要道路",@"0",@"城市微循环", nil];
    
    cityCode = [self CityNameToCityCode:self.CurCityInfo.name];
    
    roadLevel = @"1,2,3";
    selectDate = [NSDate date];
    self.TenMax = YES;
    self.IndexMax = 10;
    [self InitUI];
    
    [self GetRoadKindInfo];
    
    [self GetHistoryDate];
    
    [self getRankingInfo];

}

- (void)InitUI
{
    
    RMDateSelectionViewController *CurdateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    CurdateSelectionVC.delegate = self;
    dateSelectionVC = CurdateSelectionVC;
    
    self.CityNameLabel.text = self.CurCityInfo.name;
    self.IndexLabel.text = self.CurCityInfo.index;
    self.avgSpeedLabel.text = self.CurCityInfo.speed;
    self.TimeLabel.text = self.CurCityInfo.time;
    self.StatueLabel.text = self.CurCityInfo.statue;
    self.StatueLabel.layer.cornerRadius = 5;
    self.StatueLabel.backgroundColor = self.CurCityInfo.color;
    
    //yes 则发送一个可以touchesCancelled:withEvent:  然后把这个事件当作一次滚动赖实现
    [self.ScrollView setCanCancelContentTouches:YES];
    
    //滚动的时候是否可以除边界，即到边界的时候是否可以多看到一点内容
    [self.ScrollView setBounces:NO];
    
    // 当值是NO 立即调用 touchesShouldBegin:withEvent:inContentView 看是否滚动 scroll
    [self.ScrollView setDelaysContentTouches:NO];
    
    
    [self.DateBtn setTitle:[ToolClass stringFromDate_YYYY_MM_DD:selectDate] forState:UIControlStateNormal];
    
    
    self.DateBtn.layer.borderWidth = 1.0;
    self.DateBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.DateBtn.layer.cornerRadius = 5.0;
    self.RoadTypeBtn.layer.borderWidth = 1.0;
    self.RoadTypeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.RoadTypeBtn.layer.cornerRadius = 5.0;
    self.RoadTypeBtn.hidden = YES;
    
    
    ZSYPopoverListView *CurlistView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 260, 260)];
    CurlistView.titleName.text = @"选择道路等级";
    CurlistView.datasource = self;
    CurlistView.delegate = self;
    
    listView = CurlistView;
    
    [self.underMapView addSubview:self.citymapView];
    
    
    self.ChartActivity.center = CGPointMake(self.BarChart.frame.size.width/2, self.BarChart.frame.size.height/2);
    self.BarChart.dataSource = self;
    self.BarChart.barWidth = 12;
    self.BarChart.scrollViewDelegate = self;
    
    //self.ScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
}

-(CNMKMapView *)citymapView
{
    if (_citymapView ==nil) {
        
        _citymapView =[[CNMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.underMapView.frame.size.width, self.underMapView.frame.size.height)];
        _citymapView.delegate = self;
        _citymapView.gNoteCBDelegate = self;
        [self.citymapView setMapType:CNMKMapTypeStandard];
        
        
        for (CityDistanceInfo *city in cities)
        {
            if ([city.cName isEqualToString:self.CurCityInfo.name])
            {
                
                CNMKGeoPoint coor;
                coor.latitude = city.coordinate.latitude;
                coor.longitude = city.coordinate.longitude;
                
                [self.citymapView setCenterCoordinate:coor];
                
                break;
            }
        }
        
        [self.citymapView setZoomLevel:11];

    }
    
    return _citymapView;
}


- (void)reloadBarChart
{
    NSMutableDictionary *singleItems = [NSMutableDictionary dictionary];
    
    if (self.TimeRange.selectedSegmentIndex == 0)
    {
        for (int i = 0; i<DayArray.count; i++)
        {
            float index = [[DayArray objectAtIndex:i] floatValue];
            
            if (index >= 10)
            {
                self.TenMax = NO;
            }
        }
        if (self.TenMax)
        {
            self.IndexMax = 10;
        }
        else
        {
            self.IndexMax = 20;
        }
        
        
        for (int i = 0; i<DayArray.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            
            CGFloat ratio = [[DayArray objectAtIndex:i] floatValue]/self.IndexMax;
            UIColor *color = [ToolClass IndexToColor:[NSString stringWithFormat:@"%f",ratio*self.IndexMax]];
            RWBarChartItem *singleItem = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
            
            if ([[DayArray objectAtIndex:i] floatValue] == 0)
            {
                singleItem.text = [NSString stringWithFormat:@"N/A"];
            }
            else
            {
                singleItem.text = [NSString stringWithFormat:@"%.2d:00 指数 = %.1f",i+1,ratio*self.IndexMax];
            }
            
            singleItems[indexPath] = singleItem;
        }
    }
    else if (self.TimeRange.selectedSegmentIndex == 1)
    {
        for (int i = 0; i<MonthArray.count; i++)
        {
            float index = [[MonthArray objectAtIndex:i] floatValue];
            
            if (index >= 10)
            {
                self.TenMax = NO;
            }
        }
        if (self.TenMax)
        {
            self.IndexMax = 10;
        }
        else
        {
            self.IndexMax = 20;
        }
        
        for (int i = 0; i<MonthArray.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CGFloat ratio = [[MonthArray objectAtIndex:i] floatValue]/self.IndexMax;
            UIColor *color = [ToolClass IndexToColor:[NSString stringWithFormat:@"%f",ratio*self.IndexMax]];
            
            RWBarChartItem *singleItem = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
            
            if ([[MonthArray objectAtIndex:i] floatValue] == 0)
            {
                singleItem.text = [NSString stringWithFormat:@"N/A"];
            }
            else
            {
                singleItem.text = [NSString stringWithFormat:@"%d日 指数 = %.1f",i+1,ratio*self.IndexMax];
            }
            
            singleItems[indexPath] = singleItem;
        }
    }
    else if (self.TimeRange.selectedSegmentIndex == 2)
    {
        for (int year  = 0; year<YearArray.count; year++)
        {
            NSArray *array = [YearArray objectAtIndex:year];
            for (int i = 0; i<array.count; i++)
            {
                float index = [[array objectAtIndex:i] floatValue];
                
                if (index >= 10)
                {
                    self.TenMax = NO;
                }
            }
        }
        if (self.TenMax)
        {
            self.IndexMax = 10;
        }
        else
        {
            self.IndexMax = 20;
        }
        
        
        for (int year  = 0; year<YearArray.count; year++)
        {
            NSArray *array = [YearArray objectAtIndex:year];
            for (int i = 0; i<array.count; i++)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:year];
                CGFloat ratio = [[array objectAtIndex:i] floatValue]/self.IndexMax;
                UIColor *color = [ToolClass IndexToColor:[NSString stringWithFormat:@"%f",ratio*self.IndexMax]];
                
                RWBarChartItem *singleItem = [RWBarChartItem itemWithSingleSegmentOfRatio:ratio color:color];
                
                
                if ([[array objectAtIndex:i] floatValue] == 0)
                {
                    singleItem.text = [NSString stringWithFormat:@"N/A"];
                }
                else
                {
                    singleItem.text = [NSString stringWithFormat:@"%d月 指数 = %.1f",i+1,ratio*self.IndexMax];
                }
                
                singleItems[indexPath] = singleItem;
            }
        }
    }
    
    self.singleItems = singleItems;
    
    [self.BarChart reloadData];
}
//选择完道路等级确定按钮发送的通知
- (void)SelectRoadType:(NSNotification *)note
{
     NSMutableString *level = [[NSMutableString alloc]init];
    for (int i = 0;i<RoadTypes.count;i++)
    {
        
        NSInteger flag =  [[RoadType_statue objectForKey:[RoadTypes objectAtIndex:i]] intValue];
        if (flag == 1)
        {
            if(i == 0 || level.length < 1)
            {
                [level appendFormat:@"%d",i+1];
            }
            else
            {
                [level appendFormat:@",%d",i+1];
            }
        }
    }
    
    roadLevel = [NSString stringWithFormat:@"%@",level];
    
    [self filterRoadType];
    [self.RankingTable reloadData];
   
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _citymapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}


-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:NO];

    _citymapView.delegate = nil; // 不用时，置nil
    

    DayArray = nil;
    YearArray = nil;
    MonthArray = nil;
    AllRoad_Array = nil;
    Rank_Array = nil;
    Anns_Array = nil;
    Overlays_Array = nil;
    RoadTypes = nil;
    RoadType_statue = nil;
    cityCode = nil;
    roadLevel = nil;
    selectDate = nil;
    listView = nil;
    _citymapView = nil;
    dateSelectionVC = nil;
    
    
    _CityNameLabel = nil;
    _ScrollView = nil;
    _IndexLabel = nil;
    _StatueLabel = nil;
    _avgSpeedLabel = nil;
    _TimeLabel = nil;
    _RoadIndex_Image_1 = nil;
    _RoadIndex_Image_2 = nil;
    _RoadIndex_Image_3 = nil;
    _RoadIndex_Image_4 = nil;
    _RoadIndex_Label_1 = nil;
    _RoadIndex_Label_2 = nil;
    _RoadIndex_Label_3 = nil;
    _RoadIndex_Label_4 = nil;
    _DateBtn = nil;
    _TimeRange = nil;
    _ChartActivity = nil;
    _citymapView = nil;
    _underMapView = nil;
    _RankingKind_Seg = nil;
    _RankingTable = nil;
    _RoadTypeBtn = nil;
}


//获取Code
- (NSString *)CityNameToCityCode:(NSString *)name
{
    NSString *code;
    
    if (name == nil)
    {
        return nil;
    }
    for (CityDistanceInfo *info in cities)
    {
       
        NSRange range = [info.cName rangeOfString:name];
        if (range.location != NSNotFound)
        {
            code = info.code;
            CNMKGeoPoint coor;
            coor.longitude = info.coordinate.longitude;
            coor.latitude = info.coordinate.latitude;
            [self.citymapView setCenterCoordinate:coor animated:YES];
            break;
        }
    }
    return code;
}

- (void)GetRoadKindInfo
{
    if (cityCode == nil)
    {
        return;
    }
    NSDictionary *dicDistance = @{@"cityCode": cityCode,@"needVkt":@"false",@"method":@"8"};
    [AppDelegate getApplicationDelegate].RequestHandling.RoadTypeIndex_delegate = self;
    [[AppDelegate getApplicationDelegate].RequestHandling doRequest_RoadTypeIndex:dicDistance];
    
    dicDistance = nil;
}

- (void)InitRoadViewInfo:(NSArray *)RoadIndexs
{
    for (NSDictionary *dic in RoadIndexs)
    {
        NSString *name = [dic objectForKey:@"name"];
        NSString *cIndex = [dic objectForKey:@"cIndex"];
        if ([name isEqualToString:@"高速公路"])
        {
            self.RoadIndex_Label_1.text = cIndex;
            self.RoadIndex_Image_1.backgroundColor = [ToolClass IndexToColor:cIndex];
        }
        else if([name isEqualToString:@"城市快速路"])
        {
            self.RoadIndex_Label_2.text = cIndex;
            self.RoadIndex_Image_2.backgroundColor = [ToolClass IndexToColor:cIndex];
        }
        else if([name isEqualToString:@"地面主要道路"])
        {
            self.RoadIndex_Label_3.text = cIndex;
            self.RoadIndex_Image_3.backgroundColor = [ToolClass IndexToColor:cIndex];
        }
        else if([name isEqualToString:@"城市微循环"])
        {
            self.RoadIndex_Label_4.text = cIndex;
            self.RoadIndex_Image_4.backgroundColor = [ToolClass IndexToColor:cIndex];
        }
    }
}

- (void)GetHistoryDate
{

    [self.ChartActivity startAnimating];

   
    NSDate *pickDate = selectDate;
    
    NSString *today = [ToolClass stringFromDate:pickDate];
    NSString *newCityCode = [NSString stringWithFormat:@"%@98",[cityCode substringToIndex:cityCode.length - 2]];
    if (_TimeRange.selectedSegmentIndex == 0)
    {
        
    
        NSString *fromTo = [NSString stringWithFormat:@"%@-%@",today,today];
        NSDictionary *dicDistance = @{@"cityCode": newCityCode,@"needVkt":@"false",@"requestType":@"day",@"fromTo":fromTo,@"method":@"3"};
        
        
        [AppDelegate getApplicationDelegate].RequestHandling.DayIndex_delegate = self;
        [[AppDelegate getApplicationDelegate].RequestHandling doRequest_DayIndex:dicDistance];
        
        //[http initRequestWithUrl:TrafficIndexURL withDic:dicDistance andUserName:@"Day"];
        dicDistance = nil;
    }
    else if (_TimeRange.selectedSegmentIndex == 1)
    {
        
        
        
        NSString *days = [ToolClass MonthStartToMonthEnd:pickDate];
        NSDictionary *dicDistance = @{@"cityCode":newCityCode,@"needVkt":@"false",@"timeRange":@"all",@"requestType":@"day",@"independent":@"false",@"fromTo":days,@"method":@"3"};
        
        [AppDelegate getApplicationDelegate].RequestHandling.MonthIndex_delegate = self;
        [[AppDelegate getApplicationDelegate].RequestHandling doRequest_MonthIndex:dicDistance];
       // [http initRequestWithUrl:TrafficIndexURL withDic:dicDistance andUserName:@"Month"];
        dicDistance = nil;
    }
    else if (_TimeRange.selectedSegmentIndex == 2)
    {
        //年表
        NSDate *now = [NSDate date];
        NSArray *arr = [[ToolClass stringFromDate_YYYY_MM_DD:now] componentsSeparatedByString:@"-"];
        NSString *time;
        NSString *month;
        if([[arr objectAtIndex:1]intValue] == 1)
        {
            month = @"12";
            time = [NSString stringWithFormat:@"201301-%d%@",[[arr objectAtIndex:0] intValue]-1,month];
        }
        else
        {
            month = [NSString stringWithFormat:@"%d",[[arr objectAtIndex:1]intValue]-1];
            time = [NSString stringWithFormat:@"201301-%@%@",[arr objectAtIndex:0],month];
        }
        
        NSDictionary *dicDistance = @{@"cityCode": newCityCode,@"needVkt":@"false",@"requestType":@"month",@"fromTo":time,@"independent":@"false",@"method":@"3"};
        
        [AppDelegate getApplicationDelegate].RequestHandling.YearIndex_delegate = self;
        [[AppDelegate getApplicationDelegate].RequestHandling doRequest_YearIndex:dicDistance];
      
        dicDistance = nil;
    }
}
- (void)getRankingInfo
{
    if (_RankingKind_Seg.selectedSegmentIndex == 0)
    {
        NSDictionary *dic = @{@"cityCode": cityCode,@"needVkt":@"false",@"orderByIndex":@"desc",@"method":@"4"};
        
        [AppDelegate getApplicationDelegate].RequestHandling.DistanceRanking_delegate = self;
        [[AppDelegate getApplicationDelegate].RequestHandling doRequest_DistanceRanking:dic];
       // [http initRequestWithUrl:TrafficIndexURL withDic:dic andUserName:@"Ranking_Distance"];
        dic = nil;
    }
    else if (_RankingKind_Seg.selectedSegmentIndex == 1)
    {
        NSDictionary *dic = @{@"cityCode": cityCode,@"needVkt":@"false",@"orderByIndex":@"desc",@"method":@"6"};
        
        [AppDelegate getApplicationDelegate].RequestHandling.HotspotRanking_delegate = self;
        [[AppDelegate getApplicationDelegate].RequestHandling doRequest_HotspotRanking:dic];
        //[http initRequestWithUrl:TrafficIndexURL withDic:dic andUserName:@"Ranking_HotSpot"];
        dic = nil;
    }
    else if (_RankingKind_Seg.selectedSegmentIndex == 2)
    {
        NSDictionary *dic = @{@"cityCode": cityCode,@"orderByIndex":@"desc",@"method":@"10"};
        
        [AppDelegate getApplicationDelegate].RequestHandling.RoadRanking_delegate = self;
        [[AppDelegate getApplicationDelegate].RequestHandling doRequest_RoadRanking:dic];
        //[http initRequestWithUrl:TrafficIndexURL withDic:dic andUserName:@"Ranking_Road"];
        dic = nil;
    }
}


- (void)AddAnnOnMap:(NSArray *)AnnList
{
    [_citymapView removeAnnotations:Anns_Array];
    [Anns_Array removeAllObjects];
    
    for (RankingInfo *point in AnnList)
    {
        
        CNMKGeoPoint point1;
        point1.latitude =  point.coordinate.latitude;
        
        point1.longitude =point.coordinate.longitude;
        CNMKAnnotation *pointAnnotation = [CNMKAnnotation annotationWithCoordinate:point1];
        
        pointAnnotation.latitude =point.coordinate.latitude;
        pointAnnotation.longitude = point.coordinate.longitude;
        
        
        UILabel *cityLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        cityLabel.layer.cornerRadius = 5;
        cityLabel.textAlignment = NSTextAlignmentCenter;
        cityLabel.text = point.name;
        cityLabel.layer.borderWidth = 0.5;
        cityLabel.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIView *popView;
        popView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 120, 40)];
        popView.backgroundColor = [UIColor whiteColor];
        popView.layer.cornerRadius = 5;
        [popView addSubview:cityLabel];
        
        pointAnnotation.subtitle =point.name;
        
        [self.citymapView addAnnotation:pointAnnotation viewHande:popView customIcon:nil];
        
        [Anns_Array addObject:pointAnnotation];
        
        pointAnnotation = nil;
    }
}

- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView
              viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation
{
    if ([annotation isKindOfClass:[CNMKAnnotation class]])
    {
        CNMKPinView *pinView = [[CNMKPinView alloc]initWithOverlay:annotation] ;
        
        
        UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
        
        for (RankingInfo *info in Rank_Array)    {
            if (info.coordinate.longitude == annotation.coordinate.longitude)
            {
                label.text=info.index;
                label.backgroundColor = [ToolClass IndexToColor:info.index];
                break;
            }
        }
        
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName: @"Helvetica"size:25];
        [viewForImage addSubview:label];
        pinView.image=[ToolClass getImageFromView:viewForImage];
        
        // [pinView setPinColor:arc4random()%3];   //...随机修改颜色，这行可注释掉
        return pinView;
    }
				return nil;
}

-(void)pinIconClickedCB:(NSString *)FunctionName
                    id2:(NSMutableDictionary*)DicGetString id3:(NSInteger)Error
{
    
    [self.citymapView HiddenAnnotationPopAll];
    
}


- (NSArray *)getCurcityDistanceList:(NSString *)cityName
{
    for (CityDistanceInfo *info in cities)
    {
        if ([info.cName isEqualToString:cityName])
        {
            return info.list;
        }
    }
    return nil;
}

- (void)AddpolyLineOnMap:(NSArray *)array
{
    int num= array.count/2;
    CNMKGeoPoint coors[num];
    int count = 0;
    for (int i = 0; i<array.count; i=i+2)
    {
        CNMKGeoPoint TrueGps;
        TrueGps.longitude = [[array objectAtIndex:i]floatValue];
        TrueGps.latitude = [[array objectAtIndex:i+1]floatValue];
        
        coors[count] = TrueGps;
        count++;
    }
    
    CNMKPolyline *polyline = [CNMKPolyline polylineWithGeoPoints:coors count:num];
    [_citymapView addOverlay:polyline];
    
    [Overlays_Array addObject:polyline];
    
    polyline = nil;
}

- (void)filterRoadType
{
    NSArray *array = [roadLevel componentsSeparatedByString:@","];
    [Rank_Array removeAllObjects];
    for (RankingInfo *info in AllRoad_Array)
    {
        for (NSString *kind in array)
        {
            if ([info.kind isEqualToString:kind])
            {
                [Rank_Array addObject:info];
                break;
            }
        }
    }
}

- (void)GetFitRectForLink:(NSArray *)array
{
    float lon_max = 0;
    float lon_min = 0;
    float lat_max = 0;
    float lat_min = 0;
    for (int i = 0; i<array.count; i++)
    {
        float coor = [[array objectAtIndex:i] floatValue];
        if (i%2 == 0)
        {
            if (lon_max < coor)
            {
                lon_max = coor;
            }
            
            if (lon_min > coor || lon_min == 0)
            {
                lon_min = coor;
            }
        }
        else
        {
            if (lat_max < coor)
            {
                lat_max = coor;
            }
            
            if (lat_min > coor || lat_min == 0)
            {
                lat_min = coor;
            }
        }
    }
    
    
//    CNMKGeoPoint coors[2];
//    
//    CNMKGeoPoint Point1;
//    Point1.longitude = lon_max;
//    Point1.latitude = lat_max;
//    coors[0] = Point1;
//    
//    NSLog(@"---%f,%f",lat_max,lon_max);
//    
//    CNMKGeoPoint Point2;
//    Point2.longitude = lon_min;
//    Point2.latitude = lat_min;
//    coors[1] = Point2;
//    
//    CNMKPolyline *polyline = [CNMKPolyline polylineWithGeoPoints:coors count:2];
//    
//    [self.citymapView addOverlay:polyline];
//    
//    [_citymapView setVisibleMapRect:polyline.boundingMapRect animated:YES];
    
}




#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareBtn:(id)sender {
    
    NSString *content = [NSString stringWithFormat:@"%@城市指数%@,平均速度%@,更新时间%@",self.CurCityInfo.name,self.CurCityInfo.index,self.CurCityInfo.speed,self.CurCityInfo.time];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:[ToolClass ViewToImage:self.view]]
                                                title:@"四维交通指数"
                                                  url:@"http://nitrafficindex.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:INHERIT_VALUE
                                        url:INHERIT_VALUE
                                       site:@"四维交通指数"
                                    fromUrl:nil
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:INHERIT_VALUE
                                    playUrl:nil
                                       nswb:nil];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage]
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:nil
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage]
                                          content:INHERIT_VALUE
                                            title:INHERIT_VALUE
                                              url:nil
                                       thumbImage:nil
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage]
                                     content:INHERIT_VALUE
                                       title:INHERIT_VALUE
                                         url:INHERIT_VALUE
                                  thumbImage:INHERIT_VALUE
                                       image:INHERIT_VALUE
                                musicFileUrl:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage]
                              content:INHERIT_VALUE
                                title:INHERIT_VALUE
                                  url:INHERIT_VALUE
                                image:INHERIT_VALUE];
    
    //定制邮件信息
    [publishContent addMailUnitWithSubject:INHERIT_VALUE
                                   content:INHERIT_VALUE
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
   
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_appDelegate.viewDelegate];
    
    
    
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享"
                                                           shareViewDelegate:_appDelegate.viewDelegate];
    
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQ,ShareTypeQQSpace,ShareTypeWeixiFav,ShareTypeWeixiSession,ShareTypeWeixiTimeline, nil];
    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    //use block
                                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"分享成功";
                                    [HUD showAnimated:YES whileExecutingBlock:^{
                                            sleep(2);
                                    } completionBlock:^{  
                                        [HUD removeFromSuperview];  
                                        
                                    }];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    //use block
                                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                                    [self.view addSubview:HUD];
                                    HUD.labelText = @"分享失败";
                                    [HUD showAnimated:YES whileExecutingBlock:^{
                                        sleep(2);
                                    } completionBlock:^{
                                        [HUD removeFromSuperview];
                                        
                                    }];
                                    
                                }
                            }];
}

- (IBAction)historyDataTimeRange:(id)sender {
    if (self.TimeRange.selectedSegmentIndex == 0)
    {
        [self.DateBtn setTitle:[ToolClass stringFromDate_YYYY_MM_DD:selectDate] forState:UIControlStateNormal];
        self.DateBtn.hidden = NO;
    }
    else if(self.TimeRange.selectedSegmentIndex == 1)
    {
        NSString *time = [ToolClass stringFromDate_YYYY_MM_DD:selectDate];
        [self.DateBtn setTitle:[time substringToIndex:time.length - 3] forState:UIControlStateNormal];
        self.DateBtn.hidden = NO;
    }
    else
    {
        self.DateBtn.hidden = YES;
    }
    
    [self GetHistoryDate];
}
- (IBAction)SelectTimeBtn:(id)sender
{
    
    [dateSelectionVC show:self];
}
- (IBAction)RankingKind:(id)sender
{
    [self getRankingInfo];
    
    
    if (self.RankingKind_Seg.selectedSegmentIndex == 2)
    {
         self.RoadTypeBtn.hidden = NO;
    }
    else
    {
         self.RoadTypeBtn.hidden = YES;
    }
}

- (IBAction)ChangeRoadType:(id)sender {
    
    [listView show];
}



#pragma mark implement CNMKMapViewDelegate

- (CNMKOverlayView *)mapView:(CNMKMapView *)mapView viewForOverlay:(id<CNMKOverlay>)overlay {
    if ([overlay isKindOfClass:[CNMKPolyline class]])     {
        CNMKPolylineView * polylineView = [[CNMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [self.roadColor colorWithAlphaComponent:1];
        polylineView.fillColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 4;
        return polylineView;
        
    }     return nil;
}

#pragma mark - DayIndexDelegate
- (void)getDayIndexSuccess:(NSArray*)array
{
    if (array.count != 0)
    {
        [self.ChartActivity stopAnimating];
        
        [DayArray removeAllObjects];
        
        DayArray = [NSMutableArray arrayWithArray:array];
        
        [self reloadBarChart];
    }
    
    
}
- (void)getDayIndexFailed:(NSString*)mes
{
    
}

#pragma mark - MonthIndexDelegate
- (void)getMonthIndexSuccess:(NSArray*)array
{
    
    if (array.count != 0)
    {
        [self.ChartActivity stopAnimating];
        
        [MonthArray removeAllObjects];
        
        MonthArray = [NSMutableArray arrayWithArray:array];
        
        [self reloadBarChart];
    }
    
}
- (void)getMonthIndexFailed:(NSString*)mes
{
    
}
#pragma mark - YearIndexDelegate
- (void)getYearIndexSuccess:(NSArray*)array
{
    if (array.count != 0)
    {
        [self.ChartActivity stopAnimating];
        
        [YearArray removeAllObjects];
        
        YearArray = [NSMutableArray arrayWithArray:array];
        
        [self reloadBarChart];
    }
   
}
- (void)getYearIndexFailed:(NSString*)mes
{
    
}


#pragma mark - DistanceRankingDelegate
- (void)getDistanceRankingSuccess:(NSArray *)array
{
    if (array.count != 0)
    {
        [Rank_Array removeAllObjects];
        Rank_Array = [NSMutableArray arrayWithArray:array];
        [self.RankingTable reloadData];
        [self AddAnnOnMap:Rank_Array];
    }
   
}
- (void)getDistanceRankingFail:(NSString *)mes
{
    
}

#pragma mark - HotspotRankingDelegate
- (void)getHotspotRankingSuccess:(NSArray *)array
{
    if (array.count != 0)
    {
        [Rank_Array removeAllObjects];
        Rank_Array = [NSMutableArray arrayWithArray:array];
        [self.RankingTable reloadData];
        [self AddAnnOnMap:Rank_Array];
    }
 
}
- (void)getHotspotRankingFail:(NSString *)mes
{
    
}

#pragma mark - RoadRankingDelegate
- (void)getRoadRankingSuccess:(NSArray *)array
{
    if (array.count != 0)
    {
        [_citymapView removeAnnotations:Anns_Array];
        [Anns_Array removeAllObjects];
        [AllRoad_Array removeAllObjects];
        
        AllRoad_Array = [NSMutableArray arrayWithArray:array];
        [self filterRoadType];
        [self.RankingTable reloadData];
    }
    
   
}
- (void)getRoadRankingFail:(NSString *)mes
{
    
}

#pragma mark - SingleRoadDelegate
- (void)getSingleRoadSuccess:(NSArray *)array
{
    if (array.count != 0)
    {
        [_citymapView removeOverlays:Overlays_Array];
        [Overlays_Array removeAllObjects];
        //地图显示道路
        NSMutableArray *polyLine = [[NSMutableArray alloc]init];
        for (NSString *rticString in array)
        {
            NSArray *rtic = [rticString componentsSeparatedByString:@" "];
            
            for (NSString *coor in rtic)
            {
                [polyLine addObject:coor];
            }
            [self AddpolyLineOnMap:rtic];
        }
        [self GetFitRectForLink:polyLine];
    }
}
- (void)getSingleRoadFail:(NSString *)mes
{
    
}


#pragma mark - RoadTypeIndexDelegate
- (void)getRoadTypeIndexSuccess:(NSArray *)array
{
     [self InitRoadViewInfo:array];
}
- (void)getRoadTypeIndexFail:(NSString *)mes
{
    
}

/*
#pragma mark - httpDelegate
- (void)finishSuccessRequest:(ASIHTTPRequest *)request
{
    [refreshView endRefreshing];
    
    NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    if ([request.username isEqualToString:@"Day"])
    {
        [self.ChartActivity stopAnimating];
        
        [DayArray removeAllObjects];
        
        NSArray *reJson = [SBJson objectWithString:result];
        if (reJson == nil)
        {
            return;
        }
        NSMutableArray *lines = [[NSMutableArray alloc]init];
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
                [DayArray addObject:avgHour];
                total = 0;
                count = 0;
            }
        }
        
        [self reloadBarChart];
        
        
        reJson = nil;
        lines = nil;
        cIndexs = nil;
        arr = nil;
    }
    else if ([request.username isEqualToString:@"Year"])
    {
        [self.ChartActivity stopAnimating];
        [YearArray removeAllObjects];
        NSArray *reJson = [SBJson objectWithString:result];
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
                [YearArray addObject:[NSArray arrayWithArray:year]];
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
        
        [self reloadBarChart];
        
        reJson = nil;
        yearsName = nil;
        year = nil;
    }
    else if ([request.username isEqualToString:@"Month"])
    {
        [self.ChartActivity stopAnimating];
        
        NSArray *reJson = [SBJson objectWithString:result];
        if (reJson == nil)
        {
            return;
        }
        
        
        [MonthArray removeAllObjects];
        for (NSDictionary *dic in reJson)
        {
            if (![[dic objectForKey:@"cIndex"] isEqual:[NSNull null]])
            {
                [MonthArray addObject:[dic objectForKey:@"cIndex"]];
            }
            
        }
        
        [self reloadBarChart];
        
        reJson = nil;
    }
    else if ([request.username isEqualToString:@"Ranking_Distance"])
    {
       
        
        [Rank_Array removeAllObjects];
        NSArray *reJson = [SBJson objectWithString:result];
       
        
        for (NSDictionary *dic in reJson)
        {
            RankingInfo *info  = [[RankingInfo alloc]init];
            info.name = [dic objectForKey:@"name"];
            info.index = [dic objectForKey:@"cIndex"];
            
            //查询当前行政区中心点坐标
            for (DistanceInfo *disInfo in [self getCurcityDistanceList:self.CurCityInfo.name])
            {
                if ([disInfo.dName isEqualToString:info.name])
                {
                    info.coordinate = disInfo.coordinate;
                    break;
                }
            }

            [Rank_Array addObject:info];
            
        }
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO];
        [Rank_Array sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        [self.RankingTable reloadData];
        
        [self AddAnnOnMap:Rank_Array];
        
        reJson = nil;
    }
    else if ([request.username isEqualToString:@"Ranking_HotSpot"])
    {
        
        
        [Rank_Array removeAllObjects];
        NSArray *reJson = [SBJson objectWithString:result];
        
        
        for (NSDictionary *dic in reJson)
        {
            RankingInfo *info  = [[RankingInfo alloc]init];
            info.name = [dic objectForKey:@"name"];
            Coordinate2D coor;
            coor.longitude = [[dic objectForKey:@"lon"] doubleValue];
            coor.latitude = [[dic objectForKey:@"lat"] doubleValue];
            info.coordinate = coor;
            info.index = [dic objectForKey:@"cIndex"];
            
            [Rank_Array addObject:info];
        }
        
        [self.RankingTable reloadData];
        
        [self AddAnnOnMap:Rank_Array];
        
        reJson = nil;
    }
    else if ([request.username isEqualToString:@"Ranking_Road"])
    {
        [_mapView removeAnnotations:Anns_Array];
        [Anns_Array removeAllObjects];
        [AllRoad_Array removeAllObjects];
        NSArray *reJson = [SBJson objectWithString:result];
        
        for (NSDictionary *dic in reJson)
        {
            RankingInfo *info  = [[RankingInfo alloc]init];
            info.name = [dic objectForKey:@"name"];
            info.index = [dic objectForKey:@"cIndex"];
            info.RoadID = [dic objectForKey:@"code"];
            info.kind = [dic objectForKey:@"kind"];
            [AllRoad_Array addObject:info];
        }
        [self filterRoadType];
        [self.RankingTable reloadData];
        
        reJson = nil;
    }
    else if ([request.username isEqualToString:@"SingleRoad"])
    {
        
        [_mapView removeOverlays:Overlays_Array];
        [Overlays_Array removeAllObjects];
        //地图显示道路
        
        NSArray *roads = [SBJson objectWithString:result];
        NSString *latlons = [[roads firstObject] objectForKey:@"rticLonlats"];
        NSArray *rtics = [latlons componentsSeparatedByString:@","];
        NSMutableArray *polyLine = [[NSMutableArray alloc]init];
        
        for (NSString *rticString in rtics)
        {
            NSArray *rtic = [rticString componentsSeparatedByString:@" "];
            
            for (NSString *coor in rtic)
            {
                [polyLine addObject:coor];
            }
            [self AddpolyLineOnMap:rtic];
        }
        [self GetFitRectForLink:polyLine];
        
        roads = nil;
        latlons = nil;
        rtics = nil;
        polyLine = nil;
    }
    else if ([request.username isEqualToString:@"RoadKindIndex"])
    {
         NSArray *reArray = [SBJson objectWithString:result];
        [self InitRoadViewInfo:reArray];
        
        reArray = nil;
    }
    
    result = nil;
}

- (void)finishFailRequest:(ASIHTTPRequest *)request
{
     [refreshView endRefreshing];
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Rank_Array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankingTableViewCell *cell;
    
    static NSString *CellIdentifier = @"RankingTableViewCell";
    //static BOOL nibsRegistered = NO;
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"RankingTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RankingInfo *info = [Rank_Array objectAtIndex:indexPath.row];
    cell.NameLabel.text = info.name;
    cell.IndexLabel.text = info.index;
    cell.IndexLabel.layer.cornerRadius = 5;
    cell.IndexLabel.backgroundColor = [ToolClass IndexToColor:info.index];
    
    info = nil;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    if (self.RankingKind_Seg.selectedSegmentIndex == 2)
    {
        RankingInfo *roadInfo = [Rank_Array objectAtIndex:indexPath.row];
        if (roadInfo != nil)
        {
            self.roadColor = [ToolClass IndexToColor:roadInfo.index];
            NSDictionary *dic = @{@"cityCode": cityCode,@"roadName":roadInfo.name,@"method":@"10"};
            
            [AppDelegate getApplicationDelegate].RequestHandling.SingleRoadRanking_delegate = self;
            [[AppDelegate getApplicationDelegate].RequestHandling doRequest_SingleRoadRanking:dic];
            
            
            dic = nil;
        }
        roadInfo = nil;
       
    }
    else
    {
        RankingInfo *info = [Rank_Array objectAtIndex:indexPath.row];
        CNMKGeoPoint coor;
        coor.longitude = info.coordinate.longitude;
        coor.latitude = info.coordinate.latitude;
        [_citymapView setCenterCoordinate:coor animated:YES];
        
        for (CNMKAnnotation *ann in Anns_Array)
        {
            if (ann.coordinate.longitude == info.coordinate.longitude)
            {
                [_citymapView selectAnnotation:ann animated:YES];
            }
            else
            {
                [_citymapView deselectAnnotation:ann animated:YES];
            }
        }
        info = nil;
    }
}

#pragma mark - ZSYPopoverListDelegate
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [RoadTypes objectAtIndex:indexPath.row];
    if (indexPath.row != 3)
    {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}



- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView popoverDeselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *statue = [RoadType_statue objectForKey:[RoadTypes objectAtIndex:indexPath.row]];
    
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    
    if ([statue intValue] == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [RoadType_statue setObject:@"1" forKey:[RoadTypes objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [RoadType_statue setObject:@"0" forKey:[RoadTypes objectAtIndex:indexPath.row]];
    }
    cell = nil;
    
}
#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    
    selectDate = aDate;
    
    if (self.TimeRange.selectedSegmentIndex == 0)
    {
        [self.DateBtn setTitle:[ToolClass stringFromDate_YYYY_MM_DD:aDate] forState:UIControlStateNormal];
    }
    else if (self.TimeRange.selectedSegmentIndex == 1)
    {
        NSString *time = [ToolClass stringFromDate_YYYY_MM_DD:aDate];
        
        [self.DateBtn setTitle:[time substringToIndex:time.length - 3] forState:UIControlStateNormal];
    }
    else if(self.TimeRange.selectedSegmentIndex == 2)
    {
        
    }
    [self GetHistoryDate];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

#pragma mark - BarChart Delegates
- (NSInteger)numberOfSectionsInBarChartView:(RWBarChartView *)barChartView
{
    if(self.TimeRange.selectedSegmentIndex == 2)
    {
        return YearArray.count;
    }
    else
    {
        return 1;
    }
   
}

- (NSInteger)barChartView:(RWBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section
{
    
    if (self.TimeRange.selectedSegmentIndex == 0)
    {
        return DayArray.count;
    }
    else if (self.TimeRange.selectedSegmentIndex == 1)
    {
        return MonthArray.count;
    }
    else if (self.TimeRange.selectedSegmentIndex == 2)
    {
        NSArray *arr = [YearArray objectAtIndex:section];
        return arr.count;
    }
    else
    {
         return 0;
    }
   
   
    
}

- (id<RWBarChartItemProtocol>)barChartView:(RWBarChartView *)barChartView barChartItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *items = self.singleItems;
    

    return items[indexPath];
}

- (NSString *)barChartView:(RWBarChartView *)barChartView titleForSection:(NSInteger)section
{
    if (self.TimeRange.selectedSegmentIndex == 2)
    {
        int StartYear = 2013;
        return [NSString stringWithFormat:@"%d年",StartYear+section];
    }
    return nil;
}

- (BOOL)shouldShowItemTextForBarChartView:(RWBarChartView *)barChartView
{
    return barChartView == self.BarChart;
}

- (BOOL)barChartView:(RWBarChartView *)barChartView shouldShowAxisAtRatios:(out NSArray *__autoreleasing *)axisRatios withLabels:(out NSArray *__autoreleasing *)axisLabels
{
    
    if (self.TenMax)
    {
        *axisRatios = @[@(0.20), @(0.40), @(0.60), @(0.80), @(1.0)];
        *axisLabels = @[@"2", @"4", @"6", @"8", @"10"];
    }
    else
    {
        *axisRatios = @[@(0.20), @(0.40), @(0.60), @(0.80), @(1.0)];
        *axisLabels = @[@"4", @"8", @"12", @"16", @"20"];
    }
    
    
    return YES;
}


@end
