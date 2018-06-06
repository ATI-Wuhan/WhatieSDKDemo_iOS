//
//  EHOMESDK.h
//  EHOMESDK
//
//  Created by IIDreams_zhouwei on 2018/4/28.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <WhatieSDK/WhatieSDK.h>

@interface EHOMESDK : EHOMEBaseObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *secretKey;


/**
 instance
 
 @return self
 */
+(EHOMESDK *)shareInstance;


-(void)startWithAppId:(NSString *)appId secretKey:(NSString *)secretKey;


@end
