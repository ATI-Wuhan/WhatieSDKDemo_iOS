//
//  EHOMEExtensions.h
//  WhatieSDK
//
//  Created by Change on 2018/4/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEBaseObject.h"

@interface EHOMEExtensions : EHOMEBaseObject

+(NSString *)MD5EncryptedWith:(NSString *)string;

+(NSString *)dictionaryToJsonStringWithDictionary:(NSDictionary *)dic;

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
