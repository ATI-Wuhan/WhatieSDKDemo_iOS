//
//  EHOMEColorCollectionViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/15.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEColorCollectionViewCell.h"

@implementation EHOMEColorCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.colorView.layer.masksToBounds = YES;
    self.colorView.layer.cornerRadius = 30;
    self.editImageView.hidden = YES;
    
}

-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if (selected) {
        self.editImageView.hidden = NO;
    }else{
        self.editImageView.hidden = YES;
    }
}

@end
