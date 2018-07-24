//
//  EHOMEScenesCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEScenesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *SceneBgView;
@property (weak, nonatomic) IBOutlet UIImageView *SceneImageView;
@property (weak, nonatomic) IBOutlet UILabel *sceneName;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage1;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage2;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage3;
@property (weak, nonatomic) IBOutlet UIButton *turnBtn;
@property (weak, nonatomic) IBOutlet UIButton *excBtn;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;
- (IBAction)changeSceneStatusAction:(id)sender;

@property (nonatomic, strong) EHOMESceneModel *sceneModel;
@end
