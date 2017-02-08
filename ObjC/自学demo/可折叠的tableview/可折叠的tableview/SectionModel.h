//
//  SectionModel.h
//  可折叠的tableview
//
//  Created by 刘博通 on 16/12/8.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject

@property (nonatomic,assign) BOOL isExpand;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *cellArray;


@end
