//
//  Home.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/2.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Home : RLMObject

@property int id;
@property (copy) NSString *homeJson;

@end
