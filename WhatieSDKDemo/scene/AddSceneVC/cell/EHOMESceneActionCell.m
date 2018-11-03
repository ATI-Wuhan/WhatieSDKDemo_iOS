//
//  EHOMESceneActionCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESceneActionCell.h"

@implementation EHOMESceneActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_deviceImageView release];
    [_deviceNameLabel release];
    [_devicelocalLabel release];
    [_deviceStatusLabel release];
    [_deviceModeImageView release];
    [super dealloc];
}
@end
