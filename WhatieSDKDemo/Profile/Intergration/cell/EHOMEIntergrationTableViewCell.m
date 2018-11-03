//
//  EHOMEIntergrationTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/1.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEIntergrationTableViewCell.h"

@implementation EHOMEIntergrationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = GREYCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_intergrationImageView release];
    [super dealloc];
}
@end
