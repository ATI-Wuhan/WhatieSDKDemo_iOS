//
//  EHOMEAddTimingCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAddTimingCell.h"

@implementation EHOMEAddTimingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addTimeLabel.text = NSLocalizedString(@"Add timing", nil);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_addTimeLabel release];
    [super dealloc];
}
@end
