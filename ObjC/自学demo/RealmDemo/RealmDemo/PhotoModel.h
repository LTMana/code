//
//  PhotoModel.h
//  RealmDemo
//
//  Created by 刘博通 on 16/11/23.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Realm/Realm.h>

@interface PhotoModel : RLMObject
@property  NSInteger   ID;
@property  NSString * title;
@property  NSString * original_title;
@property  NSInteger collect_count;
@property  NSString * subtype;
@property  NSString * year;
/** 大图片的URL */
@property  NSString *large_image;

@end
