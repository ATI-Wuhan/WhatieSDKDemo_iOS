//
//  EHOMEFamilyViewController.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/9.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEFamilyViewController : UIViewController
@property(nonatomic, strong) EHomeMemberModel *memberModel;
@property (nonatomic, assign) int hostId;
@property(nonatomic, strong) EHOMEHomeModel *homeModel;
@end
