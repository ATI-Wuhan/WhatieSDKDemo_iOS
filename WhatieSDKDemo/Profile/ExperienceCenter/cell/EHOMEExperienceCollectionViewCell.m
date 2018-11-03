//
//  EHOMEExperienceCollectionViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/27.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEExperienceCollectionViewCell.h"

@implementation EHOMEExperienceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.experienceTitleLabel.textColor = [UIColor THEMECOLOR];
    
    self.experienceLabel.backgroundColor = [UIColor THEMECOLOR];
    self.experienceLabel.layer.masksToBounds = YES;
    self.experienceLabel.layer.cornerRadius = 3.0;
    self.experienceLabel.textColor = [UIColor whiteColor];
    self.experienceLabel.text = NSLocalizedStringFromTable(@"Experience Now", @"Profile", nil);
    
    self.experienceTitleLabel.text = NSLocalizedStringFromTable(@"Outlets", @"Profile", nil);
    self.experienceContentLabel.text = NSLocalizedStringFromTable(@"control smart outlet", @"Profile", nil);
    
}

@end
