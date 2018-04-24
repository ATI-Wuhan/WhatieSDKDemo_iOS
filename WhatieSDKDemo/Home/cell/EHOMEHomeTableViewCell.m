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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeDeviceStatusSwitchAction:(id)sender {
    
    UISwitch *deviceSwitch = (UISwitch *)sender;
    
    NSLog(@"Switch status = %d, %@", deviceSwitch.on, _deviceModel.device.devId);
    
    BOOL isOn = deviceSwitch.on;
    
    BOOL isTcpConnected = [[EHOMETCPManager shareInstance] isCurrentDeviceTCPConnectedWithDeviceModel:_deviceModel];
    if (isTcpConnected) {
        [[EHOMETCPManager shareInstance] switchDeviceStatusWithDeviceModel:_deviceModel status:isOn startBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Loading..." hideAfterDelay:5];
            });
            
        } successBlock:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                BOOL value = [[responseObject objectForKey:@"value"] boolValue];
                if (value) {
                    self.deviceStatusLabel.text = @"On";
                }else{
                    self.deviceStatusLabel.text = @"Off";
                }
                
                [self.delegate switchDeviceStatusSuccessWithStatus:value indexPath:self.indexpath];
            });
            
        } failBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
                self.deviceStatusLabel.text = @"Off";
            });
        }];
    }else{
        ///MQTT
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
            
            [self.delegate switchDeviceStatusSuccessWithStatus:isOn indexPath:self.indexpath];
            
        } failBlock:^(NSError *error) {
            NSLog(@"Open switch On failed = %@", error);
            [self.deviceSwitch setOn:!isOn];
        }];
    }
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
