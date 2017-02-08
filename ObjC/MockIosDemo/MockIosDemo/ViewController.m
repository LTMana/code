//
//  ViewController.m
//  MockIosDemo
//
//  Created by 刘博通 on 16/11/24.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "ViewController.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <AFNetworking/AFNetworking.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        
        NSLog(@"%@",request.URL.host);
        return [request.URL.host isEqualToString:@"mywebservice.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with "Hello World!" string
        NSData* stubData = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];
        return [OHHTTPStubsResponse responseWithData:stubData statusCode:200 headers:nil];
    }];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
