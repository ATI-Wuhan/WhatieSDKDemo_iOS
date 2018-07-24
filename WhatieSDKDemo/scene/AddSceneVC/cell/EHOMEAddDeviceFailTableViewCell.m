//
//  EHOMEAddDeviceFailTableViewCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/16.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAddDeviceFailTableViewCell.h"

@implementation EHOMEAddDeviceFailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.BgView.backgroundColor =RGB(42, 52, 59);
    
    self.BgView.layer.masksToBounds = YES;
    self.BgView.layer.cornerRadius = 5.0;
    
    [self.deleteBtn setImage:[[UIImage imageNamed:@"DEL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.resetBtn setImage:[[UIImage imageNamed:@"RESET"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteFailDevice:(id)sender {
    [self.delegate1 gotoDeleteDevicePageWithIndexPath:self.indexPath];
}

- (IBAction)resetFailDevice:(id)sender {
    [self.delegate2 gotoResetDevicePageWithIndexPath:self.indexPath];
}
@end
