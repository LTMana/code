//
//  PartOneShare.m
//  ModuleOne
//
//  Created by Yes-Cui on 16/8/4.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "PartOneShare.h"

@implementation PartOneShare

+ (NSBundle *)frameworkBundle {
    static NSBundle *bundle;
    if (!bundle) {
        bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kModuleBundleName]];
    } else {}
    return bundle;
}


@end
