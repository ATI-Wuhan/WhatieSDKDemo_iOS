//
//  EHOMELightMenuCollectionViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMELightMenuCollectionViewCell.h"

@implementation EHOMELightMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.menuTitleLabel.textColor = [UIColor lightGrayColor];
    
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        self.contentView.backgroundColor = THEMECOLOR;
        self.menuTitleLabel.textColor = [UIColor whiteColor];
        self.menuImageView.image = [UIImage imageNamed:_imageSel];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.menuTitleLabel.textColor = [UIColor lightGrayColor];
        self.menuImageView.image = [UIImage imageNamed:_imageNormal];
    }
}

@end
