//
//  EHOMESmartConfig.h
//  WhatieSDK
//
//  Created by Change on 2018/4/18.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"


@interface EHOMESmartConfig : EHOMEBaseObject

/**
 instance
 
 @return self
 */
+(EHOMESmartConfig *)shareInstance;

-(void)startSmartConfigWithSsid:(NSString *)ssid
                          bssid:(NSString *)bssid
                       password:(NSString *)password
                       progress:(progressBlock)progress
                        success:(successBlock)success
                        failure:(failBlock)failure;


-(void)getStartedWithDevId:(NSString *)devId
                deviceName:(NSString *)deviceName
                   success:(successBlock)success
                   failure:(failBlock)failure;



@end
