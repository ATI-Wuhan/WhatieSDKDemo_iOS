//
//  EHOMEHomeTableViewCell.h
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHOMESwitch.h"


@interface EHOMEHomeTableViewCell : UITableViewCell<mySwitchDelegate>

@property (weak, nonatomic) IBOutlet UIView *deviceBGView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deviceSwitch;
@property (weak, nonatomic) IBOutlet UILabel *deviceLocationLabel;

@property (strong, nonatomic) EHOMESwitch *myswitch;


- (IBAction)changeDeviceStatusSwitchAction:(id)sender;

@property (nonatomic, strong) EHOMEDeviceModel *deviceModel;

@end
