//
//  ViewController.m
//  RealmDemo
//
//  Created by 刘博通 on 16/11/23.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import "LTUser.h"
#import "PhotoModel.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
     [self getPhotoRequires];
}


-(void)getPhotoRequires
{
    
    
        [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/movie/top250" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray *Array = [PhotoModel mj_objectArrayWithKeyValuesArray:responseObject[@"subjects"]];
            for (PhotoModel *model in Array) {
                 NSLog(@"%ld, %@, %@, %ld, %@, %@", (long)model.ID, model.title, model.original_title, (long)model.collect_count, model.subtype,model.year);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm transactionWithBlock:^{
                        [realm addObject:model];
                    }];
                });

               
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
