//
//  EHOMETimerTableViewCell.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol updateTimerStatusDelegate <NSObject>

-(void)updateTimerStatusIndexPath:(NSIndexPath *)indexPath timer:(EHOMETimer *)timer;

@end

@interface EHOMETimerTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id <updateTimerStatusDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *timerDpsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerFinishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLoopsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *timerSwitch;

- (IBAction)updateTimerStatus:(id)sender;

@property (nonatomic, strong) EHOMETimer *timer;

@end
