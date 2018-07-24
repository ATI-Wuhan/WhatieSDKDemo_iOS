//
//  EHOMEAddRoomTableViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/10.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
typedef void(^refreshRoomListBlock)(BOOL isRefresh);
#import <UIKit/UIKit.h>

@interface EHOMEAddRoomTableViewController : UITableViewController
@property (nonatomic, copy) refreshRoomListBlock refreshRLBlock;
@end
