//
//  EHOMEAlertActionTableViewCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEAlertActionTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *actionImageView;
@property (retain, nonatomic) IBOutlet UILabel *actionName;
@property (retain, nonatomic) IBOutlet UILabel *actionState;
@property (retain, nonatomic) IBOutlet UIImageView *stateImageView;

@property (nonatomic, strong) EHOMESceneDeviceModel *deviceModel;
@end
