//
//  EHOMESceneModel.h
//  WhatieSDK
//
//  Created by clj on 2018/7/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <WhatieSDK/WhatieSDK.h>

@class scene;
@class EHOMESceneDeviceModel;
@interface EHOMESceneModel : EHOMEBaseObject

@property(nonatomic, strong) scene *scene;
@property(nonatomic, strong) NSArray <EHOMESceneDeviceModel *> *sceneDeviceVos;
@property (nonatomic, copy) NSString *finishTimeApp;//定时时间


/**
 edit scene scene
 
 */
-(void)EditSceneWithName:(NSString *)name
              finishTime:(NSString *)finishTime
                   loops:(NSString *)loops
               deviceIds:(NSArray *)deviceIds
           functionArray:(NSArray *)functionArray
          sceneDeviceIds:(NSArray *)sceneDeviceIds
               sceneType:(BOOL)isManual
                 success:(successBlock)success
                 failure:(failBlock)failure;


/**
 remove scene
 
 */
-(void)removeScenesuccess:(successBlock)success
                  failure:(failBlock)failure;


/**
 update scene status
 
 */
-(void)updateSceneStatus:(BOOL)status
                 success:(successBlock)success
                 failure:(failBlock)failure;


/**
 execute manual Scene
 
 */
-(void)executeManualScene:(successBlock)success
                  failure:(failBlock)failure;


/**
 get scene devices
 
 */
-(void)getSceneDevices:(successBlock)success
               failure:(failBlock)failure;
@end


@class EHOMEPhotoModel;
@interface scene : EHOMEBaseObject
@property (nonatomic, assign) int id;//场景id
@property (nonatomic, assign) int type;//manual or timing
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int homeId;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, copy) NSString *timerType;
@property (nonatomic, strong) EHOMEPhotoModel *background;
@property (nonatomic, strong) EHOMEPhotoModel *backgroundThumb;

@end
