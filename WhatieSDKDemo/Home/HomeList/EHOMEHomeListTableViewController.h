//
//  EHOMEHomeListTableViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/3.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

typedef void(^didSelectHomeBlock)(EHOMEHomeModel *home);

#import <UIKit/UIKit.h>

@interface EHOMEHomeListTableViewController : UITableViewController

@property (nonatomic, copy) didSelectHomeBlock selectHomeBlock;

@property (nonatomic, assign) BOOL isEditHomes;

@end
