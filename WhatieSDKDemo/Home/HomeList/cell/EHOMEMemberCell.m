//
//  EHOMEMemberCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/9.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEMemberCell.h"

@implementation EHOMEMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.memberImageView.layer.masksToBounds = YES;
    self.memberImageView.layer.cornerRadius = 15.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
