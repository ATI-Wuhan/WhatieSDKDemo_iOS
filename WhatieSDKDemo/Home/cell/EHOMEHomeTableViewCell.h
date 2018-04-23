//
//  EHOMEHomeTableViewCell.h
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

@protocol HomeDeviceDelegate<NSObject>

@optional
-(void)switchDeviceStatusSuccessWithStatus:(BOOL)isOn indexPath:(NSIndexPath *)indexPath;

@end

#import <UIKit/UIKit.h>



@interface EHOMEHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, assign) id <HomeDeviceDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deviceSwitch;
- (IBAction)changeDeviceStatusSwitchAction:(id)sender;

@property (nonatomic, strong) EHOMEDeviceModel *deviceModel;

@end
