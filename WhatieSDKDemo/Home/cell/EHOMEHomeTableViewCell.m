//
//  EHOMEHomeTableViewCell.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEHomeTableViewCell.h"

@implementation EHOMEHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeDeviceStatusSwitchAction:(id)sender {
    
    UISwitch *deviceSwitch = (UISwitch *)sender;
    
    NSLog(@"Switch status = %d", deviceSwitch.on);
    
    BOOL isOn = deviceSwitch.on;
    
    [[EHOMEMQTTClientManager shareInstance] switchDeviceStatusWithDeviceModel:_deviceModel status:isOn startBlock:^{
        NSLog(@"Turn...");
    } successBlock:^(id responseObject) {
        NSLog(@"Open switch On success = %@", responseObject);
        /*
         deviceName = "000000e_53_14_8p";
         success = 1;
         */
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            if (isOn) {
                self.deviceStatusLabel.text = @"On";
            }else{
                self.deviceStatusLabel.text = @"Off";
            }
        }else{
            [self.deviceSwitch setOn:isOn];
        }
        
        [self.delegate switchDeviceStatusSuccessWithStatus:isOn indexPath:_indexpath];
        
    } failBlock:^(NSError *error) {
        NSLog(@"Open switch On failed = %@", error);
        [self.deviceSwitch setOn:!isOn];
    }];

}

-(void)setDeviceModel:(EHOMEDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    if (_deviceModel != nil) {
        self.deviceNameLabel.text = _deviceModel.device.name;
        if (_deviceModel.functionValuesMap.power) {
            self.deviceStatusLabel.text = @"On";
            [self.deviceSwitch setOn:YES];
        }else{
            self.deviceStatusLabel.text = @"Off";
            [self.deviceSwitch setOn:NO];
        }
    }
}


@end
