//
//  PhotoModel.h
//  FFDBDemo
//
//  Created by 刘博通 on 16/11/22.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property (nonatomic, assign) NSInteger   ID;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * original_title;
@property (nonatomic, assign) NSInteger collect_count;
@property (nonatomic, copy) NSString * subtype;
@property (nonatomic, copy) NSString * year;
/** 大图片的URL */
@property (nonatomic, copy) NSString *large_image;

@end
