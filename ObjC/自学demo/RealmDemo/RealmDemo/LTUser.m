//
//  LTUser.m
//  RealmDemo
//
//  Created by 刘博通 on 16/11/23.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "LTUser.h"

@implementation LTUser





@end



@implementation Car

+ (NSDictionary *)linkingObjectsProperties {
    return @{
             @"owners": [RLMPropertyDescriptor descriptorWithClass:LTUser.class propertyName:@"cars"],
             };
}



@end