//
//  AppDelegate.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-18.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SBJson.h"
#import "WXApi.h"
#import "AGViewDelegate.h"
#import "DataRequestAndHandling.h"
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,CLLocationManagerDelegate>
{
    SBJsonParser *SBJson;
    enum WXScene _scene;
    AGViewDelegate *_viewDelegate;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,readonly) AGViewDelegate *viewDelegate;

//定义一些全局变量
@property (nonatomic,retain) NSString *locCity;  //定位城市
@property (nonatomic,assign) BOOL isLocation;    //是否开启定位功能
@property (nonatomic,retain) DataRequestAndHandling *RequestHandling;  

+ (AppDelegate*)getApplicationDelegate;
@end
