//
//  EHOMETimer.h
//  WhatieSDK
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"

@class deviceClock;
@class Device;

@interface EHOMETimer : EHOMEBaseObject


@property (nonatomic, strong) deviceClock *deviceClock;
@property (nonatomic, copy) NSString *finishTimeApp;//定时时间
@property (nonatomic, assign) int durationTime;//倒计时时间

/**
 updateTimerStatus
 
 */
-(void)updateTimerStatus:(BOOL)status
                 success:(successBlock)success
                 failure:(failBlock)failure;


/**
 updateTimerStatus
 
 */
-(void)updateTimerWithLoops:(NSString *)loops
                       time:(NSString *)time
                     status:(BOOL)status
                        tag:(NSString *)tag
                 deviceType:(int)type
                    success:(successBlock)success
                    failure:(failBlock)failure;


/**
 removeTimer
 
 */
-(void)removeTimer:(successBlock)success
           failure:(failBlock)failure;



@end


@class stripDps;
@interface deviceClock : EHOMEBaseObject

@property (nonatomic, assign) int id;//倒计时、定时器id
@property (nonatomic, assign) int clockId;
@property (nonatomic, copy) NSString *timerType;//定时的天数
@property (nonatomic, assign) BOOL clockStatus;//倒计时、定时的状态
@property (nonatomic, assign) int timezone;//定时时差
@property (nonatomic, copy) NSString *dps;
@property (nonatomic, strong) Device *device;
@property (nonatomic, assign) BOOL deviceStatus;//status
@property (nonatomic, strong) stripDps *stripdps;
@property (nonatomic, copy) NSString *tag;

@end


@interface stripDps : EHOMEBaseObject

@property (nonatomic, assign) int stripsMode;//插排插孔模式
@property (nonatomic, assign) BOOL stripsStatus;//插孔状态

@end
