//
//  CityListViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-14.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "CityListViewController.h"
#import "CityDistanceInfo.h"
#import "CityListInfo.h"
@interface CityListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *CityListTable;
- (IBAction)DoneBtnCLick:(id)sender;
@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cities = [CityDistanceInfo getCityListInfo];
    
}

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
    return cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CityDistanceInfo *info = [cities objectAtIndex:indexPath.row];
    cell.textLabel.text = info.cName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.isEditCityView isEqualToString:@"YES"])
    {
        [self dismissViewControllerAnimated:YES completion:^(void)
         {
             CityDistanceInfo *info = [cities objectAtIndex:indexPath.row];
             CityListInfo *sendInfo  = [[CityListInfo alloc]init];
             sendInfo.name = info.cName;
             sendInfo.code = info.code;
             sendInfo.weatherCode = info.weatherCode;
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AddOneCity" object:sendInfo userInfo:nil];
         }];
    }
    else
    {
         [self dismissViewControllerAnimated:YES completion:^(void)
          {
              CityDistanceInfo *info = [cities objectAtIndex:indexPath.row];
              NSString *codeAndName = [NSString stringWithFormat:@"%@,%@,%@",info.code,info.cName,info.weatherCode];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"SingleCity" object:codeAndName userInfo:nil];
          }];
    }
}
#pragma mark - IBAction
- (IBAction)DoneBtnCLick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
