//
//  EHOMESceneDeviceModel.h
//  WhatieSDK
//
//  Created by clj on 2018/7/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <WhatieSDK/WhatieSDK.h>
@class Device;
@class Dps;
@interface EHOMESceneDeviceModel : EHOMEBaseObject<NSCopying>
@property(nonatomic, assign) int sceneDeviceId;
@property(nonatomic, strong) Device *device;
@property(nonatomic, strong) Dps *dps;
@property(nonatomic, assign) int clockId;
@property(nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *roomName;

//立即执行成功标志
@property(nonatomic, assign) int executeSuccess;

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


@interface Dps : EHOMEBaseObject<NSCopying>

//only outlets
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL second;

//only light
@property(nonatomic, assign) int lightMode;
@property (nonatomic, copy) NSString *l;
@property (nonatomic, copy) NSString *rgb;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *rgb1;
@property (nonatomic, copy) NSString *rgb2;
@property (nonatomic, copy) NSString *rgb3;
@property (nonatomic, copy) NSString *rgb4;
@property (nonatomic, copy) NSString *t;

@end
