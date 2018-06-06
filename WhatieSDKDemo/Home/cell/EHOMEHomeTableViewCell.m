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
    
    [_deviceModel updateDeviceStatus:isOn success:^(id responseObject) {
        NSLog(@"update device status success. res = %@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"update device status failed. error = %@", error);
    }];
    
}

-(void)setDeviceModel:(EHOMEDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    if (_deviceModel != nil) {
        
        self.deviceNameLabel.text = _deviceModel.device.name;
        
        [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:_deviceModel.device.product.picture.path] placeholderImage:[UIImage imageNamed:@"socket"]];
        
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
