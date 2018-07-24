//
//  EHOMEScanViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/5/2.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEScanViewController.h"

#import <SGQRCode/SGQRCode.h>

@interface EHOMEScanViewController ()<SGQRCodeScanManagerDelegate>

@end

@implementation EHOMEScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Scan";
    
    SGQRCodeScanManager *scanManager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080
    [scanManager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    scanManager.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects{
    
//    NSLog(@"scan data = %@", metadataObjects);
    
    NSString *json = [metadataObjects firstObject];
    
    NSDictionary *dic = [EHOMEExtensions dictionaryWithJsonString:json];

    
    NSDictionary *resultDic=[dic objectForKey:@"infoObj"];
    

    int adminId = [[resultDic objectForKey:@"adminId"] intValue];
    int deviceId = [[resultDic objectForKey:@"deviceId"] intValue];
    long timestamp = [[resultDic objectForKey:@"timestamp"] longValue];


//    [EHOMEDeviceModel sharedDeviceWithAdminUserId:adminId sharedUserId:[EHOMEUserModel getCurrentUser].id deviceId:deviceId timestamp:timestamp startBlock:^{
//        NSLog(@"Sharing device...");
//    } suucessBlock:^(id responseObject) {
//        NSLog(@"Share device success.= %@",responseObject);
//        
//        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GetStartedNotice" object:nil userInfo:nil]];
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//    } failBlock:^(NSError *error) {
//        NSLog(@"Share device failed. = %@", error);
//    }];
    
}

@end
