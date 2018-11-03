//
//  EHOMEShareViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/24.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEShareViewController : UIViewController
@property(nonatomic,assign)int codeType;
@property (nonatomic, strong) EHOMEDeviceModel *deviceModel;
@property (nonatomic, strong) EHOMEHomeModel *homeModel;
@end
