//
//  EHOMEOutletDetailViewController.h
//  WhatieSDKDemo
//
//  Created by Change on 2018/5/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^updateDeviceStatusBlock)(EHOMEDeviceModel *device);

@interface EHOMEOutletDetailViewController : UIViewController

@property (nonatomic, copy) updateDeviceStatusBlock updateDeviceStatusBlock;

@property (nonatomic, strong) EHOMEDeviceModel *device;

@end
