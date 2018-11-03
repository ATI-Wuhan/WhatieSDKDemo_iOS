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
    
    if (CurrentApp == Geek) {
        self.profileBannerImageView.image = [UIImage imageNamed:@"Geek+profile_banner"];
    }else if(CurrentApp == Ozwi){
        self.profileBannerImageView.image = [UIImage imageNamed:@"Ozwi_profile_banner"];
    }else{
        self.profileBannerImageView.image = [UIImage imageNamed:@"profile_banner"];
    }
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 30.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUserModel:(EHOMEUserModel *)userModel{
    
    _userModel = userModel;
    
    if (_userModel != nil) {
        self.nameLabel.text = _userModel.name;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[EHOMEUserModel shareInstance].portraitThumb.path] placeholderImage:[UIImage imageNamed:@"avatar"]];
    }
    
}



@end
