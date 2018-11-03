//
//  EHOMESceneEmptyTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/8.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESceneEmptyTableViewCell.h"

@implementation EHOMESceneEmptyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.addSceneButton setTitle:NSLocalizedString(@"Add Scene", nil) forState:UIControlStateNormal];
    self.addSceneButton.layer.masksToBounds = YES;
    self.addSceneButton.layer.cornerRadius = 5.0;
    self.addSceneButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.addSceneButton.layer.borderWidth = 1.0;
    
    self.NoDeviceLabel.text = NSLocalizedString(@"No scenes", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_addSceneButton release];
    [_NoDeviceLabel release];
    [super dealloc];
}


- (IBAction)addScene:(id)sender {
    
    [self.delegate addSceneCellAction];
}


@end
