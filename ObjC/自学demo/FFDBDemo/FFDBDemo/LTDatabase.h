//
//  LTDatabase.h
//  FFDBDemo
//
//  Created by 刘博通 on 16/11/22.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhotoModel;
@interface LTDatabase : NSObject

+(instancetype)shareInstance;

//创建照片标准表
-(void)createStandardsDatabase;

//增
-(void)addPhotoModel:(PhotoModel *)photoModel;
//删
-(void)deletePhotoModel:(PhotoModel *)photoModel;
- (void)deleteAll;
//改
-(void)updatePhotoModel:(PhotoModel *)photoModel;
//查
-(PhotoModel *)getPhotoModel:(PhotoModel *)photoModel;

-(NSArray *)findAll;

@end
