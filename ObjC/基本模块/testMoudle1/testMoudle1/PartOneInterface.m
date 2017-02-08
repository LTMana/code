//
//  PartOneInterface.m
//  ModuleOne
//
//  Created by Yes-Cui on 16/8/4.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "PartOneInterface.h"
#import "PartOneShare.h"
#import <共用模块/CommonMacro.h>

@implementation PartOneInterface

+ (UIViewController *)showPartOneVC{
    
    UIViewController *partOneVC = InstantiateVCFromBundleStoryboard(kPartOneStoryboard, @"PartOneViewController", kModuleBundle);
    
    
    return partOneVC;
}

@end
