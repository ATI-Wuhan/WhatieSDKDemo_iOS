//
//  EHOMEOutletDetailViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/5/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEOutletDetailViewController.h"
#import "EHOMETimerTableViewController.h"

@interface EHOMEOutletDetailViewController ()

@property (nonatomic, assign) int duration;
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIImageView *outletImageView;
@property (weak, nonatomic) IBOutlet UILabel *outletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *outletStatusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *outletSwitch;

- (IBAction)updateDeviceStatus:(id)sender;


- (IBAction)timerAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

- (IBAction)timingCountdownAction:(id)sender;

@end

@implementation EHOMEOutletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Device";
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editDeviceAction)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    self.outletNameLabel.text = self.device.device.name;
    
    [self.outletImageView sd_setImageWithURL:[NSURL URLWithString:self.device.device.product.picture.path] placeholderImage:[UIImage imageNamed:@"socket"]];
    
    [self showDeviceInfo];
    
    [self.device getTimingCountdown:^(id responseObject) {
        NSLog(@"get timing countdown success. res = %@", responseObject);
        
        EHOMETimer *timer = responseObject;
        
        if (timer.durationTime > 0) {
            self.duration = timer.durationTime;
            [self countdownLabelWithDuration:self.duration];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"get timing countdown failed. error = %@", error);
    }];
    
}

-(void)editDeviceAction{
    
    //edit device
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Options" message:@"Edit device name,remove device,and share device." preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *updateNameAction = [UIAlertAction actionWithTitle:@"update device name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"update device name action");
        
        [self updateDeviceName];
    }];

    UIAlertAction *shareDeviceAction = [UIAlertAction actionWithTitle:@"share device" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"share device action");
        [self shareDevice];
    }];
    
    UIAlertAction *removeDeviceAction = [UIAlertAction actionWithTitle:@"remove device" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"remove device action");
        [self removeDevice];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateNameAction];
    [alertController addAction:shareDeviceAction];
    [alertController addAction:removeDeviceAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)updateDeviceName{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"update device name" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"device name";
        textField.text = self.device.device.name;
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        
        NSString *devicename = [alertController.textFields firstObject].text;
        
        [self.device updateDeviceName:devicename success:^(id responseObject) {
            NSLog(@"update device name success. res = %@", responseObject);
            
            self.device.device.name = devicename;
            
            self.outletNameLabel.text = self.device.device.name;
            
            self.updateDeviceStatusBlock(self.device);
            
        } failure:^(NSError *error) {
            NSLog(@"update device name failed. error = %@", error);
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)shareDevice{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"share device to your friend by email." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"your friends email...";
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        
        NSString *email = [alertController.textFields firstObject].text;
        
        [self.device shareDeviceByEmail:email success:^(id responseObject) {
            NSLog(@"share device success. res = %@", responseObject);
            
            [HUDHelper addHUDInView:sharedKeyWindow text:@"Share device success." hideAfterDelay:1.5];
            
        } failure:^(NSError *error) {
            NSLog(@"share device failed. error = %@", error);
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)removeDevice{
    
}

-(void)showDeviceInfo{

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.device.device.status isEqualToString:@"Offline"]) {
            [self.outletSwitch setOn:NO];
            self.outletStatusLabel.text = @"Offline";
        }else{
            if (self.device.functionValuesMap.power) {
                self.outletStatusLabel.text = @"On";
                [self.outletSwitch setOn:YES];
            }else{
                self.outletStatusLabel.text = @"Off";
                [self.outletSwitch setOn:NO];
            }
        }
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)updateDeviceStatus:(id)sender {
    
    UISwitch *deviceSwitch = (UISwitch *)sender;
    
    BOOL isOn = deviceSwitch.on;
    
    __weak typeof(self) weakSelf = self;
    
    [self.device updateDeviceStatus:isOn success:^(id responseObject) {
        NSLog(@"update device status success. res = %@", responseObject);
        
        EHOMEDeviceModel *device = responseObject;
        weakSelf.device = device;
        [weakSelf showDeviceInfo];
        
        weakSelf.updateDeviceStatusBlock(device);
        
    } failure:^(NSError *error) {
        NSLog(@"update device status failed. error = %@", error);
    }];
}

- (IBAction)timerAction:(id)sender {
    
    EHOMETimerTableViewController *timerTVC = [[EHOMETimerTableViewController alloc] initWithNibName:@"EHOMETimerTableViewController" bundle:nil];
    timerTVC.device = self.device;
    [self.navigationController pushViewController:timerTVC animated:YES];
}

- (IBAction)timingCountdownAction:(id)sender {
    
    BOOL isOn = self.device.functionValuesMap.power;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Timing Countdown" message:@"Start timing countdown" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"duration";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        int duration = [[[alertController textFields] firstObject].text intValue];
        
        if (duration <= 0) {
            [HUDHelper addHUDInView:sharedKeyWindow text:@"Please enter duration" hideAfterDelay:1.0];
        }else{
            
            __weak typeof(self) weakSelf = self;
            
            [self.device addTimingCountdownWithDuration:duration status:!isOn success:^(id responseObject) {
                
                NSLog(@"add timing countdown success. res = %@", responseObject);
                
                int duration = [[responseObject objectForKey:@"duration"] intValue];
                [weakSelf countdownLabelWithDuration:duration];
            } failure:^(NSError *error) {
                NSLog(@"add timing countdown failed. error = %@", error);
            }];
        }
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)countdownLabelWithDuration:(int)duration{
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.duration = duration;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    
}

-(void)timeHeadle{

    self.duration --;

    if (self.duration > 0) {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d", self.duration];
    }else{
        self.countdownLabel.text = @"No timing  countdown";
    }
}

@end
