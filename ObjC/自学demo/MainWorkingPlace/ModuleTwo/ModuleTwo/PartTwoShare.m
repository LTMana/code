//
//  PartTwoShare.m
//  ModuleTwo
//
//  Created by Yes-Cui on 16/8/4.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "PartTwoShare.h"

@implementation PartTwoShare

+ (NSBundle *)frameworkBundle {
    static NSBundle *bundle;
    if (!bundle) {
        bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kModuleBundleName]];
    } else {}
    return bundle;
}

@end
