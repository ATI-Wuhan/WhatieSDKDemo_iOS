//
//  EHOMESmartConfigViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/21.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESmartConfigViewController.h"

@interface EHOMESmartConfigViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation EHOMESmartConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Smart Config";
    

    [[EHOMESmartConfig shareInstance]smartConfigWithWifiPassword:_wifiPassword accessId:AccessId accessKey:AccessKey startBlock:^{
        NSLog(@"Start to smart config...");
    } progressBlock:^(NSProgress *progress) {

        NSLog(@"smart config progress = %@", progress);
        
        self.progressView.progress = progress.fractionCompleted;
        
    } successBlock:^(id responseObject) {
        NSLog(@"Smart config success = %@", responseObject);
        
        self.progressView.progress = 1;
        
        
        
    } failBlock:^(NSError *error) {
        NSLog(@"Smart config failed = %@", error);
        
        self.progressView.progress = 0;
    }];
    
    [[EHOMEMQTTClientManager shareInstance] setMqttBlock:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"配网收到MQTT数据 = %@", dic);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
