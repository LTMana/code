//
//  ModuleTwoInterface.m
//  ModuleTwo
//
//  Created by Yes-Cui on 16/8/4.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "ModuleTwoInterface.h"
#import <CommonModule/CommonMacro.h>
#import "PartTwoShare.h"

@implementation ModuleTwoInterface

+ (UIViewController *)showModuleTwoVC{
    UIViewController *partTwoVC = InstantiateVCFromBundleStoryboard(kPartTwoStoryboard, @"ModuleTwoViewController", kModuleBundle);
    return partTwoVC;
}

+ (UIImage *)iconImage{
    return (UIImage *)kModuleBundleUIImageNamed(@"icon");
}

@end
