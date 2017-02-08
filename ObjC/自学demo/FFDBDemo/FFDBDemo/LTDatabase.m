//
//  LTDatabase.m
//  FFDBDemo
//
//  Created by 刘博通 on 16/11/22.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "LTDatabase.h"
#import <FMDB/FMDB.h>
#import "PhotoModel.h"

@interface LTDatabase ()

@property(nonatomic, strong) NSString *dataBasePath;
@property(nonatomic, strong) FMDatabase *standardDatabase;


@end



@implementation LTDatabase


+(instancetype)shareInstance
{
 
    static dispatch_once_t onceToken;
    static LTDatabase *standardDatabase =nil;
    
    dispatch_once(&onceToken, ^{
        
        standardDatabase =[[LTDatabase alloc] init];
        [standardDatabase createStandardsDatabase];
        
        
    });
    
    
    return standardDatabase;
    
}


//数据库地址
-(NSString *)dataBasePath{
    
    if (_dataBasePath == nil) {
        
        //        NSString *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString * pathes = @"/Users/liubotong/Desktop";
        
        _dataBasePath = [pathes stringByAppendingPathComponent:@"standardDatabase.sqlite"];
        
    }
    
    return _dataBasePath;
    
}


-(void)createStandardsDatabase
{
    self.standardDatabase = [FMDatabase databaseWithPath:self.dataBasePath];
    
    if ([self.standardDatabase open]) {
         NSLog(@"数据库打开成功");
        NSString *sqString =@"create table if not exists standard (s_id integer primary key autoincrement not NULL,ID integer, title text,original_title text,collect_count integer,subtype text,year text,large_image text,model blob)";
        
        BOOL result = [self.standardDatabase executeUpdate:sqString];
        
        if (result) {
            NSLog(@"创建表成功");
        }else
        {
            NSLog(@"创建表失败");
        }
    }
    
    
}

// 增
-(void)addPhotoModel:(PhotoModel *)photoModel
{
    PhotoModel *model = photoModel;
   //  NSLog(@"数据库%ld, %@, %@, %ld, %@, %@", (long)model.ID, model.title, model.original_title, (long)model.collect_count, model.subtype,model.year);
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"insert into standard (ID, title, original_title, collect_count , subtype, year,large_image,model) values (%ld, %@, %@, %ld, %@, %@,%@,%@)", (long)photoModel.ID, photoModel.title, photoModel.original_title, (long)photoModel.collect_count, photoModel.subtype,photoModel.year,photoModel.large_image,data];
    
    if (result) {
        NSLog(@"插入数据成功");
    }else
    {
        NSLog(@"插入数据失败");
    }
    
}

//删

-(void)deletePhotoModel:(PhotoModel *)photoModel
{
//    PhotoModel * model = photoModel;
//    
//    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"delete from standard where s_clcsZPLX = %@ and s_clcsDQDM = %@ ",  photoModel.ZPLX,photoModel.DQDM];
//    
//    if (result) {
//        NSLog(@"删除数据成功");
//    }else{
//        NSLog(@"删除数据失败");
//    }
}

- (void)deleteAll
{
    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"delete from standard"];
    
    if (result) {
        NSLog(@"删除全部数据成功");
    }else{
        NSLog(@"删除全部数据失败");
    }
}

- (void)deletetable
{
    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"drop table if exists standard"];
    
    if (result) {
        NSLog(@"删除表成功");
    }else{
        NSLog(@"删除表失败");
    }
}

//改
-(void)updatePhotoModel:(PhotoModel *)photoModel
{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:photoModel];
//    
//    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"update standard set s_clcsID = %ld, s_clcsCSM = %@,s_clcsCSZ = %@, s_clcsCSSM  = %@,s_clcsDQDM  = %@,s_clcsSFYX  = %@,s_clcsPhotoModel = %@ where s_clcsZPLX = 2 and s_clcsCSM = %@", (long)photoModel.ID, photoModel.CSM, photoModel.CSZ, photoModel.CSSM, photoModel.DQDM,photoModel.SFYX,photoModel.ZPLX,data,photoModel.CSM];
//    if (result) {
//        NSLog(@"更改数据成功");
//    }else{
//        NSLog(@"更改数据失败");
//    }
    
}



-(NSArray *)findAll
{
    NSMutableArray *tmpArray = [NSMutableArray array];

    FMResultSet *result = [self.standardDatabase executeQueryWithFormat:@"select model from standard "];
    
    while ([result next]) {
        
        
        
        NSData *data = [result dataForColumn:@"model"];
        PhotoModel * returnModel  = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        
        [tmpArray addObject:returnModel];
        
       
        
    }
    
    
    return tmpArray;
    
}

//查 : 根据需要，查到响应的model返回，我们可以从中获取model的属性值
-(PhotoModel *)getPhotoModel:(PhotoModel *)photoModel
{
    PhotoModel * returnModel = nil;
    
    FMResultSet *result = [self.standardDatabase executeQueryWithFormat:@"select original_title from standard where ID = %ld", photoModel.ID];
    
    while ([result next]) {
        
        NSLog(@"%@",[result stringForColumn:@"title"]);
        
        
        
    }
    
    return returnModel;
}


@end
