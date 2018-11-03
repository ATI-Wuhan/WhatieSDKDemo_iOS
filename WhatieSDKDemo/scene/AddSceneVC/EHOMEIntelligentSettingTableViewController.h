//
//  EHOMEIntelligentSettingTableViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
typedef void(^RefreshSceneBlock)(BOOL isRefresh);
#import <UIKit/UIKit.h>

@interface EHOMEIntelligentSettingTableViewController : UITableViewController
@property (nonatomic, copy) RefreshSceneBlock RefreshScene;
@property (nonatomic, assign) BOOL isAddScene;
@property (nonatomic, assign) BOOL isManual;
@property (nonatomic, strong) EHOMESceneModel *Scene;
@end
