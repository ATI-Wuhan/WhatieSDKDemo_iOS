//
//  EHOMEDeviceModel.h
//  WhatieSDK
//
//  Created by Change on 2018/4/16.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"

@class Device;
@class Function;
@class FunctionValuesMap;
@class Product;
@class Version;
@class Picture;

@interface EHOMEDeviceModel : EHOMEBaseObject<NSCopying>

@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) NSArray <Function *> *functionList;
@property (nonatomic, strong) FunctionValuesMap *functionValuesMap;
@property (nonatomic, assign) BOOL host;//  true
@property (nonatomic, assign) BOOL hasCountDown;
@property (nonatomic, copy) NSString *productName;//RgbLight,Plug
//Home
@property (nonatomic, assign) int homeId;
@property (nonatomic, assign) int roomId;
@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSString *roomName;

//status for adding scene with deviceModel
@property (nonatomic, assign) BOOL sceneActionStatus;
@property (nonatomic, assign) int sceneClockId;



#pragma MARK - Functions About Device

/**
 Turn On & Turn off Device
 
 @param status : update your device want to be
 
 */
-(void)updateDeviceStatus:(BOOL)status
                  success:(successBlock)success
                  failure:(failBlock)failure;


/**
 UpdateDeviceName
 
 update device name with name.
 
 @param name : new device name.
 
 */
-(void)updateDeviceName:(NSString *)name
                success:(successBlock)success
                failure:(failBlock)failure;



/**
 removeDevice
 
 remove your device.
 
 */
-(void)removeDevice:(successBlock)success
            failure:(failBlock)failure;

/**
 shareDeviceByEmail
 
 */
-(void)shareDeviceByEmail:(NSString *)email
                  success:(successBlock)success
                  failure:(failBlock)failure;



/**
 addTimer
 
 add timer under a specified device
 
 Note: loops:
 
 @param loops : @“0000000”, each bit, 0: off, 1: on, representing from left to right: Sunday Saturday Friday Thursday Wednesday Tuesday Monday
 @param time : 24 hours. ex. @"18:00"
 @param status : device to be once timer is finished
 
 */
-(void)addTimerWithLoops:(NSString *)loops
                    time:(NSString *)time
                  status:(BOOL)status
                     tag:(NSString *)tag
                 success:(successBlock)success
                 failure:(failBlock)failure;


/**
 getAllTimers
 
 Obtain all timers of a specified device
 
 */
-(void)getAllTimers:(successBlock)success
            failure:(failBlock)failure;


/**
 Add a timing countdwon
 
 */
-(void)addTimingCountdownWithDuration:(int)duration
                               status:(BOOL)status
                              success:(successBlock)success
                              failure:(failBlock)failure;

/**
 getTimingCountdown
 
 */
-(void)getTimingCountdown:(successBlock)success
                  failure:(failBlock)failure;



//** Light

-(void)updateIncandescentLightBrightness:(int)brightness
                                 success:(successBlock)success
                                 failure:(failBlock)failure;


-(void)updateRGBLightColorWithRGB:(NSString *)rgb
                          success:(successBlock)success
                          failure:(failBlock)failure;

-(void)updateRGBLightBrightness:(int)brightness
                        success:(successBlock)success
                        failure:(failBlock)failure;

//stream light
-(void)updateStreamLightColorWithRGB1:(NSString *)rgb1
                                 RGB2:(NSString *)rgb2
                                 RGB3:(NSString *)rgb3
                                 RGB4:(NSString *)rgb4
                              success:(successBlock)success
                              failure:(failBlock)failure;

-(void)updateStreamLightDuration:(int)duration
                         success:(successBlock)success
                         failure:(failBlock)failure;


-(void)updateStreamLightBrightness:(int)brightness
                           success:(successBlock)success
                           failure:(failBlock)failure;

//light MQTT
-(void)subscribeTopicOnDeviceSuccess:(successBlock)success;



@end




@interface Device : EHOMEBaseObject<NSCopying>

