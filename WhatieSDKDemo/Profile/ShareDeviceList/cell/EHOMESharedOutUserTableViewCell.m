//
//  EHOMESharedOutUserTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/18.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESharedOutUserTableViewCell.h"

@implementation EHOMESharedOutUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_userImageView release];
    [_userNameLabel release];
    [super dealloc];
}
@end
