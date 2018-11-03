//
//  EHOMEMonochromeViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/10/14.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEMonochromeViewController.h"
#import "EHOMETimerTableViewController.h"

@interface EHOMEMonochromeViewController ()
@property (retain, nonatomic) IBOutlet UILabel *brightLabel;
@property (retain, nonatomic) IBOutlet UISlider *brightSlider;
@property (retain, nonatomic) IBOutlet UIButton *switchBtn;
@property (retain, nonatomic) IBOutlet UIView *backView;

- (IBAction)changeMonochromeStatus:(id)sender;

@end

@implementation EHOMEMonochromeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"Monochrome", @"DeviceFunction", nil);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock-Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addBulbTimerAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 18.0;
    
    self.brightSlider.minimumTrackTintColor = [UIColor THEMECOLOR];
    self.brightSlider.thumbTintColor = [UIColor THEMECOLOR];
    self.brightSlider.value = [self.monochromeDevice.functionValuesMap.brightness floatValue];
    [self.brightSlider addTarget:self action:@selector(monochromeBrightnessSliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    
    self.brightLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.brightSlider.value];
    
    [self.monochromeDevice subscribeTopicOnDeviceSuccess:^(id responseObject) {
        NSDictionary *dpsDic = [[responseObject objectForKey:@"data"] objectForKey:@"dps"];
        NSLog(@"单色灯亮度 = %@",dpsDic);
    }];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMonochromeData) name: EHOMEUserNotificationDeviceArrayChanged object:nil];
    //注册分享设备的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMonochromeData) name: EHOMEUserNotificationSharedDeviceArrayChanged object:nil];
    
    [self updateSwitchButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadMonochromeData{
    [self updateSwitchButton];
}

-(void)updateSwitchButton{
    NSLog(@"当前单色灯状态 = %d",self.monochromeDevice.functionValuesMap.colorLight);
    
    if (self.monochromeDevice.functionValuesMap.colorLight) {
        NSLog(@"单色灯的状态1是开 = %d",self.monochromeDevice.functionValuesMap.colorLight);
        [self.switchBtn setImage:[UIImage imageNamed:@"closeStrip"] forState:UIControlStateNormal];
    }else{
        NSLog(@"单色灯的状态2是开 = %d",self.monochromeDevice.functionValuesMap.colorLight);
        [self.switchBtn setImage:[UIImage imageNamed:@"openStrip"] forState:UIControlStateNormal];
    }
    
    self.brightSlider.value = [self.monochromeDevice.functionValuesMap.brightness floatValue];
    
    self.brightLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.brightSlider.value];
}

-(void)addBulbTimerAction{
    NSLog(@"进入单色灯定时");
    EHOMETimerTableViewController *TimerVC = [[EHOMETimerTableViewController alloc] initWithNibName:@"EHOMETimerTableViewController" bundle:nil];
    TimerVC.device = self.monochromeDevice;
    [self.navigationController pushViewController:TimerVC animated:YES];
}

-(void)monochromeBrightnessSliderValueChange:(UISlider *)slider{
    
    NSLog(@"monochrome brightness slider value = %f", slider.value);
    
    self.brightSlider.value = slider.value;
    
    self.brightLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.brightSlider.value];
    
    [self.monochromeDevice updateIncandescentLightBrightness:(int)slider.value success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_brightLabel release];
    [_brightSlider release];
    [_switchBtn release];
    [_backView release];
    [super dealloc];
}
- (IBAction)changeMonochromeStatus:(id)sender {
    
    BOOL status = self.monochromeDevice.functionValuesMap.colorLight;
    NSLog(@"改变单色灯开关为 = %d",!status);
    [self.monochromeDevice updateDeviceStatus:!status success:^(id responseObject) {
        
        NSLog(@"OPOPOPOPO");
        
        [self updateSwitchButton];
    } failure:^(NSError *error) {
        
        NSLog(@"YYYYYYYYY");
        
        [self updateSwitchButton];
    }];
}

@end
