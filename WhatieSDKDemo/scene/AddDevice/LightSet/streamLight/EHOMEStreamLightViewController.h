//
//  EHOMEStreamLightViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/1.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEStreamLightViewController : UIViewController
@property (nonatomic, strong) EHOMEDeviceModel *streamLight;
@property (nonatomic, assign) BOOL isEditStreamLight;
@property (nonatomic, strong) NSDictionary *DeviceDps;
@end
