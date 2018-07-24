//
//  EHOMESceneDeviceTableViewCell.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMESceneDeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sceneDeviceBGView;
@property (weak, nonatomic) IBOutlet UIImageView *sceneDeviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *sceneDeviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sceneDeviceInfoLabel;

@property (nonatomic, strong) EHOMEDeviceModel *deviceModel;

@end
