//
//  AppDelegate.m
//  RealmDemo
//
//  Created by 刘博通 on 16/11/23.
//  Copyright © 2016年 ltcom. All rights reserved.
//

#import "AppDelegate.h"
#import <Realm/Realm.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self creatDataBaseWithName:@"realmDatabase.realm"];
        return YES;
}


- (void)creatDataBaseWithName:(NSString *)databaseName
{
    
    
    NSString * pathes = @"/Users/liubotong/Desktop/realm";
    
    NSString * filePath = [pathes stringByAppendingPathComponent:databaseName];
//    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [docPath objectAtIndex:0];
//    NSString *filePath = [path stringByAppendingPathComponent:databaseName];
    NSLog(@"数据库目录 = %@",filePath);
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL URLWithString:filePath];
    //config.objectClasses = @[MyClass.class, MyOtherClass.class];
    config.readOnly = NO;
    int currentVersion = 1.0;
    config.schemaVersion = currentVersion;
    
    config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        // 这里是设置数据迁移的block
        if (oldSchemaVersion < currentVersion) {
        }
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    
 NSInteger result = [self someFuuc:^NSInteger(NSInteger a, NSInteger b) {
       
       
       
       
                    return 3 * 5 + a * b;
       
   
                     }](1,2);
    
    
    NSLog(@"result ----%ld",(long)result);
    
    
}



-(NSInteger(^)(NSInteger,NSInteger)) someFuuc :(NSInteger(^)(NSInteger,NSInteger))block
{
    
    
    return ^NSInteger(NSInteger a, NSInteger b){
        
        
        return block(a,b);
    
    };
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
