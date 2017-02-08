//
//  CommonMacro.h
//  CommonModules
//
//  Created by Yes-Cui on 16/8/4.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//


#define kModuleBundleImage(imageName)           [kModuleBundleName stringByAppendingPathComponent:imageName]
#define kModuleBundleUIImageNamed(imageName)    [UIImage imageNamed:[kModuleBundleName stringByAppendingPathComponent:imageName]]

#define InstantiateVCFromStoryboard(storyboardName, VCID)       [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:VCID]
#define InstantiateVCFromBundleStoryboard(storyboardName, VCID, bundleObj)       [[UIStoryboard storyboardWithName:storyboardName bundle:bundleObj] instantiateViewControllerWithIdentifier:VCID]