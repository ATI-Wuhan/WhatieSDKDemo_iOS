//
//  EHOMEColorSlider.h
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEColorSlider : UISlider

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorLocationArray;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end
