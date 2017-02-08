//
//  IndexRangkingViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-16.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "IndexRangkingViewController.h"
#import "RankingInfo.h"
#import "CityDistanceInfo.h"

@interface IndexRangkingViewController ()
- (IBAction)back:(id)sender;
- (IBAction)RankingTimeRange:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *RankingTimeRange_Seg;
@property (weak, nonatomic) IBOutlet UITableView *RankingTable;


@property (weak, nonatomic) IBOutlet UISegmentedControl *ascendingOrDescending_Seg;
- (IBAction)ascendingOrDescending:(id)sender;
@end

@implementation IndexRangkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Ranking_Array = [[NSMutableArray alloc]init];
    cities = [CityDistanceInfo getCityListInfo];
       // Do any additional setup after loading the view.
    self.ascendingOrDescending_Seg.layer.borderWidth = 1.0;
    self.ascendingOrDescending_Seg.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    [self SendHttpRequest:@"0"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    
}
- (void)SendHttpRequest:(NSString *)timeRange
{
    NSDictionary *dic = @{@"byJamRanking": @"true",@"area":@"98",@"timeRange":timeRange,@"method":@"1"};
    [AppDelegate getApplicationDelegate].RequestHandling.CityRanking_delegate = self;
    [[AppDelegate getApplicationDelegate].RequestHandling doRequest_CityRanking:dic];
    dic = nil;
}

#pragma mark - httpDelegate
- (void)getCityRankingDidSuccess:(NSArray *)array
{
    [Ranking_Array removeAllObjects];
    Ranking_Array = [NSMutableArray arrayWithArray:array];
    [self.RankingTable reloadData];
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
    
    [Ranking_Array removeAllObjects];
    for (NSDictionary *dic in reString)
    {
        RankingInfo *info = [[RankingInfo alloc]init];
        NSString *cityName = [dic objectForKey:@"city"];
        info.name = [cityName substringToIndex:cityName.length-3];
        info.index = [dic objectForKey:@"cIndex"];
       
        [Ranking_Array addObject:info];
    }
    
    [self.RankingTable reloadData];
    
    result = nil;
    reString = nil;
}
- (void)finishFailRequest:(ASIHTTPRequest *)request
{
    
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
    return [Ranking_Array count];
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
   

    RankingInfo *info = [Ranking_Array objectAtIndex:indexPath.row];
    cell.NameLabel.text = info.name;
    cell.IndexLabel.text = [NSString stringWithFormat:@"%.1f",[info.index floatValue]];
    cell.IndexLabel.layer.cornerRadius = 5;
    cell.IndexLabel.backgroundColor = [ToolClass IndexToColor:info.index];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^(void)
     {
         RankingInfo *info = [Ranking_Array objectAtIndex:indexPath.row];
         
         for (CityDistanceInfo *city in cities)
         {
             if ([city.cName isEqualToString:info.name])
             {
                 NSString *codeAndName = [NSString stringWithFormat:@"%@,%@",city.code,city.cName];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"SingleCity" object:codeAndName userInfo:nil];
                 break;
             }
         }
     }];
}
#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)RankingTimeRange:(id)sender {
    
    switch (self.RankingTimeRange_Seg.selectedSegmentIndex) {
        case 0:
            [self SendHttpRequest:@"0"];
            break;
        case 1:
            [self SendHttpRequest:@"1"];
            break;
        case 2:
            [self SendHttpRequest:@"6"];
            break;
        default:
            break;
    }
}

- (IBAction)ascendingOrDescending:(id)sender {
    
    if (self.ascendingOrDescending_Seg.selectedSegmentIndex == 0)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO];
        [Ranking_Array sortUsingDescriptors:[NSArray arrayWithObject:sort]];
       
    }
    else
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        [Ranking_Array sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
    }
     [self.RankingTable reloadData];
}
@end
