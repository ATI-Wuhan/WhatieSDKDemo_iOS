//
//  EHOMEManualSceneCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/24.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExecuteSceneDelegate<NSObject>

-(void)gotoExecuteSceneWithScene:(EHOMESceneModel *)model;

@end

@interface EHOMEManualSceneCell : UITableViewCell
@property (nonatomic, assign) id<ExecuteSceneDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *manualSceneBgView;
@property (weak, nonatomic) IBOutlet UILabel *manualSceneName;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage1;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage2;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage3;
@property (retain, nonatomic) IBOutlet UIImageView *executeImageView;

@property (nonatomic, strong) EHOMESceneModel *MSceneModel;
@end
