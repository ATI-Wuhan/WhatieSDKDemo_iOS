//
//  EHOMETcpClient.h
//  WhatieSDK
//
//  Created by Change on 2018/4/16.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"
#import "GCDAsyncSocket.h"

@protocol tcpClientDelegate <NSObject>

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSString *)dataJson;

@end

@interface EHOMETcpClient : EHOMEBaseObject<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, assign) long readTag;
@property (nonatomic, assign) long writeTag;

@property(nonatomic,strong)NSString *hostStr;
-(long)getReadTag;
-(long)getWriteTag;
-(void)createTcpSocket:(const char *)queueName connectToHost:(NSString *) host onPort:(uint16_t)port;
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;
-(void)writeString:(NSString *)str withTag:(long)tag;
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
-(void)disconnect;
-(BOOL)isConnected;

@property (nonatomic, assign) id<tcpClientDelegate> delegate;

@end
