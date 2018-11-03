//
//  EHOMEOutletDetailViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/5/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEOutletDetailViewController.h"
#import "EHOMETimerTableViewController.h"
#import "EHOMEShareViewController.h"

@interface EHOMEOutletDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *optionsLabel;
@property (nonatomic, assign) int duration;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int setDuratuon;
@property (nonatomic, assign) int setClockId;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UIButton *switchButton;
- (IBAction)updateDeviceStatusAction:(id)sender;


- (IBAction)timerAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

- (IBAction)timingCountdownAction:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) IBOutlet UILabel *timingCountdownLabel;

@end

@implementation EHOMEOutletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Device", @"Device", nil);
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Edit", @"Device", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editDeviceAction)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    self.optionsLabel.text = NSLocalizedStringFromTable(@"Options", @"Device", nil);
    
    self.timerLabel.text = NSLocalizedStringFromTable(@"Timer", @"DeviceFunction", nil);
    self.timingCountdownLabel.text = NSLocalizedStringFromTable(@"Timing countdown", @"DeviceFunction", nil);
    
    self.switchButton.layer.masksToBounds = YES;
    self.switchButton.layer.cornerRadius = 3.0;
    [self updateOutletView];
    
    [[EHOMEMQTTClientManager shareInstance] setMqttBlock:^(NSString *topic, NSData *data) {
        NSDictionary *MQTTMessage = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"接收到插座mqtt消息 = %@",MQTTMessage);
        if([[MQTTMessage objectForKey:@"protocol"] intValue] == 13){
            if([[[MQTTMessage objectForKey:@"data"] objectForKey:@"devId"] isEqualToString:self.device.device.devId]){
                
                if([[[MQTTMessage objectForKey:@"data"] objectForKey:@"executionType"] intValue] == 2){
                    int Duration = [[[MQTTMessage objectForKey:@"data"] objectForKey:@"duration"] intValue];
                    int ClockId = [[[MQTTMessage objectForKey:@"data"] objectForKey:@"clockId"] intValue];
                    self.setDuratuon = Duration;
                    self.setClockId = ClockId;
                    self.duration = Duration;
                    [self countdownLabelWithDuration:Duration];
                }else if ([[[MQTTMessage objectForKey:@"data"] objectForKey:@"executionType"] intValue] == 0){
                    [self countdownLabelWithDuration:0];
                }
            }
        }
    }];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationDeviceArrayChanged object:nil];
    //注册分享设备的通知   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationSharedDeviceArrayChanged object:nil];
    
    
    [self.device getTimingCountdown:^(id responseObject) {
        NSLog(@"get timing countdown success. res = %@", [responseObject firstObject]);
        
        EHOMETimer *timer = [responseObject firstObject];
        
        if (timer.durationTime > 0) {
            self.duration = timer.durationTime;
            [self countdownLabelWithDuration:self.duration];
        }
        
    } failure:^(NSError *error) {
//        [HUDHelper showErrorDomain:error];
    }];
    
}

-(void)reloadData{
    
    NSLog(@"设备状态变化了");
    [self updateOutletView];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor THEMECOLOR];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.device.functionValuesMap.power) {
        self.navigationController.navigationBar.barTintColor = [UIColor THEMECOLOR];
    }else{
        self.navigationController.navigationBar.barTintColor = RGB(62, 62, 62);
    }
}

