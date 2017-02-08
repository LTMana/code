//
//  HomeListViewController.m
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-18.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "HomeListViewController.h"
#import "CityTableViewCell.h"
#import "HATransparentView.h"
#import "ToolClass.h"
#import "CityDistanceInfo.h"
@interface HomeListViewController ()<HATransparentViewDelegate>

@property (strong, nonatomic) HATransparentView *transparentView;
@property (strong, nonatomic) NSArray *menu;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *CityListTable;
- (IBAction)MenuBtn:(id)sender;
- (IBAction)SearchBtn:(id)sender;
- (IBAction)loadDataFail:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loadDataFailBtn;

@property(nonatomic,retain)CLLocationManager *locationManager;
@end

@implementation HomeListViewController
@synthesize CityList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _menu = @[@"编辑城市", @"交通指数地图", @"排行榜",@"四维交通指数报告",@"关于本应用"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SingleCity:) name:@"SingleCity" object:nil];
    

    CurCityInfo = [[CityListInfo alloc]init];
    
    
    self.CityListTable.backgroundView.backgroundColor = [UIColor clearColor];
    
    [self ReadCityListFile];
    
    [self.actView startAnimating];
    self.CityListTable.hidden = YES;
    self.loadDataFailBtn.hidden = YES;
    [self SendAllCityRequest];
    
  
    [self GetAllCityWeatherInfo];
    
    
    // 1.注册
    NSString *const MJTableViewCellIdentifier = @"Cell";
    
    [self.CityListTable registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    [self addHeader];
    
    [self ShowReportAlert];
    
    [self locate];
}

- (void)ShowReportAlert
{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"StartTime"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DontShowReportAlert"];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"2015四维交通指数Q1季度报告发布啦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alert show];
    }
    else
    {
        NSDate *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"StartTime"];
        NSDate *now = [NSDate date];
        NSString *NowDate = [ToolClass stringFromDate_YYYY_MM_DD:now];
        
        NSTimeInterval secs = [now timeIntervalSinceDate:startTime];
        
        BOOL Dontshow = [[NSUserDefaults standardUserDefaults] boolForKey:@"DontShowReportAlert"];
        BOOL haveShowedToday = [[NSUserDefaults standardUserDefaults] boolForKey:NowDate];
        //两周内提示
        if (secs <= 60*60*24*14 && !Dontshow)
        {
            if (haveShowedToday)
            {
                return;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"2014四维交通指数年度报告发布啦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
                [alert show];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NowDate];
            }
           
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        [self performSegueWithIdentifier:@"ToSendReportView" sender:self];
    }
}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    refreshHeaderView = header;
    
    header.scrollView = self.CityListTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self SendAllCityRequest];
        [self GetAllCityWeatherInfo];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
               // NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
               // NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                //NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
}

- (void)ReadCityListFile
{
   NSString *filePath = [ToolClass getDocument:@"UserCityList.plist"];
   NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
   CityList = [[NSMutableArray alloc] init];
    
   BOOL lostWeatherCode = NO;
    //读取基本信息
   for (NSString *cityName in [dic allKeys])
   {
        NSDictionary *dictionary = [dic objectForKey:cityName];
        CityListInfo *cityInfo = [[CityListInfo alloc]init];
        cityInfo.name = cityName;
        cityInfo.code = [dictionary objectForKey:@"code"];
        cityInfo.speed = [dictionary objectForKey:@"speed"];
        cityInfo.statue = [dictionary objectForKey:@"statue"];
        cityInfo.index = [dictionary objectForKey:@"index"];
        cityInfo.time = [dictionary objectForKey:@"time"];
        cityInfo.Json = [dictionary objectForKey:@"json"];
        cityInfo.location = [dictionary objectForKey:@"location"];
        cityInfo.weatherCode = [dictionary objectForKey:@"weatherCode"];
        cityInfo.color = [ToolClass IndexToColor:cityInfo.index];
       
       if (cityInfo.weatherCode == nil)
       {
           lostWeatherCode = YES;
       }
        [CityList addObject:cityInfo];
    }
    
    //增加weathercode字段
    if(lostWeatherCode)
    {
        NSArray *cities = [CityDistanceInfo getCityListInfo];
        
        for (CityListInfo *info in CityList)
        {
            for (CityDistanceInfo *cityInfo in cities)
            {
                if ([info.name isEqualToString:cityInfo.cName])
                {
                    info.weatherCode = cityInfo.weatherCode;
                    break;
                }
            }
        }
    }
    
    //根据位置信息排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES];
    [CityList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //列表中没有数据，添加默认城市北、上、广、深。
   if (dic == nil)
   {
       NSFileManager* fm = [NSFileManager defaultManager];
       [fm createFileAtPath:filePath contents:nil attributes:nil];
       
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
       
       [CityList addObject:beijing];
       [CityList addObject:shanghai];
       [CityList addObject:guangzhou];
       [CityList addObject:shenzhen];
       beijing = nil;
       shanghai = nil;
       guangzhou = nil;
       shenzhen = nil;
       //保存文件
       
       NSMutableDictionary *SaveDic = [[NSMutableDictionary alloc]init];
       for(CityListInfo *Cityinfo in CityList)
       {
           NSDictionary *cityDic = @{@"name":Cityinfo.name,@"code":Cityinfo.code,@"location":Cityinfo.location,@"weatherCode":Cityinfo.weatherCode};
           
           [SaveDic setObject:cityDic forKey:Cityinfo.name];
       }

       [SaveDic writeToFile:filePath atomically:YES];
       
       SaveDic = nil;
   }
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self SendAllCityRequest];
    [self GetAllCityWeatherInfo];
    [_CityListTable reloadData];
    
}

