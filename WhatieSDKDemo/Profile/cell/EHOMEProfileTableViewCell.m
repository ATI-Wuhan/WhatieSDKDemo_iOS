//
//  EHOMEProfileTableViewCell.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEProfileTableViewCell.h"

@implementation EHOMEProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    EHOMEUserModel *userModel = [EHOMEUserModel getCurrentUser];

    self.nameLabel.text = userModel.name;
    self.emailLabel.text = userModel.email;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
