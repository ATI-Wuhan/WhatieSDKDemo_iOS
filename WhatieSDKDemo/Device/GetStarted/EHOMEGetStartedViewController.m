//
//  EHOMEGetStartedViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/5/2.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEGetStartedViewController.h"

@interface EHOMEGetStartedViewController ()



@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

- (IBAction)getStartedButtnAction:(id)sender;

@end

@implementation EHOMEGetStartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Get Started", @"Device", nil);
    
    self.deviceNameTextField.text = self.deviceName;
    
    self.getStartedButton.backgroundColor = THEMECOLOR;
    self.getStartedButton.layer.masksToBounds = YES;
    self.getStartedButton.layer.cornerRadius = 3.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getStartedButtnAction:(id)sender {
    
    NSString *deviceName = self.deviceNameTextField.text;
    if ([deviceName length] == 0) {
        deviceName = NSLocalizedStringFromTable(@"No Name.", @"Device", nil);
    }
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please Wait", @"Device", nil) hideAfterDelay:15];
    
    [[EHOMESmartConfig shareInstance] getStartedWithDevId:_devId deviceName:self.deviceNameTextField.text success:^(id responseObject) {
        NSLog(@"GET STARTED Success = %@", responseObject);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GetStartedNotice" object:nil userInfo:nil]];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"GET STARTED Failed = %@", error);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
    }];

}

@end
