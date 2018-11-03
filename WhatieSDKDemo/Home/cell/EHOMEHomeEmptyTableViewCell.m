//
//  EHOMEHomeEmptyTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEHomeEmptyTableViewCell.h"

@implementation EHOMEHomeEmptyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (CurrentApp == Geek) {
        self.emptyImageView.image = [UIImage imageNamed:@"Geek+empty_home"];
    }else if(CurrentApp == Ozwi){
        self.emptyImageView.image = [UIImage imageNamed:@"Ozwi+empty_home"];
    }else{
        self.emptyImageView.image = [UIImage imageNamed:@"empty_home"];
    }
    
    self.contentView.backgroundColor = RGB(240, 240, 240);
    
    self.addDeviceButton.layer.masksToBounds = YES;
    self.addDeviceButton.layer.cornerRadius = 3.0;
    self.addDeviceButton.backgroundColor = [UIColor THEMECOLOR];
    [self.addDeviceButton setTitle:NSLocalizedStringFromTable(@"Add Device", @"Device", nil) forState:UIControlStateNormal];
    
    self.nodevicesLabel.text = NSLocalizedStringFromTable(@"No Devices", @"Home", nil);
    self.nodevicesDescribLabel.text = NSLocalizedStringFromTable(@"Sorry no device", @"Home", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addDeviceButtonAction:(id)sender {
    
    [self.delegate gotoAddDevicePage];
}

- (void)dealloc {
    [_nodevicesLabel release];
    [_nodevicesDescribLabel release];
    [super dealloc];
}
@end
