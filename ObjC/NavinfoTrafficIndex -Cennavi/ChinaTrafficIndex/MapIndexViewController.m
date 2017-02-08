//
//  MapIndexViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-16.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "MapIndexViewController.h"
#import "RankingInfo.h"
#import "CityDistanceInfo.h"
#import "CNMKPinView.h"
#define CLUserPoint [[self.indexmapView userLocation] coordinate]

@interface MapIndexViewController ()


- (IBAction)back:(id)sender;
@end

@implementation MapIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Ranking_Array = [[NSMutableArray alloc]init];
    cities = [CityDistanceInfo getCityListInfo];
    
    [self.view addSubview:self.indexmapView];
    
    [self SendHttpRequest];
    // Do any additional setup after loading the view.
    

}

-(CNMKMapView *)indexmapView
{
    if (_indexmapView ==nil) {
        NSInteger height = self.view.frame.size.height;
        NSInteger width = self.view.frame.size.width;
        _indexmapView =[[CNMKMapView alloc]initWithFrame:CGRectMake(0, 64, width, height-64)];
        _indexmapView.gNoteCBDelegate = self;
        [self.indexmapView setMapType:CNMKMapTypeStandard];
        [self.indexmapView setShowsUserLocation:YES];
        
        [self.indexmapView setZoomLevel:5];
        
        [self gotoUserLoc];
    }
    
    return _indexmapView;
}

- (void)gotoUserLoc{
    
    
    if (0.001 > fabs(CLUserPoint.latitude) || 0.001 > fabs(CLUserPoint.longitude))
    {
        return;
    }
    [self.indexmapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(CLUserPoint)];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    //[_mapView viewWillAppear];
    _indexmapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:NO];
    //[_mapView viewWillDisappear];
    _indexmapView.delegate = nil; // 不用时，置nil

  
    //_indexmapView = nil;
}
- (void)SendHttpRequest
{
    NSDictionary *dic = @{@"byJamRanking": @"true",@"area":@"98",@"timeRange":@"0",@"method":@"1"};
    [AppDelegate getApplicationDelegate].RequestHandling.CityRanking_delegate = self;
    [[AppDelegate getApplicationDelegate].RequestHandling doRequest_CityRanking:dic];
    dic = nil;
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
- (void)AddAnnOnMap:(NSArray *)AnnList
{
   
    
    for (RankingInfo *point in AnnList)
    {
        CNMKGeoPoint point1;
        point1.latitude =  point.coordinate.latitude;

        point1.longitude =point.coordinate.longitude;
         CNMKAnnotation *pointAnnotation = [CNMKAnnotation annotationWithCoordinate:point1];
        
        pointAnnotation.latitude =point.coordinate.latitude;
        pointAnnotation.longitude = point.coordinate.longitude;

        
        UILabel *cityLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        cityLabel.layer.cornerRadius = 5;
        cityLabel.textAlignment = NSTextAlignmentCenter;
        cityLabel.text = point.name;
        cityLabel.layer.borderWidth = 0.5;
        cityLabel.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIView *popView;
        popView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 100, 40)];
        popView.backgroundColor = [UIColor whiteColor];
        popView.layer.cornerRadius = 5;
        [popView addSubview:cityLabel];
        
        pointAnnotation.subtitle =point.name;
        
        [self.indexmapView addAnnotation:pointAnnotation viewHande:popView customIcon:nil];
        
        pointAnnotation = nil;
    }
}
#pragma mark implement CNMKMapViewDelegate

- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView
              viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation
{
    if ([annotation isKindOfClass:[CNMKAnnotation class]])
    {
        CNMKPinView *pinView = [[CNMKPinView alloc]initWithOverlay:annotation] ;
        
        
        UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
       
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
        
        for (RankingInfo *info in Ranking_Array)    {
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
    
    [self.indexmapView HiddenAnnotationPopAll];
    
    //    if ([DicGetString[@"2"] integerValue]  == 10) {
    //
    //        [SVProgressHUD showInfoWithStatus:@"事件正在审核"];
    //
    //        [SVProgressHUD dismissWithDelay:5.0];
    //        return;
    //        LTLog(@"ddddddddddd");
    //    }
    // LTLog(@"%@",DicGetString);
   // [self cilkShowRoadCitonDetail:DicGetString];
}



// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(CNMKMapView *)mapView annotationViewForBubble:(CNMKAnnotationView *)view;
{
    
//    for (RankingInfo *info in Ranking_Array)
//    {
//        if ([view.overlay.coordinate isEqualToString:info.name])
//        {
//            [self dismissViewControllerAnimated:YES completion:^(void)
//             {
//                 for (CityDistanceInfo *city in cities)
//                 {
//                     if ([city.cName isEqualToString:info.name])
//                     {
//                         NSString *codeAndName = [NSString stringWithFormat:@"%@,%@",city.code,city.cName];
//                         [[NSNotificationCenter defaultCenter] postNotificationName:@"SingleCity" object:codeAndName userInfo:nil];
//                         break;
//                     }
//                 }
//             }];
//            
//            break;
//        }
//    }
}

#pragma mark - httpDelegate
- (void)getCityRankingDidSuccess:(NSArray *)array
{
    [Ranking_Array removeAllObjects];
    Ranking_Array = [NSMutableArray arrayWithArray:array];
    [self AddAnnOnMap:Ranking_Array];
}
- (void)getCityRankingDidFailed:(NSString *)mes
{
    
}

/*
#pragma mark - httpDelegate
- (void)finishSuccessRequest:(ASIHTTPRequest *)request
{
    NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    NSArray *reString = [SBJson objectWithString:result];
    
    for (NSDictionary *dic in reString)
    {
        RankingInfo *info = [[RankingInfo alloc]init];
        NSString *cityName = [dic objectForKey:@"city"];
        info.name = [cityName substringToIndex:cityName.length-3];
        info.index = [dic objectForKey:@"cIndex"];
        //查询当前行政区中心点坐标
        for (CityDistanceInfo *cityInfo in cities)
        {
            if ([cityInfo.cName isEqualToString:info.name])
            {
                info.coordinate = cityInfo.coordinate;
                break;
            }
        }
        [Ranking_Array addObject:info];
        
        info = nil;
    }
    
    [self AddAnnOnMap:Ranking_Array];
    
    result = nil;
    reString = nil;
}
- (void)finishFailRequest:(ASIHTTPRequest *)request
{
    
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
