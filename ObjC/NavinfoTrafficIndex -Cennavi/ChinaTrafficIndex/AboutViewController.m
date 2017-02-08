//
//  AboutViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-28.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

- (IBAction)back:(id)sender;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"数据状态";
    }
    else
    {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *cellId = @"cellId";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    /*
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    */
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.text = @"覆盖城市数";
        cell.detailTextLabel.text = @"27个";
        
    }
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.text = @"数据刷新频率";
        cell.detailTextLabel.text = @"5分钟";
    }
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.text = @"四维指数解读";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.text = @"官网";
        cell.detailTextLabel.text = @"http://nitrafficindex.com";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.text = @"为本应用评分";
        cell.backgroundColor = [UIColor colorWithRed:103.0/255.0 green:201.0/255.0 blue:1.0 alpha:1.0];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"ToHelpView" sender:self];
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"TowebView" sender:self];
    }
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=936563217"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
