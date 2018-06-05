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
    
    [EHOMEDeviceModel switchDeviceStatusWithDeviceModel:_deviceModel toStatus:isOn startBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Loading..."];
        });
    } successBlock:^(id responseObject) {
        /*
        After controlling,the deviceId named "devId" and the latest BOOL status named "power" will be return as a dictinary.
         @{
            @"devId":devId,
            @"power":@(true)
         }
        */
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            BOOL value = [[responseObject objectForKey:@"power"] boolValue];
            if (value) {
                self.deviceStatusLabel.text = @"On";
            }else{
                self.deviceStatusLabel.text = @"Off";
            }
            
            [self.delegate switchDeviceStatusSuccessWithStatus:value indexPath:self.indexpath];
        });
    } failBlock:^(NSError *error) {
        NSLog(@"Open switch On failed = %@", error);
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [self.deviceSwitch setOn:!isOn];
    }];
    
}

-(void)setDeviceModel:(EHOMEDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    if (_deviceModel != nil) {
        
        self.deviceNameLabel.text = _deviceModel.device.name;
        
        if ([self.deviceModel.device.status isEqualToString:@"Offline"]) {
            [self.deviceSwitch setOn:NO];
            self.deviceStatusLabel.text = @"Offline";
            [self.deviceSwitch setEnabled:NO];
        }else{
            [self.deviceSwitch setEnabled:YES];
            if (_deviceModel.functionValuesMap.power) {
                self.deviceStatusLabel.text = @"On";
                [self.deviceSwitch setOn:YES];
            }else{
                self.deviceStatusLabel.text = @"Off";
                [self.deviceSwitch setOn:NO];
            }
        }
        
    }
}


@end
