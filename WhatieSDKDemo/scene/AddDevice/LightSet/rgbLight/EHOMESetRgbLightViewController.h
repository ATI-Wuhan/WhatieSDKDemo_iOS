//
//  EHOMESetRgbLightViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/31.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMESetRgbLightViewController : UIViewController
@property (nonatomic, strong) EHOMEDeviceModel *rgbLight;
@property (nonatomic, assign) BOOL isEditRgbLight;
@property (nonatomic, strong) NSDictionary *devicedps;
@end
