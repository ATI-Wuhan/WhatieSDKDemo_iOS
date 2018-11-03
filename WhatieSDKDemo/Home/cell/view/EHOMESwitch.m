//
//  EHOMESwitch.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/11/2.
//  Copyright © 2018 IIDreams. All rights reserved.
//

#import "EHOMESwitch.h"

@implementation EHOMESwitch
{
    UISwitch *mySwitch;
    UIActivityIndicatorView *activityIndicatorView;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.color = [UIColor THEMECOLOR];
        activityIndicatorView.center = CGPointMake(30, 15);
        [self addSubview:activityIndicatorView];
        
        mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(6, 5, 49, 31)];
        mySwitch.onTintColor = [UIColor THEMECOLOR];
        [mySwitch addTarget:self action:@selector(clickedSwitch:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:mySwitch];
    }
    
    return self;
}

-(void)showLoading{
    mySwitch.hidden = YES;
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
}

-(void)showSwitchStatus:(int)status{
    
    activityIndicatorView.hidden = YES;
    mySwitch.hidden = NO;
    
    
    if (status == 0) {
        [mySwitch setOn:NO];
        [mySwitch setEnabled:YES];
    }else if (status == 1){
        [mySwitch setOn:YES];
        [mySwitch setEnabled:YES];
    }else{
        [mySwitch setOn:NO];
        [mySwitch setEnabled:NO];
    }
    
    
}

-(void)clickedSwitch:(UISwitch *)sender{
    
    [self showLoading];
    
    [self.delegate clickedMySwitchWithStatus:sender.on];
}

@end
