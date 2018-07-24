//
//  EHOMESceneAddDeviceCollectionViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESceneAddDeviceCollectionViewCell.h"

@implementation EHOMESceneAddDeviceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deviceBGView.layer.masksToBounds = YES;
    self.deviceBGView.layer.cornerRadius = 30;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        self.deviceBGView.backgroundColor = GREYCOLOR;
        self.deviceNameLabel.textColor = THEMECOLOR;
    }else{
        self.deviceBGView.backgroundColor = [UIColor whiteColor];
        self.deviceNameLabel.textColor = [UIColor darkTextColor];
    }
}


-(void)setDevice:(EHOMEDeviceModel *)device{
    
    _device = device;
    
    if (_device != nil) {
        [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:_device.device.product.picture.path]];
        self.deviceNameLabel.text = _device.device.name;
    }
}

@end
