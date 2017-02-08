//
//  PhotoModel.m
//  FFDBDemo
//
//  Created by 刘博通 on 16/11/22.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "PhotoModel.h"
#import <MJExtension/MJExtension.h>
@implementation PhotoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id",
              @"large_image"   : @"images.large"
              
            };
    
}

//一句话将所有的子文件全部归档反归档(MJExtension)
MJCodingImplementation

@end
