//
//  EHOMEExperienceOutletsViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/27.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEExperienceOutletsViewController.h"

@interface EHOMEExperienceOutletsViewController ()

@property (nonatomic, assign) BOOL isOn;

@property (weak, nonatomic) IBOutlet UILabel *outletsStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

- (IBAction)updateOutletsStatusAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@end

@implementation EHOMEExperienceOutletsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Outlets Experience", @"Profile", nil);
    
    self.countdownLabel.text = NSLocalizedStringFromTable(@"Timing countdown", @"DeviceFunction", nil);
    self.TimerLabel.text = NSLocalizedStringFromTable(@"Timer", @"DeviceFunction", nil);
    self.optionLabel.text = NSLocalizedStringFromTable(@"Options", @"Device", nil);
    
    self.switchButton.layer.masksToBounds = YES;
    self.switchButton.layer.cornerRadius = 3.0;
    self.switchButton.backgroundColor = [UIColor THEMECOLOR];
    
    self.isOn = YES;
    [self updateDeviceStatus:self.isOn];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor THEMECOLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)updateOutletsStatusAction:(id)sender {
    
    self.isOn = !self.isOn;
    
    [self updateDeviceStatus:self.isOn];
    
}


-(void)updateDeviceStatus:(BOOL)status{
    
    if (status) {
        self.view.backgroundColor = [UIColor THEMECOLOR];
        self.navigationController.navigationBar.barTintColor = [UIColor THEMECOLOR];
        self.outletsStatusLabel.text = NSLocalizedStringFromTable(@"Outlets is On", @"Device", nil);
        [self.switchButton setTitle:NSLocalizedStringFromTable(@"Close", @"Device", nil) forState:UIControlStateNormal];
        self.switchButton.backgroundColor = RGB(61, 61, 61);
    }else{
        self.view.backgroundColor = RGB(61, 61, 61);
        self.navigationController.navigationBar.barTintColor = RGB(61, 61, 61);
        self.outletsStatusLabel.text = NSLocalizedStringFromTable(@"Outlets is Off", @"Device", nil);
        [self.switchButton setTitle:NSLocalizedStringFromTable(@"Open", @"Device", nil) forState:UIControlStateNormal];
        self.switchButton.backgroundColor = [UIColor THEMECOLOR];
    }
}

@end
