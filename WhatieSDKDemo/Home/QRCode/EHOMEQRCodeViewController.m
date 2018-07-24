//
//  EHOMEQRCodeViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/5/2.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEQRCodeViewController.h"

#import <SGQRCode/SGQRCode.h>

@interface EHOMEQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@end

@implementation EHOMEQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Share Device";
    
    self.deviceNameLabel.text = self.deviceModel.device.name;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    long dTime = [[NSNumber numberWithDouble:time] longValue];
    
    NSDictionary *shareDic = @{@"infoObj":@{@"adminId":@([EHOMEUserModel getCurrentUser].id),
                                            @"deviceId":@(self.deviceModel.device.id),
                                            @"timestamp":@(dTime)
                                            },
                               @"usage":@(2)
                               };
    
    NSString *shareJson = [EHOMEExtensions dictionaryToJsonStringWithDictionary:shareDic];
    
    self.qrCodeImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:shareJson imageViewWidth:240];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
