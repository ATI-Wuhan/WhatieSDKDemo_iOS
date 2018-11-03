//
//  EHOMERoomModel.h
//  WhatieSDK
//
//  Created by IIDreams_zhouwei on 2018/7/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"

@class Room;
@class EHOMEHomeModel;
@class EHOMEPhotoModel;
@class EHOMEBackgroundModel;

@interface EHOMERoomModel : EHOMEBaseObject

@property (nonatomic, strong) Room *room;
@property (nonatomic, assign) int onlineCount;
@property (nonatomic, assign) int allCount;



/**
 syncDeviceByRoom
 
 */
-(void)syncDeviceByRoomSuccess:(successBlock)success
                       failure:(failBlock)failure;

/**
 update new room name
 
 */
-(void)updateRoomName:(NSString *)name
              success:(successBlock)success
              failure:(failBlock)failure;

/**
 update new room background
 
 */
-(void)updateRoomBackground:(EHOMEBackgroundModel *)backgroundModel
                    success:(successBlock)success
                    failure:(failBlock)failure;


/**
 removeRoom
 
 */
-(void)removeRoomSuccess:(successBlock)success
                 failure:(failBlock)failure;



/**
 get room backgroung list
 
 */
+(void)getRoomBackgroundListSuccess:(successBlock)success
                            failure:(failBlock)failure;


@end

@interface Room : EHOMEBaseObject

@property (nonatomic, assign) int id;//房间id
@property (nonatomic, copy) NSString *type;//房间类型
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) EHOMEHomeModel *home;
@property (nonatomic, strong) EHOMEPhotoModel *background;
@property (nonatomic, strong) EHOMEPhotoModel *backgroundThumb;

@end

@interface EHOMEBackgroundModel : EHOMEBaseObject

@property (nonatomic, strong) EHOMEPhotoModel *file;
@property (nonatomic, assign) int id;//壁纸的id
@property (nonatomic, assign) BOOL vertical;//竖直
@property (nonatomic, assign) int wallpaperNum;

@end
