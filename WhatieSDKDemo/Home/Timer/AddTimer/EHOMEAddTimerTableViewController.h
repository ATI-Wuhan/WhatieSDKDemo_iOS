//
//  EHOMEAddTimerTableViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^updateTimerBlock)(EHOMETimer *timer);

@interface EHOMEAddTimerTableViewController : UITableViewController

@property (nonatomic, copy) updateTimerBlock updateTimerBlock;


@property (nonatomic, assign) BOOL isEditTimer;
@property (nonatomic, assign) int stripType;

//add timer for this device
@property (nonatomic, strong) EHOMEDeviceModel *device;

//update timer on this timer
@property (nonatomic, strong) EHOMETimer *timer;

@end
