//
//  EHOMEBackgroundViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/10.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
typedef void(^changeRoomPicBlock)(NSArray *backgrounds);
#import <UIKit/UIKit.h>

@interface EHOMEBackgroundViewController : UIViewController
@property (nonatomic, assign) int tag;
@property (nonatomic, strong) EHOMERoomModel *roommodel;
@property (nonatomic, copy) changeRoomPicBlock changePictureBlock;
@end