- (void)GetAllCityWeatherInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    for (CityListInfo *city in CityList)
    {
        [params setObject:city.weatherCode forKey:city.name];
    }
    
    [AppDelegate getApplicationDelegate].RequestHandling.CityListWeather_delegate = self;
    [[AppDelegate getApplicationDelegate].RequestHandling doRequest_CityListWeather:params];
    
}
//请求各个城市数据
- (void)SendAllCityRequest
{
    
    self.loadDataFailBtn.hidden = YES;
    
    NSMutableString *citysCode = [[NSMutableString alloc]init];
    for(CityListInfo *city in CityList)
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
    
    NSDictionary *dic = @{@"cityCodes":citysCode,@"byJamRanking": @"true",@"area":@"98",@"timeRange":@"0",@"method":@"1"};
    [AppDelegate getApplicationDelegate].RequestHandling.CityList_delegate = self;
    [[AppDelegate getApplicationDelegate].RequestHandling doRequest_CityList:dic];

    
    citysCode = nil;
    dic = nil;
}

- (void)SendSingleCityRequest:(NSString *)cityCode withCityName:(NSString *)cityName
{
    NSDictionary *queryCityRealtime = @{@"cityCode": cityCode,@"needVkt":@"false",@"method":@"0"};
    
    [AppDelegate getApplicationDelegate].RequestHandling.SingleCityInfo_delegate = self;
    [[AppDelegate getApplicationDelegate].RequestHandling doRequest_SingleCityInfo:queryCityRealtime];
   
}

- (void)SingleCity:(NSNotification *)note
{
    isSingleCity = YES;
    NSString *codeAndName = note.object;
    NSArray *array = [codeAndName componentsSeparatedByString:@","];
    
    BOOL isExist = NO;
    //如果已经存在直接跳转
    for (CityListInfo *info in CityList)
    {
        if ([info.name isEqualToString:[array objectAtIndex:1]])
        {
            isExist = YES;
            CurCityInfo = info;
            break;
        }
    }
    if (isExist)
    {
        [self performSegueWithIdentifier:@"MainToDetailView" sender:self];
    }
    else
    {
        //如果不存在请求数据后跳转
        [self SendSingleCityRequest:[array objectAtIndex:0] withCityName:[array objectAtIndex:1]];
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"MainToDetailView"])
    {
        id theSegue = segue.destinationViewController;
        //跳转到单个城市详细信息界面（仅用于全部城市列表跳转）
        if (isSingleCity)
        {
            isSingleCity = NO;
            [theSegue setValue:CurCityInfo forKey:@"CurCityInfo"];
        }
        //跳转到单个城市详细信息界面
        if (CityList.count != 0)
        {
            [theSegue setValue:CurCityInfo forKey:@"CurCityInfo"];
        }
    }
    //跳转到编辑城市列表界面
    else if ([segue.identifier isEqualToString:@"HomeToEditCityListView"])
    {
        id theSegue = segue.destinationViewController;

        [theSegue setValue:CityList forKey:@"CityList"];
    }
}


- (IBAction)MenuBtn:(id)sender
{
    
    _transparentView = [[HATransparentView alloc] init];
    _transparentView.delegate = self;
    [_transparentView open];
    
    // Add a tableView
    _MenuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _transparentView.frame.size.width, _transparentView.frame.size.height - 64)];
    _MenuTable.delegate = self;
    _MenuTable.dataSource = self;
    _MenuTable.backgroundColor = [UIColor clearColor];
    _MenuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_transparentView addSubview:_MenuTable];
}

- (IBAction)SearchBtn:(id)sender {
    
}

- (IBAction)loadDataFail:(id)sender {
    
    [self.actView startAnimating];
    [self SendAllCityRequest];
}

