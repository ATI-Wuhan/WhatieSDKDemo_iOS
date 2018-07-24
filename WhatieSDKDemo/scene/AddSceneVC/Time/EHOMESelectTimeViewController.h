//
//  EHOMESelectTimeViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

typedef void(^timeBlock)(NSString *time);

#import <UIKit/UIKit.h>

@interface EHOMESelectTimeViewController : UIViewController

@property (nonatomic, copy) timeBlock timeblock;

@end
