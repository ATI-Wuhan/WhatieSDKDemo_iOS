//
//  EHOMESceneEmptyTableViewCell.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/8.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addSceneDelegate<NSObject>

-(void)addSceneCellAction;

@end

@interface EHOMESceneEmptyTableViewCell : UITableViewCell

@property (nonatomic, assign) id <addSceneDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *NoDeviceLabel;

@property (retain, nonatomic) IBOutlet UIButton *addSceneButton;

- (IBAction)addScene:(id)sender;
@end
