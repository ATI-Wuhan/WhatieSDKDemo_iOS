//
//  EHOMEAddActionCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAddActionCell.h"

@implementation EHOMEAddActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addActionLabel.text = NSLocalizedString(@"Add action", nil);
    if(CurrentApp == Geek){
        self.addImageview.image = [UIImage imageNamed:@"add-Icon"];
    }else if (CurrentApp == Ozwi){
        self.addImageview.image = [UIImage imageNamed:@"Ozwi_addAction"];
    }else{
        self.addImageview.image = [UIImage imageNamed:@"ehome-add-Icon"];
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_addActionLabel release];
    [_addActionLabel release];
    [_addImageview release];
    [super dealloc];
}
@end
