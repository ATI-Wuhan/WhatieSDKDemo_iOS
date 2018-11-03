//
//  EHOMESmartConfig.h
//  WhatieSDK
//
//  Created by Change on 2018/4/18.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"
#import "EHOMEHomeModel.h"
#import "EHOMERoomModel.h"


@interface EHOMESmartConfig : EHOMEBaseObject

/**
 instance
 
 @return self
 */
+(EHOMESmartConfig *)shareInstance;

/**
 start SmartConfig
 
 */
-(void)startSmartConfigWithSsid:(NSString *)ssid
                          bssid:(NSString *)bssid
                       password:(NSString *)password
                        success:(successBlock)success
                        failure:(failBlock)failure;

-(void)getStartedWithDevId:(NSString *)devId
                deviceName:(NSString *)deviceName
                   success:(successBlock)success
                   failure:(failBlock)failure;

/**
 add device into room
 
 */
-(void)getStartedWithDevId:(NSString *)devId
                deviceName:(NSString *)deviceName
                      home:(EHOMEHomeModel *)homeModel
                      room:(EHOMERoomModel *)roomModel
                   success:(successBlock)success
                   failure:(failBlock)failure;

-(void)stopSmartConfig;



@end
