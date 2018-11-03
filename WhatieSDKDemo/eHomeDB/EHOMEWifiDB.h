//
//  EHOMEWifiDB.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/8.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface EHOMEWifiDB : RLMObject

@property (copy) NSString *name;
@property (copy) NSString *password;

@end
