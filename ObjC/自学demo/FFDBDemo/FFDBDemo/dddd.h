//
//  dddd.h
//  FFDBDemo
//
//  Created by 刘博通 on 16/11/22.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#ifndef dddd_h
#define dddd_h
//增
-(void)addPhotoModel:(PhotoModel *)photoModel
{
    
    PhotoModel * model = photoModel;
    
    NSLog(@"数据库%ld, %@, %@, %@, %@, %@, %@", (long)model.ID, model.CSM, model.CSZ, model.CSSM, model.ZPLX,model.DQDM,model.SFYX);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:photoModel];
    
    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"insert into standard (s_clcsID, s_clcsCSM, s_clcsCSZ, s_clcsCSSM , s_clcsZPLX, s_clcsDQDM , s_clcsSFYX , s_clcxPhotoModel) values (%d, %@, %@, %@, %@, %@, %@, %@)", photoModel.ID, photoModel.CSM, photoModel.CSZ, photoModel.CSSM, photoModel.ZPLX,photoModel.DQDM,photoModel.SFYX,data];
    
    
    if (result) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败");
        
    }
}
//删

-(void)deletePhotoModel:(PhotoModel *)photoModel
{
    PhotoModel * model = photoModel;
    
    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"delete from standard where s_clcsZPLX = %@ and s_clcsDQDM = %@ ",  photoModel.ZPLX,photoModel.DQDM];
    
    if (result) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
    }
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
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:photoModel];
    
    BOOL result = [self.standardDatabase executeUpdateWithFormat:@"update standard set s_clcsID = %d, s_clcsCSM = %@,s_clcsCSZ = %@, s_clcsCSSM  = %@,s_clcsDQDM  = %@,s_clcsSFYX  = %@,s_clcsPhotoModel = %@ where s_clcsZPLX = 2 and s_clcsCSM = %@", photoModel.ID, photoModel.CSM, photoModel.CSZ, photoModel.CSSM, photoModel.DQDM,photoModel.SFYX,photoModel.ZPLX,data,photoModel.CSM];
    
    if (result) {
        NSLog(@"更改数据成功");
    }else{
        NSLog(@"更改数据失败");
    }
    
}

//查 : 根据需要，查到响应的model返回，我们可以从中获取model的属性值
-(PhotoModel *)selectPhotoModel:(PhotoModel *)photoModel
{
    PhotoModel * returnModel = nil;
    
    FMResultSet *result = [self.standardDatabase executeQueryWithFormat:@"select s_clcxPhotoModel from standard where s_clcsZPLX = %@ ", photoModel.ZPLX];
    
    while ([result next]) {
        
        NSData *data = [result dataForColumn:@"s_clcxPhotoModel"];
        
        returnModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    
    return returnModel;
}

#endif /* dddd_h */
