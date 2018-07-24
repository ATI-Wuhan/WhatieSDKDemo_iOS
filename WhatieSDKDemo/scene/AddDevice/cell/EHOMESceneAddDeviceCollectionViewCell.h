//
//  EHOMESceneAddDeviceCollectionViewCell.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMESceneAddDeviceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *deviceBGView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (nonatomic, strong) EHOMEDeviceModel *device;

@end
