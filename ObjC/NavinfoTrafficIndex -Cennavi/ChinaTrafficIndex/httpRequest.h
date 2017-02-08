//
//  httpRequest.h
//  TrafficIndex
//
//  Created by Mickey on 14-8-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@protocol httpRequestDelegate<NSObject>

//非队列异步请求
-(void)finishSuccessRequest:(ASIHTTPRequest *)request;
-(void)finishFailRequest:(ASIHTTPRequest *)request;
@end


@interface httpRequest : NSObject
{
    ASIFormDataRequest *PostRequest;
    ASIHTTPRequest *GetRequest;
}


@property(nonatomic,strong) id<httpRequestDelegate> delegate;

- (void)initRequestWithUrl:(NSString *)url withDic:(NSDictionary *)dictionary;
- (void)initRequestWithUrl:(NSString *)url withDic:(NSDictionary *)dictionary andUserName:(NSString *)username;

//请求天气Get方式
- (void)initGetRequestWithUrl:(NSString *)url withCity:(NSString *)cityName;
@end
