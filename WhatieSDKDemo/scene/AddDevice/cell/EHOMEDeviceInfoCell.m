//
//  EHOMEDeviceInfoCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/26.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEDeviceInfoCell.h"

@implementation EHOMEDeviceInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDevice:(EHOMEDeviceModel *)device{
    _device = device;
    
    if (_device != nil) {
        [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:_device.device.product.picture.path]];
        self.deviceNameLabel.text = _device.device.name;
    }
}

- (void)dealloc {
    [_deviceImageView release];
    [_deviceNameLabel release];
    [super dealloc];
}
@end
