//
//  EHOMEBaseObject.h
//  WhatieSDK
//
//  Created by IIDreams on 2018/4/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^startBlock)(void);//Block of Start
typedef void (^successBlock)(id responseObject);//Block of Success
typedef void (^progressBlock)(NSProgress *progress); //Blcock of Progress
typedef void (^failBlock)(NSError *error);//Block of Failure

@interface EHOMEBaseObject : NSObject

+(NSString *)getUrlByAction:(NSString *)action;

@end
