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
    
    self.title = @"Get Started";
    
    self.deviceNameTextField.text = self.deviceName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getStartedButtnAction:(id)sender {
    
    NSString *deviceName = self.deviceNameTextField.text;
    if ([deviceName length] == 0) {
        deviceName = @"No Name.";
    }
    
    [[EHOMESmartConfig shareInstance] getStartedWithDevId:_devId deviceName:self.deviceNameTextField.text success:^(id responseObject) {
        NSLog(@"GET STARTED Success = %@", responseObject);
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GetStartedNotice" object:nil userInfo:nil]];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"GET STARTED Failed = %@", error);
    }];

}

@end
