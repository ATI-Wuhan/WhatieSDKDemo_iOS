//
//  SceneDB.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/4.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface SceneDB : RLMObject

@property int homeId;
@property int sceneId;
@property (copy) NSString *sceneJson;

@end
