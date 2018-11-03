//
//  DeviceDB.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/2.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface DeviceDB : RLMObject

@property int id;
@property (copy) NSString *devId;
@property (copy) NSString *deviceJson;

@end
