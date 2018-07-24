//
//  EHOMEConfirmWifiViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/21.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#import<SystemConfiguration/CaptiveNetwork.h>
#import<SystemConfiguration/SystemConfiguration.h>
#import<CoreFoundation/CoreFoundation.h>
#import "EHOMEConfirmWifiViewController.h"
#import "UIImage+GIF.h"
#import "EHOMESmartConfigViewController.h"

@interface EHOMEConfirmWifiViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonAction:(id)sender;

@property(nonatomic,strong) NSString *wifiName;
@property(nonatomic,strong) NSString *Bssid;
@end

@implementation EHOMEConfirmWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Confirm", @"Device", nil);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"deviceGIF" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.deviceImageView.image = [UIImage sd_animatedGIFWithData:data];
    
    self.descriptionLabel.text = NSLocalizedStringFromTable(@"Confirmtext", @"Device", nil);
    
    self.nextButton.backgroundColor = THEMECOLOR;
    [self.nextButton setTitle:NSLocalizedStringFromTable(@"next", @"Device", nil) forState:UIControlStateNormal];
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius = 3.0;
    
    [self GetWifiName];
}

//获取WiFi名字和BSSID
- (void)GetWifiName{
    
    self.wifiName = NSLocalizedStringFromTable(@"NOT FOUND", @"Device", nil);
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            self.wifiName = [dict valueForKey:@"SSID"];
            self.Bssid=[dict valueForKey:@"BSSID"];
            NSLog(@"dic%@",dict);
        }
        NSLog(@"wifiName:%@", self.wifiName);
        NSLog(@"bssid：%@",self.Bssid);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)nextButtonAction:(id)sender {
    
    NSString *title = NSLocalizedStringFromTable(@"Confirm Wifi", @"Device", nil);
    NSString *currentWifi=NSLocalizedStringFromTable(@"current wifi", @"Device", nil);
    NSString *message = [NSString stringWithFormat:@"%@:%@",currentWifi,self.wifiName];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *cancel = NSLocalizedStringFromTable(@"Cancel", @"Info", nil);
    NSString *next = NSLocalizedStringFromTable(@"OK", @"Info", nil);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:next style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *password = [alertController.textFields firstObject].text;
        [self gotoSmartConfigActionWithPassword:password];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"wifi password", @"Device", nil);
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)gotoSmartConfigActionWithPassword:(NSString *)password{
    EHOMESmartConfigViewController *smartConfigVC = [[EHOMESmartConfigViewController alloc] initWithNibName:@"EHOMESmartConfigViewController" bundle:nil];
    smartConfigVC.wifiPassword = password;
    [self.navigationController pushViewController:smartConfigVC animated:YES];
}



@end