@property (nonatomic, assign) int actived;// = 1;
@property (nonatomic, copy) NSString *authKey;// = "<null>";
@property (nonatomic, assign) long long createTime;// = 1522225904000;
@property (nonatomic, assign) int deleted;// = 0;
@property (nonatomic, copy) NSString *devId;// = "0000000e_52_14_5";
@property (nonatomic, assign) long long firstActiveTime;// = 1522486103000;
@property (nonatomic, copy) NSString *hid;// = "dc:4f:22:28:af:79";
@property (nonatomic, assign) int id;// = 787;
@property (nonatomic, assign) long long lastOnlineTime;// = 1522630245000;
@property (nonatomic, assign) double lat;// = "<null>";
@property (nonatomic, assign) double lng;// = "<null>";
@property (nonatomic, copy) NSString *localKey;// = "<null>";
@property (nonatomic, copy) NSString *name;// = Hjjdlk;
@property (nonatomic, assign) int onlineTimes;// = 539;
@property (nonatomic, strong) Product *product;
@property (nonatomic, copy) NSString *secKey;// = "<null>";
@property (nonatomic, assign) int sellerId;// = 14;
@property (nonatomic, copy) NSString *status;// = "Offline","Normal","Upgrading";
@property (nonatomic, copy) NSString *token;// = "<null>";
@property (nonatomic, assign) long long updateTime;// = 1523522816000;
@property (nonatomic, assign) int uuid;// = 5;
@property (nonatomic, strong) Version *version;
@property (nonatomic, assign) int virtual;// = 0;


@end




@interface Function : EHOMEBaseObject

@property (nonatomic, assign) long long createTime;// = 1522225821000;
@property (nonatomic, assign) int deleted;// = 0;
@property (nonatomic, copy) NSString *funcType;// = "\U5e03\U5c14\U578b";
@property (nonatomic, assign) int id;// = 46;
@property (nonatomic, copy) NSString *name;// = "\U5f00\U51731";
@property (nonatomic, copy) NSString *nameEn;// = power;
@property (nonatomic, assign) int productId;// = 52;
@property (nonatomic, copy) NSString *remarks;// = "";
@property (nonatomic, copy) NSString *transType;// = "\U53ef\U4e0b\U53d1\U53ef\U4e0a\U62a5";
@property (nonatomic, assign) long long updateTime;// = 1522225821000;
@property (nonatomic, copy) NSString *value;// = "<null>";

@end




@interface FunctionValuesMap : EHOMEBaseObject

//only outlets
@property (nonatomic, assign) BOOL power;

//only light
@property (nonatomic, assign) BOOL colorLight;
@property (nonatomic, copy) NSString *colorData;
@property (nonatomic, copy) NSString *colorTemperature;
@property (nonatomic, copy) NSString *brightness;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *rgb1;
@property (nonatomic, copy) NSString *rgb2;
@property (nonatomic, copy) NSString *rgb3;
@property (nonatomic, copy) NSString *rgb4;

@end




@interface Product : EHOMEBaseObject<NSCopying>

@property (nonatomic, assign) int adminId;// = 14;
@property (nonatomic, copy) NSString *appId;// = "<null>";
@property (nonatomic, copy) NSString *brand;// = "<null>";
@property (nonatomic, copy) NSString *communicateType;// = WiFi;
@property (nonatomic, assign) int count;// = 73;
@property (nonatomic, assign) long long createTime;// = 1522226480000;
@property (nonatomic, assign) int deleted;// = 0;
@property (nonatomic, assign) int id;// = 53;
@property (nonatomic, copy) NSString *name;// = WhatiePlug;
@property (nonatomic, strong) Picture *picture;
@property (nonatomic, strong) Picture *pictureThumb;
@property (nonatomic, copy) NSString *productKey;// = "53_14";
@property (nonatomic, assign) int productType;// = 3;
@property (nonatomic, copy) NSString *status;// = "\U5df2\U53d1\U5e03";
@property (nonatomic, assign) int sum;// = 10000;
@property (nonatomic, copy) NSString *topic;// = "0*3";
@property (nonatomic, assign) long long updateTime;// = "<null>";

@end




@interface Version : EHOMEBaseObject

/**
 *  version of a device
 */
@property (nonatomic, copy) NSString *version;

@property (nonatomic, assign) long long createTime;// = 1522137915000;
@property (nonatomic, assign) int deleted;// = 0;
@property (nonatomic, strong) Picture *file;
@property (nonatomic, strong) Picture *fileRelated;
@property (nonatomic, assign) int id;// = 21;
@property (nonatomic, copy) NSString *remarks;// = "<null>";
@property (nonatomic, assign) int type;// = 50;
@property (nonatomic, copy) NSString *upgradeDoc;// = "<null>";
@property (nonatomic, assign) long long upgradeTime;// = "<null>";
@property (nonatomic, copy) NSString *upgradeType;// = "APP\U63d0\U9192\U5347\U7ea7";

@end




@interface Picture : EHOMEBaseObject<NSCopying>

@property (nonatomic, assign) long long createTime;// = 1522137915000;
@property (nonatomic, assign) int id;// = 145;
@property (nonatomic, copy) NSString *path;// = "https://files.d9lab.net/group1/M00/00/02/wKgA0lq8OX6AURfEAADFSQELCgo046.png";
@property (nonatomic, copy) NSString *type;// = "\U56fe\U7247";

@end





