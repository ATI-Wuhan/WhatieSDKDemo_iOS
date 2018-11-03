//
//  EHOMETimingSceneCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/24.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMETimingSceneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *timingSceneBgView;
@property (weak, nonatomic) IBOutlet UILabel *timingSceneName;
@property (weak, nonatomic) IBOutlet UIImageView *DeviceImage1;
@property (weak, nonatomic) IBOutlet UIImageView *DeviceImage2;
@property (weak, nonatomic) IBOutlet UIImageView *DeviceImage3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *sceneSwitch;
- (IBAction)changeSceneStatusAction:(id)sender;

@property (nonatomic, strong) EHOMESceneModel *TSceneModel;
@end
