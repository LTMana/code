//
//  DistanceInfo.h
//  ChinaTrafficIndex
//
//  Created by Mickey on 14-9-19.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistanceInfo : NSObject

typedef struct {
	double latitude;
	double longitude;
} Coordinate2D;

@property(nonatomic,retain)NSString *dName;
@property(nonatomic,retain)NSString *code;
@property(nonatomic,assign)Coordinate2D coordinate;
@end
