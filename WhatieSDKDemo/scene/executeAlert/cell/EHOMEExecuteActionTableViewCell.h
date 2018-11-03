//
//  EHOMEExecuteActionTableViewCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEExecuteActionTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *actionImageView;
@property (retain, nonatomic) IBOutlet UILabel *actionDeviceName;
@property (retain, nonatomic) IBOutlet UILabel *actionType;
@property (retain, nonatomic) IBOutlet UIImageView *stateImageview;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *stateSpiner;

@property (nonatomic, strong) EHOMESceneDeviceModel *sceneDevcieModel;
@end
