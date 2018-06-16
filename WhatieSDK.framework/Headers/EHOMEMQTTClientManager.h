//
//  EHOMEMQTTClientManager.h
//  WhatieSDK
//
//  Created by IIDreams on 2018/4/14.
//  Copyright © 2018年 IIDreams. All rights reserved.
//



#import "EHOMEBaseObject.h"
#import "EHOMEDeviceModel.h"


typedef void(^MQTTBlock)(NSString *topic, NSData *data);

@interface EHOMEMQTTClientManager : EHOMEBaseObject


@property (nonatomic, copy) MQTTBlock mqttBlock;


/**
 instance
 
 @return self
 */
+(EHOMEMQTTClientManager *)shareInstance;

/**
 loginMQTT
 
 MQTT Login，and subscription topic of user
 */
-(void)loginMQTT;


-(void)subscribeTopicsWithTopics:(NSDictionary *)topics;


/**
 publish
 
 publish data to topic
 */
-(void)publishAndWaitData:(NSData *)data;

/**
 publish
 
 publish data to topic
 */
-(void)publishAndWaitData:(NSData *)data onTopic:(NSString *)topic;


/**
 close
 
 close the connection of mqttSession
 */
-(void)close;


@end
