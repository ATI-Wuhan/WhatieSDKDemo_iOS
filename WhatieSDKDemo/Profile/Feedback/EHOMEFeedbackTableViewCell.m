//
//  EHOMEFeedbackTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEFeedbackTableViewCell.h"

@implementation EHOMEFeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (CurrentApp == Geek) {
        self.circleImageView.image = [UIImage imageNamed:@"Geek+circle"];
    }else if(CurrentApp == Ozwi){
        self.circleImageView.image = [UIImage imageNamed:@"Ozwi_circle"];
    }else{
        self.circleImageView.image = [UIImage imageNamed:@"circle"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
