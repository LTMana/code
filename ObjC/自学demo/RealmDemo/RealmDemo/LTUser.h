//
//  LTUser.h
//  RealmDemo
//
//  Created by 刘博通 on 16/11/23.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import <Realm/Realm.h>
RLM_ARRAY_TYPE(LTUser) // 定义RLMArray<LTUser>

RLM_ARRAY_TYPE(Car) // 定义RLMArray<Car>
@interface LTUser : RLMObject

@property NSString       *accid;
//用户注册id
@property NSInteger      custId;
//姓名
@property NSString       *custName;
//头像大图url
@property NSString       *avatarBig;
@property RLMArray<Car> *cars;




@end




@interface Car : RLMObject

@property NSString *carName;
@property LTUser *owner;
@property (readonly) RLMLinkingObjects *owners;
@end




