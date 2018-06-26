//
//  EHOMELightMenuCollectionViewCell.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMELightMenuCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;

@property (nonatomic, copy) NSString *imageNormal;
@property (nonatomic, copy) NSString *imageSel;

@end
