//
//  CityTableViewCell.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-18.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CityName;
@property (weak, nonatomic) IBOutlet UILabel *Index;
@property (weak, nonatomic) IBOutlet UILabel *Statue;
@property (weak, nonatomic) IBOutlet UILabel *Speed;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *TemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherType;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;

@end