-(void)editDeviceAction{
    
    //edit device
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Options", @"Device", nil) message:NSLocalizedStringFromTable(@"Edit device", @"Device", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *updateNameAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"update device name", @"Device", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"update device name action");
        
        [self updateDeviceName];
    }];

    UIAlertAction *shareDeviceAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"share device", @"Device", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"share device action");
        //[self shareDevice];
        EHOMEShareViewController *shareVC = [[EHOMEShareViewController alloc] initWithNibName:@"EHOMEShareViewController" bundle:nil];
        shareVC.codeType = 2;
        shareVC.deviceModel = self.device;
        [self.navigationController pushViewController:shareVC animated:YES];
    }];
    
    UIAlertAction *removeDeviceAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"remove device", @"Device", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"remove device action");
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Remove Device", @"Device", nil) message:NSLocalizedStringFromTable(@"unsure remove", @"Device", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Remove", @"Profile", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self removeDevice];
        }];
        
        [alertView addAction:cancel];
        [alertView addAction:ok];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateNameAction];
    [alertController addAction:shareDeviceAction];
    [alertController addAction:removeDeviceAction];
    [alertController addAction:cancel];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    
    if (popover) {
        
        popover.sourceView = self.view;
        popover.sourceRect = CGRectMake(0, DEVICE_H, DEVICE_W, DEVICE_H);
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)updateDeviceName{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Device", nil) message:NSLocalizedStringFromTable(@"update device name", @"Device", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"device name";
        textField.text = self.device.device.name;
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        
        NSString *devicename = [alertController.textFields firstObject].text;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating device name", @"Device", nil) hideAfterDelay:10];
        
        [self.device updateDeviceName:devicename success:^(id responseObject) {
            NSLog(@"update device name success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"update devName success", @"Device", nil) hideAfterDelay:1.0];
            
        } failure:^(NSError *error) {
            NSLog(@"update device name failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)shareDevice{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Device", nil) message:NSLocalizedStringFromTable(@"share by email", @"Device", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"friends email", @"Device", nil);
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        
        NSString *email = [alertController.textFields firstObject].text;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Sharing", @"Device", nil) hideAfterDelay:10];
        
        [self.device shareDeviceByEmail:email success:^(id responseObject) {
            NSLog(@"share device success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Share success", @"Device", nil) hideAfterDelay:1.5];
            
        } failure:^(NSError *error) {
            NSLog(@"share device failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)removeDevice{
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Removing", @"Device", nil) hideAfterDelay:10];
    
    [self.device removeDevice:^(id responseObject) {
        
        NSLog(@"remove device success = %@", responseObject);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Remove device success", @"Device", nil) hideAfterDelay:1.0];

        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"remove device failed = %@", error);
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper showErrorDomain:error];
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)updateDeviceStatusAction:(id)sender {
    
    BOOL status = self.device.functionValuesMap.power;
    
    [self.device updateDeviceStatus:!status success:^(id responseObject) {

    } failure:^(NSError *error) {
        
    }];
    
    if(self.duration > 0){
        [self cancelCountdownTimer];
    }
}



-(void)updateOutletView{
    
    if (self.device.functionValuesMap.power) {
        [self.switchButton setTitle:NSLocalizedStringFromTable(@"Close", @"Device", nil) forState:UIControlStateNormal];
        self.switchButton.backgroundColor = RGB(62, 62, 62);
        self.stateLabel.text = NSLocalizedStringFromTable(@"Outlets is On", @"Device", nil);
        self.view.backgroundColor = [UIColor THEMECOLOR];
        self.navigationController.navigationBar.barTintColor = [UIColor THEMECOLOR];
    }else{
        [self.switchButton setTitle:NSLocalizedStringFromTable(@"Open", @"Device", nil) forState:UIControlStateNormal];
        self.switchButton.backgroundColor = [UIColor THEMECOLOR];
        self.stateLabel.text = NSLocalizedStringFromTable(@"Outlets is Off", @"Device", nil);
        self.view.backgroundColor = RGB(62, 62, 62);
        self.navigationController.navigationBar.barTintColor = RGB(62, 62, 62);
    }
}


- (IBAction)timerAction:(id)sender {
    
    EHOMETimerTableViewController *timerTVC = [[EHOMETimerTableViewController alloc] initWithNibName:@"EHOMETimerTableViewController" bundle:nil];
    timerTVC.device = self.device;
    [self.navigationController pushViewController:timerTVC animated:YES];
}

- (IBAction)timingCountdownAction:(id)sender {
    
    BOOL isOn = self.device.functionValuesMap.power;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Timing countdown", @"DeviceFunction", nil) message:NSLocalizedStringFromTable(@"Start countdown", @"DeviceFunction", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"duration", @"DeviceFunction", nil);
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        int duration = [[[alertController textFields] firstObject].text intValue];
        
        if (duration <= 0) {
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"enter duration", @"DeviceFunction", nil) hideAfterDelay:1.0];
        }else{
            
            [self.device addTimingCountdownWithIsPowerStrips:false clockId:0 Duration:duration status:!isOn success:^(id responseObject) {
                NSLog(@"add timing countdown success. res = %@", responseObject);
                
//                int duration = [[responseObject objectForKey:@"duration"] intValue];
//                [weakSelf countdownLabelWithDuration:duration];
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
        self.countdownLabel.text = NSLocalizedStringFromTable(@"No countdown", @"DeviceFunction", nil);
    }
}

-(void)cancelCountdownTimer{
    NSLog(@"取消插座的倒计时");
    
    BOOL status = self.device.functionValuesMap.power;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    long dTime = [[NSNumber numberWithDouble:time] longValue];
    
    NSDictionary *dic = @{
                          @"protocol":@(12),
                          @"timestamp":@(dTime),
                          @"data":@{
                                  @"clockId":@(self.setClockId),
                                  @"devId":self.device.device.devId,
                                  @"dps":@{
                                          @"1":@(!status),
                                          @"2":@(!status)
                                          },
                                  @"duration":@(self.setDuratuon),
                                  @"clockStatus":@(NO)
                                  }
                          };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableString *jsonStr = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSRange range = {0,jsonStr.length};
    [jsonStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,jsonStr.length};
    [jsonStr replaceOccurrencesOfString:@"/n" withString:@"" options:NSLiteralSearch range:range2];
    NSData *data2 = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *topicOut = [NSString stringWithFormat:@"d9lab/device/in/%@",self.device.device.devId];
    
    [[EHOMEMQTTClientManager shareInstance] publishAndWaitData:data2 onTopic:topicOut];
}

- (void)dealloc {
    [_timerLabel release];
    [_timingCountdownLabel release];
    [super dealloc];
}
@end
