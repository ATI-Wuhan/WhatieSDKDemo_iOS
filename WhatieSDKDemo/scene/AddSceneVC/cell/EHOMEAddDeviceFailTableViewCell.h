//
//  EHOMEAddDeviceFailTableViewCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/16.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol deleteFailDeviceDelegate<NSObject>

-(void)gotoDeleteDevicePageWithIndexPath:(NSIndexPath *)indexPath;

@end

@protocol resetFailDeviceDelegate<NSObject>

-(void)gotoResetDevicePageWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface EHOMEAddDeviceFailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BgView;
@property (weak, nonatomic) IBOutlet UIImageView *sceneDeviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *addFailLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

- (IBAction)deleteFailDevice:(id)sender;
- (IBAction)resetFailDevice:(id)sender;

@property (nonatomic, assign) id<deleteFailDeviceDelegate> delegate1;
@property (nonatomic, assign) id<resetFailDeviceDelegate> delegate2;

@property (nonatomic, strong) EHOMESceneDeviceModel *failModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
