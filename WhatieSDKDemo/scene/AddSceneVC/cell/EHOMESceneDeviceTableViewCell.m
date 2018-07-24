//
//  EHOMESceneDeviceTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESceneDeviceTableViewCell.h"

@implementation EHOMESceneDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.sceneDeviceBGView.layer.masksToBounds = YES;
    self.sceneDeviceBGView.layer.cornerRadius = 5.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDeviceModel:(EHOMEDeviceModel *)deviceModel{
    
    _deviceModel = deviceModel;
    
    if (_deviceModel != nil) {
        [self.sceneDeviceImageView sd_setImageWithURL:[NSURL URLWithString:_deviceModel.device.product.picture.path]];
        self.sceneDeviceNameLabel.text = _deviceModel.device.name;
        
        if (_deviceModel.sceneActionStatus) {
            self.sceneDeviceInfoLabel.text = NSLocalizedStringFromTable(@"Turn On", @"DeviceFunction", nil);
        }else{
            self.sceneDeviceInfoLabel.text = NSLocalizedStringFromTable(@"Turn Off", @"DeviceFunction", nil);
        }
    }
}

@end
