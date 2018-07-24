//
//  EHOMELogoView.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/27.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMELogoView.h"

@implementation EHOMELogoView{
    UIImageView *logoImageView;
    UILabel *versionLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        logoImageView = [[UIImageView alloc] init];
        versionLabel = [[UILabel alloc] init];
        
        [self addSubview:logoImageView];
        [self addSubview:versionLabel];
        
        [self autoLayout];
        [self showDeviceImage];
    }
    
    return self;
}

-(void)autoLayout{
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(-20);
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(21);
        make.top.mas_equalTo(logoImageView.mas_bottom).mas_offset(10);
    }];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:16];
}

-(void)showDeviceImage{
    [logoImageView setImage:[UIImage imageNamed:@"AppIconGeekPlus"]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    versionLabel.text = [NSString stringWithFormat:@"GeekHome %@", app_Version];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
