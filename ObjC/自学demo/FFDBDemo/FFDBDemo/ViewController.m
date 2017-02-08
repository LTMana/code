//
//  ViewController.m
//  FFDBDemo
//
//  Created by 刘博通 on 16/11/22.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import "LTDatabase.h"
#import "PhotoModel.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
@interface ViewController ()

@property (nonatomic, strong) LTDatabase *db;

@property(nonatomic, strong)NSArray *modelArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.db = [LTDatabase  shareInstance];
    
    
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
 
    
    [self getPhotoRequires];
        
   
     // https://api.douban.com/v2/movie/top250
}


-(void)getPhotoRequires
{
    
     _modelArr = [self.db findAll];
     if (_modelArr.count >0 && _modelArr) {
         
         
         for (PhotoModel *model in _modelArr) {
             
             
             NSLog(@"%ld, %@, %@, %ld, %@, %@,%@", (long)model.ID, model.title, model.original_title, (long)model.collect_count, model.subtype,model.year,model.large_image);
             
         }
 
         
         
         
     }else{
         
         [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/movie/top250" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             _modelArr = [PhotoModel mj_objectArrayWithKeyValuesArray:responseObject[@"subjects"]];
             for (PhotoModel *model in _modelArr) {
                 // NSLog(@"%ld, %@, %@, %ld, %@, %@", (long)model.ID, model.title, model.original_title, (long)model.collect_count, model.subtype,model.year);
                 [self.db addPhotoModel:model];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];

         
     }
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findALL {
    
  NSArray *findArr =[self.db findAll];
    for (PhotoModel *model in findArr) {
        
        
        NSLog(@"%ld, %@, %@, %ld, %@, %@", (long)model.ID, model.title, model.original_title, (long)model.collect_count, model.subtype,model.year);
      
    }

    
    
}

@end
