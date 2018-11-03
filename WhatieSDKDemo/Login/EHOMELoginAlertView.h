//
//  EHOMELoginAlertView.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/8.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginDelegate <NSObject>

-(void)fastLoginWithEmail:(NSString *)email andPassword:(NSString *)password;

@end

@interface EHOMELoginAlertView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id <loginDelegate> delegate;

-(void)show;

-(void)dismiss;

@end
