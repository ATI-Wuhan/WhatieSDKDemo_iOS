//
//  EHOMEAddSceneTableViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
typedef void(^RefreshSceneBlock)(BOOL isRefresh);

#import <UIKit/UIKit.h>

@interface EHOMEAddSceneTableViewController : UITableViewController

@property (nonatomic, copy) RefreshSceneBlock RefreshScene;

@property (nonatomic, assign) BOOL isEditScene;
//update scene on this scene
@property (nonatomic, strong) EHOMESceneModel *Scene;

@end
