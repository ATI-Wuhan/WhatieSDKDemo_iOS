//
//  EHOMEHomeEmptyTableViewCell.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addDeviceDelegate<NSObject>

-(void)gotoAddDevicePage;

@end

@interface EHOMEHomeEmptyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;
- (IBAction)addDeviceButtonAction:(id)sender;

@property (nonatomic, assign) id<addDeviceDelegate> delegate;

@end
