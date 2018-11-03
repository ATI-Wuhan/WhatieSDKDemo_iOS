//
//  EHOMESwitch.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/11/2.
//  Copyright © 2018 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mySwitchDelegate<NSObject>

@optional
-(void)clickedMySwitchWithStatus:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EHOMESwitch : UIView

@property (nonatomic, assign) id <mySwitchDelegate> delegate;

-(void)showLoading;
-(void)showSwitchStatus:(int)status;

@end

NS_ASSUME_NONNULL_END
