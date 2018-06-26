//
//  EHOMESetTimeViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^timeBlock)(NSString *time);

@interface EHOMESetTimeViewController : UIViewController

@property (nonatomic, copy) timeBlock timeblock;

@property (nonatomic, copy) NSString *time;

@end
