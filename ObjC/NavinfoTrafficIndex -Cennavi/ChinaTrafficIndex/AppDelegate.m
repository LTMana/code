//
//  AppDelegate.m
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-18.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "AppDelegate.h"
#import "CNMKSysConfigure.h"
#import "CNMKManager.h"
#import "CityDistanceInfo.h"
#import "DistanceInfo.h"
#import "MTA.h"
#import "MTAConfig.h"
#import <ShareSDK/ShareSDK.h>
#import "ToolClass.h"
#import "CityListInfo.h"

@implementation AppDelegate
//...中文瓦片地图地址
#define HTTPURL_MAP_CN @"http:www.trafficeye.com.cn/fmapimg_bigfont_chi_day"
//...路况地图地址
#define HTTPURL_MAP_DTM     @"http://www.trafficeye.com.cn/dtmimg/"
@synthesize viewDelegate = _viewDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Sysfmappmg_cn = HTTPURL_MAP_CN;
    Sysdtmimg = HTTPURL_MAP_DTM;
    
    //...注册启动地图
    CNMKManager *manager = [[CNMKManager alloc] init];
    BOOL registerState = [manager start:@"Basic Y2VubmF2aVRlc3Q6Y2VubmF2aVRlc3Q="];
    if (registerState == NO)
    {
        NSLog(@"当前授权失败!");
    }
    else
    {
        NSLog(@"当前授权成功!");
    }

    _viewDelegate = [[AGViewDelegate alloc] init];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
    
    //腾讯云统计注册
    [MTA startWithAppkey:@"IC8K2DF9XY3J"];
    
    
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"4a1510bfc4d4"];
    
    [self initShareSDk];
    
    
    self.RequestHandling = [[DataRequestAndHandling alloc]init];
    [self.RequestHandling StartRequestQueue];//开启队列
    
    //读取配置文件，是否打开定位功能
    [self ReadLocationOn];
    
   
    
    return YES;
}

- (void)initShareSDk
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1103566343"
                           appSecret:@"JUHlLKZLVIRCGDm6"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
   
    [ShareSDK connectWeChatWithAppId:@"wx3ce5dc0e755cb6ff"
                           appSecret:@"0ff4e83c9dd829aaaede0f01e5dbc7db"
                           wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1103566343"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //连接邮件
    [ShareSDK connectMail];
    
    //连接打印
    [ShareSDK connectAirPrint];
    
    //连接拷贝
    [ShareSDK connectCopy];
    
  
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self SavePlistToUserDefaults];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

+ (AppDelegate*)getApplicationDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

//读取配置文件
- (void)ReadLocationOn
{
    NSString *filePath = [ToolClass getDocument:@"AppIni.plist"];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    //文件不存在 创建文件 默认值No
    if (dic == nil) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        NSDictionary *SaveDic = @{@"islocationCity":@"NO"};
        
        [SaveDic writeToFile:filePath atomically:YES];
        
        [AppDelegate getApplicationDelegate].isLocation = NO;
        return;
    }
    
    if ([[dic objectForKey:@"islocationCity"] isEqualToString:@"YES"])
    {
        [AppDelegate getApplicationDelegate].isLocation = YES;
    }
    else
    {
        [AppDelegate getApplicationDelegate].isLocation = NO;
    }
}


- (void)SavePlistToUserDefaults
{
    
    NSString *filePath = [ToolClass getDocument:@"UserCityList.plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableArray *CityList = [[NSMutableArray alloc] init];
    
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
        
        [CityList addObject:cityInfo];
    }
    
    
   //把UserCityList.plist信息存入UserDefaults
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.cennavi.NaviInfoTrafficIndex"];
  
    
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    for(CityListInfo *Cityinfo in CityList)
    {
    
        NSDictionary *cityDic = @{@"name":Cityinfo.name,@"code":Cityinfo.code,@"location":Cityinfo.location,@"weatherCode":Cityinfo.weatherCode};
        
        [defaults setObject:cityDic forKey:Cityinfo.name];
        
        [keys addObject:Cityinfo.name];
       
    }
    
    [defaults setObject:keys forKey:@"CityNames"];
    
    [defaults synchronize];
    
}
@end
