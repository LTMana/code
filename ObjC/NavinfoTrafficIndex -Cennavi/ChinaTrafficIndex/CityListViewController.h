//
//  CityListViewController.h
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-14.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityListViewController : UIViewController
{
    NSArray *cities;
}
@property(nonatomic,retain)NSString *isEditCityView;    //编辑城市列表界面跳转来，添加城市
@end
