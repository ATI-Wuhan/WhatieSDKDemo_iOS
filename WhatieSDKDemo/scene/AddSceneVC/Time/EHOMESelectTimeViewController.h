//
//  EHOMESelectTimeViewController.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

typedef void(^timeBlock)(NSString *time);
typedef void(^daysBlock)(NSArray *days);

#import <UIKit/UIKit.h>

@interface EHOMESelectTimeViewController : UIViewController

@property (nonatomic, copy) timeBlock timeblock;
@property (nonatomic, copy) daysBlock daysblock;

@end