#pragma mark - getCityListWeatherdelegate
- (void)getCityListWeatherInfoSuccess:(NSArray *)array
{
    for (CityListInfo *newInfo in array)
    {
        for (CityListInfo *oldInfo in CityList)
        {
            if ([newInfo.name isEqualToString:oldInfo.name])
            {
                oldInfo.temperature = newInfo.temperature;
                oldInfo.weatherType = newInfo.weatherType;
                break;
            }
        }
    }
}
- (void)getCityListWeatherInfoFail:(NSString *)mes
{
    
}
#pragma mark - getCityListdelegate
- (void)getCityListDidSuccess:(NSArray *)array
{
    [refreshHeaderView endRefreshing];
    
    [self.actView stopAnimating];
    
    self.CityListTable.hidden = NO;
    
    for (CityListInfo *newCity in array)
    {
        for (CityListInfo *oldCity in CityList)
        {
            if ([oldCity.name isEqualToString:newCity.name])
            {
                oldCity.index = newCity.index;
                oldCity.speed = newCity.speed;
                oldCity.statue = newCity.statue;
                oldCity.time = newCity.time;
                oldCity.color = newCity.color;
                break;
            }
        }
    }
    [self.CityListTable reloadData];
    
  
    
}
- (void)getCityListDidFailed:(NSString *)mes
{
    [self.actView stopAnimating];
    
    if (self.CityListTable.hidden)
    {
        self.loadDataFailBtn.hidden = NO;
    }
    else
    {
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"数据加载失败", nil)
                                    subtitle:NSLocalizedString(@"请检查网络连接", nil)
                                        type:TSMessageNotificationTypeError];
    }
    
    [refreshHeaderView endRefreshing];
}

#pragma mark - getSingleCityInfodelegate
- (void)getSingleCityInfoSuccess:(CityListInfo *)info
{
    CurCityInfo = info;
    [self performSegueWithIdentifier:@"MainToDetailView" sender:self];
}
- (void)getSingleCityInfoFail:(NSString *)mes
{
    
}

/*
#pragma mark - httpDelegate
- (void)finishSuccessRequest:(ASIHTTPRequest *)request
{
    
    if ([request.username isEqualToString:@"CityIndex"])
    {
        [refreshHeaderView endRefreshing];
        
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        NSArray *reJson = [SBJson objectWithString:result];
        
        if (isSingleCity)
        {
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
            
            CurCityInfo = info;
            [self performSegueWithIdentifier:@"MainToDetailView" sender:self];
        }
        else
        {
            
            [self.actView stopAnimating];
            
            self.CityListTable.hidden = NO;
            
            for (NSDictionary *dic in reJson)
            {
                NSString *str = [dic objectForKey:@"city"];
                NSString *cityName = [str substringToIndex:str.length-3];
                
                for (CityListInfo *cityinfo in CityList)
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
            
            [self.CityListTable reloadData];
        }
    }
    else
    {
        
        
        NSString *result = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        NSRange range;
        range.location = 5;
        range.length = result.length-6;
        
        NSString *weatherResult = [result substringWithRange:range];
        NSDictionary *reJson = [SBJson objectWithString:weatherResult];
        NSDictionary *weatherInfo = [reJson objectForKey:@"weatherInfo"];
        
        BOOL refresh = YES;
        for (CityListInfo *info in CityList)
        {
            if ([info.name isEqualToString:request.username])
            {
                info.temperature = [weatherInfo objectForKey:@"t1Temperature"];
                info.weatherType = [weatherInfo objectForKey:@"t1WeatherDesc"];
                
            }
            
            if (info.temperature == nil)
            {
                refresh = NO;
            }
        }
        
        
        
        if (refresh)
        {
            [self.CityListTable reloadData];
        }
    }
    
    
    
}


- (void)finishFailRequest:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"CityIndex"])
    {
        [self.actView stopAnimating];
        
        if (self.CityListTable.hidden)
        {
            self.loadDataFailBtn.hidden = NO;
        }
        else
        {
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"数据加载失败", nil)
                                        subtitle:NSLocalizedString(@"请检查网络连接", nil)
                                            type:TSMessageNotificationTypeError];
        }
        
        [refreshHeaderView endRefreshing];
    }
    else
    {
        
    }
}
*/

