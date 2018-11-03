//
//  EHOMEDefaultEmptyTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEDefaultEmptyTableViewCell.h"

@implementation EHOMEDefaultEmptyTableViewCell

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
    [_emptyImageView release];
    [_emptyTitleLabel release];
    [_emptyDescriptionLabel release];
    [super dealloc];
}
@end
