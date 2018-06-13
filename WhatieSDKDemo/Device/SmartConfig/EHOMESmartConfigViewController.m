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

#import <QuartzCore/QuartzCore.h>
#import <MDRadialProgress/MDRadialProgressView.h>
#import <MDRadialProgress/MDRadialProgressTheme.h>

@interface EHOMESmartConfigViewController ()

@property (nonatomic, copy) NSString *SSID;
@property (nonatomic, copy) NSString *BSSID;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) MDRadialProgressView *progressView;
@property (nonatomic, assign) int duration;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation EHOMESmartConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Smart Config";
    
    __weak typeof(self) weakSelf = self;
    
    
    NSString *ssid = [[self wifiInfo] objectForKey:@"SSID"];
    NSString *bssid = [[self wifiInfo] objectForKey:@"BSSID"];
    NSString *password = self.wifiPassword;
    

    [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"SmartConfig..." hideAfterDelay:60];
    
    [[EHOMESmartConfig shareInstance] startSmartConfigWithSsid:ssid bssid:bssid password:password success:^(id responseObject) {
        NSLog(@"Smart config success = %@", responseObject);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];

        
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
        
        [weakSelf showAlertViewWithTitle:title message:message];
        
    } failure:^(NSError *error) {
        NSLog(@"Smart config failed = %@", error);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];

        [weakSelf showAlertViewWithTitle:@"Alert" message:error.domain];
    }];

}


-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
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
