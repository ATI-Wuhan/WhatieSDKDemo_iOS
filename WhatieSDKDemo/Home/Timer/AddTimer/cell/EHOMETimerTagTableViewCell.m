//
//  EHOMETimerTagTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMETimerTagTableViewCell.h"

@implementation EHOMETimerTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagTextField.placeholder=NSLocalizedStringFromTable(@"key timer Tag", @"DeviceFunction", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
