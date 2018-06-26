//
//  EHOMEColorSlider.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEColorSlider.h"

@implementation EHOMEColorSlider

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self normalSettings];
        [self loadGradientLayers];
    }
    return self;
}
-(void)normalSettings{
    self.minimumTrackTintColor=[UIColor clearColor];
    self.maximumTrackTintColor=[UIColor clearColor];
}
-(void)loadGradientLayers{
    self.colorArray = @[
                        (id)RGB(255, 99, 71).CGColor,
                        (id)RGB(255, 236, 139).CGColor,
                        (id)RGB(152, 251, 152).CGColor,
                        (id)RGB(0, 178, 238).CGColor,
                        (id)RGB(148, 0, 211).CGColor
                        ];
    self.colorLocationArray = @[@0.1, @0.3, @0.5, @0.7, @1];
    self.gradientLayer =  [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(2,0,self.frame.size.width-2,30);
//    self.gradientLayer.masksToBounds = YES;
//    self.gradientLayer.cornerRadius = 0;
    [self.gradientLayer setLocations:self.colorLocationArray];
    [self.gradientLayer setColors:self.colorArray];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.layer addSublayer:self.gradientLayer];
}


@end
