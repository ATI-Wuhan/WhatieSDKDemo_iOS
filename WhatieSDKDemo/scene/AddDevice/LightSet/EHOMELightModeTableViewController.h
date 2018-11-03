//
//  EHOMELightModeTableViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMELightModeTableViewController : UITableViewController

@property (nonatomic, strong) EHOMEDeviceModel *selectlight;
@property (nonatomic, strong) NSDictionary *lighDps;
@property (nonatomic, assign) BOOL isEditLight;
@end
