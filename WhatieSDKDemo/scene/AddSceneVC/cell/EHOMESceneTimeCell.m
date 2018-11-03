//
//  EHOMESceneTimeCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESceneTimeCell.h"

@implementation EHOMESceneTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_TimeLabel release];
    [_daysLabel release];
    [super dealloc];
}
@end
