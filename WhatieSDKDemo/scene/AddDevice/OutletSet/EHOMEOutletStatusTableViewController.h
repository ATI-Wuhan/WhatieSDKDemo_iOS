//
//  EHOMEOutletStatusTableViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/26.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEOutletStatusTableViewController : UITableViewController

@property (nonatomic, strong) EHOMEDeviceModel *selectDevice;
@property (nonatomic, strong) NSDictionary *dpsDIC;
@property (nonatomic, assign) BOOL isEditAction;
@end
