//
//  EditShowCityListViewController.m
//  ChinaTrafficIndex
//
//  Created by 米航 on 14-10-14.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "EditShowCityListViewController.h"
#import "ToolClass.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_6 (SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (SCREEN_MAX_LENGTH == 736.0)

@interface EditShowCityListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *editCityListTable;

- (IBAction)DoneBtnClick:(id)sender;
@end

@implementation EditShowCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([AppDelegate getApplicationDelegate].isLocation)
    {
        self.locCityInfo =[self.CityList objectAtIndex:0];
    }
    else
    {
        CityListInfo *info =[[CityListInfo alloc]init];
        self.locCityInfo =info;
    }
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddOneCity:) name:@"AddOneCity" object:nil];
    
   
   
    
  
    
    [_editCityListTable setEditing:YES animated:YES];
    _editCityListTable.allowsSelectionDuringEditing = YES;
    // Do any additional setup after loading the view.
}



- (void)AddOneCity:(NSNotification *)note
{
    CityListInfo *info = note.object;
    
    NSLog(@"city = %@",info.name);
    //重复城市不添加
    for (CityListInfo *list in self.CityList)
    {
        if ([info.name isEqualToString:list.name])
        {
            return;
        }
    }

    //在城市列表末尾添加新城市
    NSIndexPath *index_path = [NSIndexPath indexPathForRow:self.CityList.count inSection:1];
    
    NSLog(@"sec = %d   row = %d",index_path.section,index_path.row);
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:index_path,nil];
    
    
    //同样，将数据加到list中，用的row
    [self.CityList addObject:info];
    [self.editCityListTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
   
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"AddCity"])
    {
        id theSegue = segue.destinationViewController;
        //跳转到单个城市详细信息界面（仅用于全部城市列表跳转）
        [theSegue setValue:@"YES" forKey:@"isEditCityView"];
    }
}

