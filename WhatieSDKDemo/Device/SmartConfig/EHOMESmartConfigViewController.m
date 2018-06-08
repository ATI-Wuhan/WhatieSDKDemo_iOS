//
//  EHOMESmartConfigViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/21.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESmartConfigViewController.h"

#import <PPNetworkHelper/PPNetworkHelper.h>
#import "EHOMEGetStartedViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface EHOMESmartConfigViewController ()

@property (weak, nonatomic) IBOutlet UIView *indicatorBGView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, copy) NSString *SSID;
@property (nonatomic, copy) NSString *BSSID;
@property (nonatomic, copy) NSString *password;

@end

@implementation EHOMESmartConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Smart Config";
    
    __weak typeof(self) weakSelf = self;
    
    self.indicatorBGView.layer.masksToBounds = YES;
    self.indicatorBGView.layer.cornerRadius = 5.0;
    
    [self.indicator startAnimating];
    
    NSString *ssid = [[self wifiInfo] objectForKey:@"SSID"];
    NSString *bssid = [[self wifiInfo] objectForKey:@"BSSID"];
    NSString *password = self.wifiPassword;

    
    [[EHOMESmartConfig shareInstance] startSmartConfigWithSsid:ssid bssid:bssid password:password success:^(id responseObject) {
        NSLog(@"Smart config success = %@", responseObject);
        
        [self.indicator stopAnimating];

        
        NSString *title = @"Success";
        NSString *message = @"Smart Config Success.";
        
        NSInteger protocol = [[responseObject objectForKey:@"protocol"] integerValue];
        
        if (protocol == 9) {
            //success
            
            EHOMEGetStartedViewController *getStartedVC = [[EHOMEGetStartedViewController alloc] initWithNibName:@"EHOMEGetStartedViewController" bundle:nil];
            getStartedVC.devId = [[responseObject objectForKey:@"data"] objectForKey:@"devId"];
            getStartedVC.deviceName = [[responseObject objectForKey:@"data"] objectForKey:@"name"];
            [self.navigationController pushViewController:getStartedVC animated:YES];
            
        }else{
            //the device is other's
            title = @"Sorry";
            NSString *email = [[responseObject objectForKey:@"data"] objectForKey:@"email"];
            message = [NSString stringWithFormat:@"The device is now available,but it isn't belongs to you.Please try to email %@",email];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"Smart config failed = %@", error);
        [self.indicator stopAnimating];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)wifiInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"interfaces:%@",ifs);
    NSDictionary *info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        NSLog(@"%@ => %@",ifname,info);
    }
    return info;
}






@end
