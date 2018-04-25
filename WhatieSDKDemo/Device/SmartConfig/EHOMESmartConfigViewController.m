//
//  EHOMESmartConfigViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/21.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESmartConfigViewController.h"

//#import "ESPTouchTask.h"
//#import "ESPTouchResult.h"
#import <PPNetworkHelper/PPNetworkHelper.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface EHOMESmartConfigViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, copy) NSString *SSID;
@property (nonatomic, copy) NSString *BSSID;
@property (nonatomic, copy) NSString *password;

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
        
        NSString *title = @"Success";
        NSString *message = @"Smart Config Success.";
        
        NSInteger protocol = [[responseObject objectForKey:@"protocol"] integerValue];
        if (protocol == 9) {
            //success
        }else{
            //the device is other's
            title = @"Sorry";
            NSString *email = [[responseObject objectForKey:@"data"] objectForKey:@"email"];
            message = [NSString stringWithFormat:@"The device is now available,but it isn't belongs to you.Please try to email %@",email];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];

    } failBlock:^(NSError *error) {
        NSLog(@"Smart config failed = %@", error);
        self.progressView.progress = 0;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
