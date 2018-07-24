//
//  EHOMELoopsTableViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

typedef void(^loopsBlock)(NSArray *loops);

#import <UIKit/UIKit.h>

@interface EHOMELoopsTableViewController : UITableViewController

@property (nonatomic, strong) loopsBlock loopsblock;

@end
