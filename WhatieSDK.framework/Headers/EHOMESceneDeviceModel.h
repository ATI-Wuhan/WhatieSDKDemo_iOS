//
//  EHOMESceneDeviceModel.h
//  WhatieSDK
//
//  Created by clj on 2018/7/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <WhatieSDK/WhatieSDK.h>
@class Device;
@interface EHOMESceneDeviceModel : EHOMEBaseObject
@property(nonatomic, assign) int sceneDeviceId;
@property(nonatomic, strong) Device *device;
@property(nonatomic, assign) int clockId;
@property (nonatomic, copy) NSString *dps;
@property(nonatomic, assign) BOOL success;

/**
 reset failure scene device
 
 */
-(void)resetSceneDevice:(successBlock)success
                failure:(failBlock)failure;


/**
 delete failure scene device
 
 */
-(void)deleteSceneDevice:(successBlock)success
                 failure:(failBlock)failure;
@end

