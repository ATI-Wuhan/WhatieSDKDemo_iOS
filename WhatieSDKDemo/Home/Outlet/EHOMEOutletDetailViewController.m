//
//  EHOMEOutletDetailViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/5/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEOutletDetailViewController.h"

@interface EHOMEOutletDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;
- (IBAction)alarmAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
- (IBAction)countdownAction:(id)sender;
@end

@implementation EHOMEOutletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.outlet.device.name;
    
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

- (IBAction)alarmAction:(id)sender {
    
}

- (IBAction)countdownAction:(id)sender {
    
    BOOL isOn = self.outlet.functionValuesMap.power;
    
    [EHOMEDeviceModel countdownDeviceWithDeviceModel:self.outlet toStatus:!isOn duration:10 startBlock:^{
        
    } successBlock:^(id responseObject) {
        int duration = [[responseObject objectForKey:@"duration"] intValue];
        [self countdownLabelWithDuration:duration];
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)countdownLabelWithDuration:(int)duration{
    
    int time = duration;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.countdownLabel.text = [NSString stringWithFormat:@"%d", time];
    });

    
    if (time > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self countdownLabelWithDuration:time - 1];
        });
    }else{
        self.countdownLabel.text = @"countdown over";
    }
}

@end