- (void)updateCityListLocation
{
    
    //开启定位功能
    if ([AppDelegate getApplicationDelegate].isLocation)
    {
        BOOL isExist = NO;
        
        //已经在列表中移动到第一位
        for (int i = 0;i < self.CityList.count;i++)
        {
            CityListInfo *city = [self.CityList objectAtIndex:i];
            if ([city.name isEqualToString:[AppDelegate getApplicationDelegate].locCity])
            {
                isExist = YES;
                [self.CityList exchangeObjectAtIndex:i withObjectAtIndex:0];
            }
        }
        
        //不在列表中,添加到第一位
        if (!isExist)
        {
            [self.CityList insertObject:self.locCityInfo atIndex:0];
        }
    }
   
    
    
    for (int i = 0;i < self.CityList.count;i++)
    {
        CityListInfo *info = [self.CityList objectAtIndex:i];
        info.location = [NSString stringWithFormat:@"%d",i];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            
            if ([AppDelegate getApplicationDelegate].isLocation && [AppDelegate getApplicationDelegate].locCity != nil)
            {
                return 2;
            }
            else
            {
                return 1;
            }
            
            break;
        case 1:
            return self.CityList.count;
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
    
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"Cell";
        cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell != nil) {
            cell = nil;
        }
        
        
        if (indexPath.row == 0)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
    }
    else
    {
        static NSString *CellIdentifier = @"CellReuse";
        cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bnavi_icon_location_fixed.png"]];
        view.frame = CGRectMake(10, 8, 30, 30);
        [cell addSubview:view];
        
        cell.textLabel.text = @"定位当前城市";
        float offsetx = 0;
        if (IS_IPHONE_6) {
            offsetx = 50;
        }else if (IS_IPHONE_6P){
            offsetx = 60;
        }
        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(250+offsetx, 8, 50, 30)];
        [swit addTarget:self action:@selector(locSwitch:) forControlEvents:UIControlEventValueChanged];
        swit.on = [AppDelegate getApplicationDelegate].isLocation;
        [cell addSubview:swit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    }
    //当前定位城市
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        cell.textLabel.text = [AppDelegate getApplicationDelegate].locCity;
        cell.detailTextLabel.text = @"GPS定位";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
       
    }
    
    if (indexPath.section == 1)
    {
        CityListInfo *info = [self.CityList objectAtIndex:indexPath.row];
        cell.textLabel.text = info.name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 2)
    {
        cell.textLabel.text = @"添加城市";
    }
    
    return cell;
    
}
//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return UITableViewCellEditingStyleNone;
            break;
        case 1:
            return UITableViewCellEditingStyleDelete;
            break;
        case 2:
            return UITableViewCellEditingStyleInsert;
            break;
        default:
            return UITableViewCellEditingStyleNone;
            break;
    }
    
}
//对编辑的状态下提交的事件响应
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.CityList removeObjectAtIndex:indexPath.row];
       
        [_editCityListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
       
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

//开始移动row时执行
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
    if (sourceIndexPath != destinationIndexPath)
    {
        id object = [self.CityList objectAtIndex:sourceIndexPath.row];
        
        [self.CityList removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row > [self.CityList count])
        {
            [self.CityList addObject:object];
        }
        else
        {
            [self.CityList insertObject:object atIndex:destinationIndexPath.row];
        }
    }
}
//移动row时执行
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //用于限制只在当前section下面才可以移动
    if(sourceIndexPath.section != proposedDestinationIndexPath.section)
    {
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}
//让表格可以修改，滑动可以修改
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//让行可以移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 || indexPath.section == 1)
    {
        return;
    }
    
    [self performSegueWithIdentifier:@"AddCity" sender:self];
}
#pragma mark - IBAction
- (IBAction)locSwitch:(id)sender
{
    UISwitch *swit = (UISwitch *)sender;
    if (swit.on)
    {
        if ([AppDelegate getApplicationDelegate].locCity != nil)
        {
            NSString *mes = [NSString stringWithFormat:@"定位当前城市为：%@",[AppDelegate getApplicationDelegate].locCity];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"定位成功" message:mes delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        NSArray *cities = [CityDistanceInfo getCityListInfo];
        for (CityDistanceInfo *info in cities)
        {
            if ([info.cName isEqualToString:[AppDelegate getApplicationDelegate].locCity])
            {
                
                self.locCityInfo.name = info.cName;
                self.locCityInfo.code = info.code;
                self.locCityInfo.weatherCode = info.weatherCode;
                [self.editCityListTable reloadData];
                break;
            }
        }
        
        [AppDelegate getApplicationDelegate].isLocation = YES;
        NSDictionary *SaveDic = @{@"islocationCity":@"YES"};
        [ToolClass saveToPlist:@"AppIni.plist" :SaveDic];
        
        [self.editCityListTable reloadData];
    }
    else
    {
    
        [AppDelegate getApplicationDelegate].isLocation = NO;
        
        [self.editCityListTable reloadData];
        
        NSDictionary *SaveDic = @{@"islocationCity":@"NO"};
        [ToolClass saveToPlist:@"AppIni.plist" :SaveDic];
        return;
    }
}
- (IBAction)DoneBtnClick:(id)sender {
    
    
    [self updateCityListLocation];
    
    
    
    [self dismissViewControllerAnimated:YES completion:^(void)
     {
         //保存文件
         NSMutableDictionary *SaveDic = [[NSMutableDictionary alloc]init];
         for(CityListInfo *Cityinfo in self.CityList)
         {
             NSDictionary *cityDic = @{@"name":Cityinfo.name,@"code":Cityinfo.code,@"location":Cityinfo.location,@"weatherCode":Cityinfo.weatherCode};
             
             [SaveDic setObject:cityDic forKey:Cityinfo.name];
         }
         [ToolClass saveToPlist:@"UserCityList.plist" :SaveDic];
     }];
}

@end
