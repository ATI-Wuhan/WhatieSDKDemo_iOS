//
//  EHOMEExtension.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/1.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEExtension.h"

@implementation EHOMEExtension

@end


@implementation UIColor(EHOMEExtension)

+(UIColor *)THEMECOLOR{
    
    switch (CurrentApp) {
        case eHome:
            return RGB(38, 175, 246);
            break;
        case Geek:
            return RGB(25, 107, 162);
            break;
        case Ozwi:
            return RGB(0, 145, 152);
            break;
            
        default:
            return RGB(38, 175, 246);
            break;
    }

}

@end
