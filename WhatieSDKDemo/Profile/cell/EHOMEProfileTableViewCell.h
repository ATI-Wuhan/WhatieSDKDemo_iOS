//
//  EHOMEProfileTableViewCell.h
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileBannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) EHOMEUserModel *userModel;

@end
