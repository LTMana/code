//
//  httpRequest.m
//  TrafficIndex
//
//  Created by Mickey on 14-8-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "httpRequest.h"

@implementation httpRequest
@synthesize delegate;

- (void)initRequestWithUrl:(NSString *)url withDic:(NSDictionary *)dictionary
{

    PostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    __block ASIFormDataRequest *BlockRequest = PostRequest;
    __block httpRequest *Blockself = self;
	//设置表单提交项
    for (NSString *key in [dictionary allKeys])
    {
        [PostRequest setPostValue:[dictionary objectForKey:key] forKey:key];
    }
    PostRequest.timeOutSeconds = 30;
    [PostRequest setStringEncoding:NSUTF8StringEncoding];
	[PostRequest startAsynchronous];
    [PostRequest setCompletionBlock :^{
        
        [Blockself->delegate finishSuccessRequest:BlockRequest];
        
    }];
    [PostRequest setFailedBlock :^{
        
        [Blockself->delegate finishFailRequest:BlockRequest];
        
    }];
}


- (void)initRequestWithUrl:(NSString *)url withDic:(NSDictionary *)dictionary andUserName:(NSString *)username
{
    PostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    __block ASIFormDataRequest *BlockRequest = PostRequest;
    __block httpRequest *Blockself = self;
	//设置表单提交项
    for (NSString *key in [dictionary allKeys])
    {
        [PostRequest setPostValue:[dictionary objectForKey:key] forKey:key];
    }
    PostRequest.timeOutSeconds = 30;
    [PostRequest setStringEncoding:NSUTF8StringEncoding];
    [PostRequest setUsername:username];
	[PostRequest startAsynchronous];
    [PostRequest setCompletionBlock :^{
        
        [Blockself->delegate finishSuccessRequest:BlockRequest];
        
        
    }];
    [PostRequest setFailedBlock :^{
        
        [Blockself->delegate finishFailRequest:BlockRequest];
        
    }];
}

- (void)initGetRequestWithUrl:(NSString *)url withCity:(NSString *)cityName
{
    GetRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    __block ASIHTTPRequest *BlockRequest = GetRequest;
    __block httpRequest *Blockself = self;
    
    GetRequest.timeOutSeconds = 30;
    [GetRequest setUsername:cityName];
    [GetRequest startAsynchronous];
    [GetRequest setCompletionBlock :^{
        
        [Blockself->delegate finishSuccessRequest:BlockRequest];
        
        
    }];
    [GetRequest setFailedBlock :^{
        
        [Blockself->delegate finishFailRequest:BlockRequest];
        
    }];
}

@end
