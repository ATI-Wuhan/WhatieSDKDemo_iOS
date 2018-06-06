//
//  EHOMEHomeTableViewCell.h
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface EHOMEHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deviceSwitch;
- (IBAction)changeDeviceStatusSwitchAction:(id)sender;

@property (nonatomic, strong) EHOMEDeviceModel *deviceModel;

@end
