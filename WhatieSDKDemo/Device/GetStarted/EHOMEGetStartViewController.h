//
//  EHOMEGetStartViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEGetStartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *getStartTableview;
@property (weak, nonatomic) IBOutlet UIButton *getStartBtn;
- (IBAction)getStartedButtnAction:(id)sender;

@property (nonatomic, copy) NSString *devId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, strong) NSArray *roomModelArray;
@end
