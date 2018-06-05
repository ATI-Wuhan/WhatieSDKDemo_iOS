//
//  EHOMENetWorking.h
//  WhatieSDK
//
//  Created by Change on 2018/4/27.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"

@interface EHOMENetWorking : EHOMEBaseObject


/**
 * POST REQUEST（NSURLSession）JSON DICTIONARY
 */

+ (void)postRequestWithUrl:(NSString *)url
                    params:(NSDictionary *)params
              successBlock:(successBlock)successblock
                 failBlock:(failBlock)failblock;

+ (void)postRequestWithUrl:(NSString *)url
                    params:(NSDictionary *)params
                startBlock:(startBlock)startblock
              successBlock:(successBlock)successblock
                 failBlock:(failBlock)failblock;

@end
