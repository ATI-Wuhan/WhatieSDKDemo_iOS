//
//  EHOMEUserDB.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/8.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface EHOMEUserDB : RLMObject

@property (copy) NSString *email;
@property (copy) NSString *password;

@end

