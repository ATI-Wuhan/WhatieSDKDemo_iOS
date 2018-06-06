//
//  EHOMETCPManager.h
//  WhatieSDK
//
//  Created by Change on 2018/4/14.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"
#import "EHOMETcpClient.h"
#import "GCDAsyncUdpSocket.h"
#import "EHOMEDeviceModel.h"

typedef void(^TCPBlock)(GCDAsyncSocket *sock, NSString *data);


@interface EHOMETCPManager : EHOMEBaseObject

@property (nonatomic, copy) TCPBlock tcpBlock;


/**
 tcpClientDictionary
 
 This is a dictionary with key and value as @{@"devId" : EHOMETcpClient}
 You can get the EHOMETcpClient object with deviceId(key),like:
 [EHOMETcpManager shareInstance].tcpClientDictionary[@"deviceId"],
 Before this,you should ensure if the key is exist.
 After get the object of EHOMETcpClient,you can send operation data if the connectd is YES.
 */
@property (nonatomic, strong) NSMutableDictionary *tcpClientDictionary;

/**
 instance
 
 @return self
 */
+(EHOMETCPManager *)shareInstance;

-(BOOL)isCurrentDeviceTCPConnectedWithDeviceModel:(EHOMEDeviceModel *)deviceModel;

-(void)switchDeviceStatusWithDeviceModel:(EHOMEDeviceModel *)deviceModel
                                  status:(BOOL)status
                            successBlock:(successBlock)successblock
                               failBlock:(failBlock)failblock;

@end
