//
//  EHOMESceneAddDeviceViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

typedef void(^addSceneDeviceBlock)(EHOMEDeviceModel *deviceModel);

#import <UIKit/UIKit.h>

@interface EHOMESceneAddDeviceViewController : UIViewController

@property (nonatomic, copy) addSceneDeviceBlock addSceneDeviceBlock;

@end
