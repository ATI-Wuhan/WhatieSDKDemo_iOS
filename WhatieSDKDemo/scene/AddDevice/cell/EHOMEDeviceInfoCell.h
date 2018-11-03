//
//  EHOMEDeviceInfoCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/26.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEDeviceInfoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (retain, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (nonatomic, strong) EHOMEDeviceModel *device;
@end
