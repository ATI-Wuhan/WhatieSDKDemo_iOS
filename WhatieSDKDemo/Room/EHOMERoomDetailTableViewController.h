//
//  EHOMERoomDetailTableViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/10.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
typedef void(^deleteRoomBlock)(BOOL isDelete);
typedef void(^changeRoomNameBlock)(NSString *name);
typedef void(^changeRoomBackgroundBlock)(NSString *path);
typedef void(^changeRoomDeviceAccount)(BOOL isRefresh);
#import <UIKit/UIKit.h>

@interface EHOMERoomDetailTableViewController : UITableViewController
@property (nonatomic, copy) deleteRoomBlock deleteBlock;
@property (nonatomic, copy) changeRoomNameBlock roomNameBlock;
@property (nonatomic, copy) changeRoomBackgroundBlock roomBgBlock;
@property (nonatomic, copy) changeRoomDeviceAccount changeAccountBlock;

@property (nonatomic, strong) EHOMERoomModel *roomModel;
@end