- (NSString *)WeatherTypeToImageName:(NSString *)type
{
   
    
    if (![type isKindOfClass:[NSString class]])
    {
         return @"weather_s_15.png";
    }
    
    
    if ([type isEqualToString:@"晴"])
    {
        return [NSString stringWithFormat:@"weather_s_1.png"];
    }
    else if ([type isEqualToString:@"多云"])
    {
        return [NSString stringWithFormat:@"weather_s_2.png"];
    }
    else if ([type isEqualToString:@"阵雨"])
    {
        return [NSString stringWithFormat:@"weather_s_3.png"];
    }
    else if ([type isEqualToString:@"雷阵雨伴有冰雹"])
    {
        return [NSString stringWithFormat:@"weather_s_4.png"];
    }
    else if ([type isEqualToString:@"雨夹雪"])
    {
        return [NSString stringWithFormat:@"weather_s_5.png"];
    }
    else if ([type isEqualToString:@"雷阵雨"])
    {
        return [NSString stringWithFormat:@"weather_s_6.png"];
    }
    else if ([type isEqualToString:@"小雨"])
    {
        return [NSString stringWithFormat:@"weather_s_7.png"];
    }
    else if ([type isEqualToString:@"中雨"])
    {
        return [NSString stringWithFormat:@"weather_s_8.png"];
    }
    else if ([type isEqualToString:@"大雨"])
    {
        return [NSString stringWithFormat:@"weather_s_9.png"];
    }
    else if ([type isEqualToString:@"小雪"])
    {
        return [NSString stringWithFormat:@"weather_s_10.png"];
    }
    else if ([type isEqualToString:@"中雪"])
    {
        return [NSString stringWithFormat:@"weather_s_11.png"];
    }
    else if ([type isEqualToString:@"大雪"])
    {
        return [NSString stringWithFormat:@"weather_s_12.png"];
    }
    else if ([type isEqualToString:@"霾"])
    {
        return [NSString stringWithFormat:@"weather_s_13.png"];
    }
    else if ([type isEqualToString:@"雾"])
    {
        return [NSString stringWithFormat:@"weather_s_14.png"];
    }
    else
    {
        return [NSString stringWithFormat:@"weather_s_15.png"];
    }
}


#pragma mark - locationManager

- (void)locate

{
    self.locationManager = [[CLLocationManager alloc] init] ;
    
    self.locationManager.delegate = self;
    
    
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             NSString * nowCity = [placemark.locality substringWithRange:NSMakeRange(0,2)];
             
             [AppDelegate getApplicationDelegate].locCity = nowCity;
             
         }
     }];
    
    [manager stopUpdatingLocation];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _MenuTable)
    {
        return 1;
    }
    else
    {
        return [CityList count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _MenuTable)
    {
        return _menu.count;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _MenuTable)
    {
        UITableViewCell *cell;
        static NSString *cellId = @"cellId";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.textLabel.text = _menu[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:143/255.0 blue:213/255.0 alpha:1.0];
        /*
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"menu_citylist"];
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"menu_map"];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"menu_rank"];
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"menu_info"];
                break;
                
            default:
                break;
        }
         */
        
        return cell;
    }
    else
    {
        CityTableViewCell *cell;
        
        static NSString *CellIdentifier = @"CityTableViewCell";
        //static BOOL nibsRegistered = NO;
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"CityTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.imageView.layer.shadowOffset = CGSizeMake(3, 3);
        cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        
       
        
        
        CityListInfo *info = [CityList objectAtIndex:indexPath.section];
        cell.CityName.text = info.name;
        cell.Statue.text = info.statue;
        cell.Statue.layer.cornerRadius = 5;
        cell.Statue.backgroundColor = info.color;
        cell.Speed.text = info.speed;
        cell.Index.text = info.index;
        cell.Time.text = info.time;
        cell.weatherType.image = [UIImage imageNamed:[self WeatherTypeToImageName:info.weatherType]];
        
        
        if ([info.name isEqualToString:[AppDelegate getApplicationDelegate].locCity])
        {
            cell.locationImage.hidden = NO;
        }
        else
        {
            cell.locationImage.hidden = YES;
        }
        
        if (info.temperature != nil)
        {
            cell.TemperatureLabel.text = [NSString stringWithFormat:@"%@℃",info.temperature];
        }
        else
        {
            cell.TemperatureLabel.text = @"";
        }
    
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _MenuTable)
    {
        
        switch (indexPath.row) {
                //编辑城市界面
            case 0:
                isToEditView = YES;
                [self performSegueWithIdentifier:@"HomeToEditCityListView" sender:self];
                break;
                //地图显示指数界面
            case 1:
                [self performSegueWithIdentifier:@"ToMapIndexView" sender:self];
                break;
                //指数排行界面
            case 2:
                [self performSegueWithIdentifier:@"ToIndexRangkingView" sender:self];
                break;
                //关于界面
            case 3:
                [self performSegueWithIdentifier:@"ToSendReportView" sender:self];
                break;
                //关于界面
            case 4:
                [self performSegueWithIdentifier:@"ToAboutView" sender:self];
                break;
            default:
                break;
        }
        [_transparentView close];
    }
    else
    {
        CurCityInfo = [CityList objectAtIndex:indexPath.section];
        [self performSegueWithIdentifier:@"MainToDetailView" sender:self];
    }
}
#pragma mark - HATransparentViewDelegate

- (void)HATransparentViewDidClosed
{
   
}


@end
