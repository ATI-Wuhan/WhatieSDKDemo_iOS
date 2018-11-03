//
//  EHOMESceneNameCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESceneNameCell.h"

@implementation EHOMESceneNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.editSceneName setImage:[[UIImage imageNamed:@"fix-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_editSceneName release];
    [_NameLabel release];
    [super dealloc];
}
- (IBAction)editNameAction:(id)sender {
    [self.delegate gotoChangeSceneName];
}
@end
