//
//  EHOMERoomListTableViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
typedef void(^selectedRoom)(EHOMERoomModel *model);
#import <UIKit/UIKit.h>

@interface EHOMERoomListTableViewController : UITableViewController
@property (nonatomic, copy) selectedRoom selectedRoomBlock;

@property (nonatomic, strong) NSArray *ModelArray;
@property (nonatomic, strong) EHOMERoomModel *selectedmodel;
@end
