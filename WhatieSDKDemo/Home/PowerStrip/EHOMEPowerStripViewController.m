//
//  EHOMEPowerStripViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/10/9.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEPowerStripViewController.h"
#import "EHOMETimerTableViewController.h"

@interface EHOMEPowerStripViewController ()
@property (nonatomic, assign) int duration1;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, assign) int duration2;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, assign) int duration3;
@property (nonatomic, strong) NSTimer *timer3;
@property (retain, nonatomic) IBOutlet UIButton *masterSwitchBtn;
@property (retain, nonatomic) IBOutlet UIView *MasterLight;
@property (retain, nonatomic) IBOutlet UIImageView *stripOne;
@property (retain, nonatomic) IBOutlet UIImageView *stripTwo;
@property (retain, nonatomic) IBOutlet UIImageView *stripThree;
@property (retain, nonatomic) IBOutlet UIButton *switchOne;
@property (retain, nonatomic) IBOutlet UILabel *countdownOne;
@property (retain, nonatomic) IBOutlet UIButton *switchTwo;
@property (retain, nonatomic) IBOutlet UILabel *countdownTwo;
@property (retain, nonatomic) IBOutlet UIButton *switchThree;
@property (retain, nonatomic) IBOutlet UILabel *countdownThree;

- (IBAction)pressMasterSwitchAction:(id)sender;
- (IBAction)pressSwitchOneAction:(id)sender;
- (IBAction)pressSwitchTwoAction:(id)sender;
- (IBAction)pressSwitchThreeAction:(id)sender;
- (IBAction)pressCountdownOneAction:(id)sender;
- (IBAction)pressTimerOneAction:(id)sender;
- (IBAction)pressCountdownTwoAction:(id)sender;
- (IBAction)pressTimerTwoAction:(id)sender;
- (IBAction)pressCountdownThreeAction:(id)sender;
- (IBAction)pressTimerThreeAction:(id)sender;
@end

@implementation EHOMEPowerStripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedStringFromTable(@"PowerStrips", @"Device", nil);
    
    self.MasterLight.layer.masksToBounds = YES;
    self.MasterLight.layer.cornerRadius = 5.0;
    
    [self updateStripView];
    
    [[EHOMEMQTTClientManager shareInstance] setMqttBlock:^(NSString *topic, NSData *data) {
        NSDictionary *MQTTMessage = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"接收到倒计时mqtt消息 = %@",MQTTMessage);
        if([[MQTTMessage objectForKey:@"protocol"] intValue] == 13){
            if([[[MQTTMessage objectForKey:@"data"] objectForKey:@"devId"] isEqualToString:self.stripDevice.device.devId]){
                
                if([[[MQTTMessage objectForKey:@"data"] objectForKey:@"executionType"] intValue] == 2){
                    int Duration = [[[MQTTMessage objectForKey:@"data"] objectForKey:@"duration"] intValue];
                    if([[[MQTTMessage objectForKey:@"data"] objectForKey:@"clockId"] intValue] == 0){
                        self.duration1 = Duration;
                        [self countdownLabelWithType:0 Duration:self.duration1];
                    }else if ([[[MQTTMessage objectForKey:@"data"] objectForKey:@"clockId"] intValue] == 1){
                        self.duration2 = Duration;
                        [self countdownLabelWithType:1 Duration:self.duration2];
                    }else if ([[[MQTTMessage objectForKey:@"data"] objectForKey:@"clockId"] intValue] == 2){
                        self.duration3 = Duration;
                        [self countdownLabelWithType:2 Duration:self.duration3];
                    }
                }else if ([[[MQTTMessage objectForKey:@"data"] objectForKey:@"executionType"] intValue] == 0){
                    if([[[MQTTMessage objectForKey:@"data"] objectForKey:@"clockId"] intValue] == 0){
                        [self countdownLabelWithType:0 Duration:0];
                    }else if ([[[MQTTMessage objectForKey:@"data"] objectForKey:@"clockId"] intValue] == 1){
                        [self countdownLabelWithType:1 Duration:0];
                    }else if ([[[MQTTMessage objectForKey:@"data"] objectForKey:@"clockId"] intValue] == 2){
                        [self countdownLabelWithType:2 Duration:0];
                    }
                }
            }
        }
    }];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationDeviceArrayChanged object:nil];
    //注册分享设备的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationSharedDeviceArrayChanged object:nil];

    [self getcountdownTimers];
    
}

-(void)getcountdownTimers{
    [self.stripDevice getTimingCountdown:^(id responseObject) {
        NSLog(@"get timing countdown success. res = %@", responseObject);
        
        for(EHOMETimer *timer in responseObject){
            if(timer.durationTime > 0){
                if(timer.deviceClock.clockId == 0){
                    NSLog(@"倒计时模式1 = %d",timer.deviceClock.stripdps.stripsMode);
                    self.duration1 = timer.durationTime;
                    [self countdownLabelWithType:0 Duration:self.duration1];
                }else if (timer.deviceClock.clockId == 1){
                    NSLog(@"倒计时模式2 = %d",timer.deviceClock.stripdps.stripsMode);
                    self.duration2 = timer.durationTime;
                    [self countdownLabelWithType:1 Duration:self.duration2];
                }else if (timer.deviceClock.clockId == 2){
                    NSLog(@"倒计时模式3 = %d",timer.deviceClock.stripdps.stripsMode);
                    self.duration3 = timer.durationTime;
                    [self countdownLabelWithType:2 Duration:self.duration3];
                }
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)reloadData{
    NSLog(@"插座状态变化了hhh");
    [self updateStripView];
}

-(void)updateStripView{
    if([self.stripDevice.functionValuesMap.stripsPower isEqualToString:@"111"]){
        [self.masterSwitchBtn setImage:[UIImage imageNamed:@"masterSwitch_close"] forState:UIControlStateNormal];
        self.MasterLight.backgroundColor = RGB(0, 207, 104);
    }else{
        //总开关
        [self.masterSwitchBtn setImage:[UIImage imageNamed:@"masterSwitch_open"] forState:UIControlStateNormal];
        self.MasterLight.backgroundColor = RGB(216, 44, 21);
        
    }
    
    NSString *lightString = self.stripDevice.functionValuesMap.stripsPower;
    NSLog(@"变化后的情况 = %@",lightString);
    NSMutableArray *tempArray1 = [NSMutableArray array];
    NSMutableArray *tempArray2 = [NSMutableArray array];
    
    for (int i = 0; i<lightString.length; i++) {
        int LightDps = [[lightString substringWithRange:NSMakeRange(i, 1)] intValue];
        if(LightDps == 0){
            [tempArray1 addObject:[UIImage imageNamed:@"strip_close"]];
            [tempArray2 addObject:[UIImage imageNamed:@"openStrip"]];
        }else{
            [tempArray1 addObject:[UIImage imageNamed:@"strip_open"]];
            [tempArray2 addObject:[UIImage imageNamed:@"closeStrip"]];
        }
    }
    self.stripOne.image = tempArray1[0];
    self.stripTwo.image = tempArray1[1];
    self.stripThree.image = tempArray1[2];
    
    [self.switchOne setImage:tempArray2[0] forState:UIControlStateNormal];
    [self.switchTwo setImage:tempArray2[1] forState:UIControlStateNormal];
    [self.switchThree setImage:tempArray2[2] forState:UIControlStateNormal];
}

-(void)countdownLabelWithType:(int)type Duration:(int)duration{
    
    if(type == 0){
        [self.timer1 invalidate];
        self.timer1 = nil;
        
        self.duration1 = duration;
        
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle:) userInfo:@(type) repeats:YES];
    }else if (type == 1){
        [self.timer2 invalidate];
        self.timer2 = nil;
        
        self.duration2 = duration;
        
        self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle:) userInfo:@(type) repeats:YES];
    }else if (type == 2){
        [self.timer3 invalidate];
        self.timer3 = nil;
        
        self.duration3 = duration;
        
        self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle:) userInfo:@(type) repeats:YES];
    }
}

-(void)timeHeadle:(NSTimer *)timer{
    
    int type = [[timer userInfo] intValue];
    if(type == 0){
        self.duration1 --;
        
        if (self.duration1 > 0) {
            self.countdownOne.text = [NSString stringWithFormat:@"%@", [self getMMSSFromSS:self.duration1]];
        }else{
            self.countdownOne.text = @"00:00:00";
        }
    }else if (type == 1){
        self.duration2 --;
        
        if (self.duration2 > 0) {
            self.countdownTwo.text = [NSString stringWithFormat:@"%@", [self getMMSSFromSS:self.duration2]];
        }else{
            self.countdownTwo.text = @"00:00:00";
        }
    }else if (type == 2){
        self.duration3 --;
        
        if (self.duration3 > 0) {
            self.countdownThree.text = [NSString stringWithFormat:@"%@", [self getMMSSFromSS:self.duration3]];
        }else{
            self.countdownThree.text = @"00:00:00";
        }
    }
    
}

-(NSString *)getMMSSFromSS:(int)totalTime{
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",totalTime/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(totalTime%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",totalTime%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
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
    [_masterSwitchBtn release];
    [_MasterLight release];
    [_stripOne release];
    [_stripTwo release];
    [_stripThree release];
    [_switchOne release];
    [_countdownOne release];
    [_switchTwo release];
    [_countdownTwo release];
    [_switchThree release];
    [_countdownThree release];
    [super dealloc];
}
- (IBAction)pressMasterSwitchAction:(id)sender {
    BOOL status;
    if([self.stripDevice.functionValuesMap.stripsPower isEqualToString:@"111"]){
        status = true;
    }else{
        status = false;
    }
    
    [self.stripDevice updateDeviceStatus:!status success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    if(self.duration1 > 0){
        [self cancelCountdownWithMode:1];
    }
    if(self.duration2 > 0){
        [self cancelCountdownWithMode:2];
    }
    if(self.duration3 > 0){
        [self cancelCountdownWithMode:3];
    }
}

- (IBAction)pressSwitchOneAction:(id)sender {
    NSLog(@"1的情况 = %d",[[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(0, 1)] intValue]);
    BOOL status = ([[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(0, 1)] intValue] == 1) ? true:false;
    [self.stripDevice updateStripStatusMode:1 Status:!status success:^(id responseObject) {
        
    } failure:^(NSError *error) {

    }];
    
    if(self.duration1 > 0){
        [self cancelCountdownWithMode:1];
    }
}

- (IBAction)pressSwitchTwoAction:(id)sender {
    NSLog(@"2的情况 = %d",[[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(1, 1)] intValue]);
    BOOL status = ([[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(1, 1)] intValue] == 1) ? true:false;
    [self.stripDevice updateStripStatusMode:2 Status:!status success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    if(self.duration2 > 0){
        [self cancelCountdownWithMode:2];
    }
}

- (IBAction)pressSwitchThreeAction:(id)sender {
    NSLog(@"3的情况 = %d",[[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(2, 1)] intValue]);
    BOOL status = ([[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(2, 1)] intValue] == 1) ? true:false;
    [self.stripDevice updateStripStatusMode:3 Status:!status success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    if(self.duration3 > 0){
        [self cancelCountdownWithMode:3];
    }
}

- (IBAction)pressCountdownOneAction:(id)sender {
    [self popSetCountdownViewWithType:0];
}

- (IBAction)pressTimerOneAction:(id)sender {
    EHOMETimerTableViewController *timerTVC = [[EHOMETimerTableViewController alloc] initWithNibName:@"EHOMETimerTableViewController" bundle:nil];
    timerTVC.device = self.stripDevice;
    timerTVC.stripTag = 1;
    [self.navigationController pushViewController:timerTVC animated:YES];
}

- (IBAction)pressCountdownTwoAction:(id)sender {
    [self popSetCountdownViewWithType:1];
}

- (IBAction)pressTimerTwoAction:(id)sender {
    EHOMETimerTableViewController *timerTVC = [[EHOMETimerTableViewController alloc] initWithNibName:@"EHOMETimerTableViewController" bundle:nil];
    timerTVC.device = self.stripDevice;
    timerTVC.stripTag = 2;
    [self.navigationController pushViewController:timerTVC animated:YES];
}

- (IBAction)pressCountdownThreeAction:(id)sender {
    [self popSetCountdownViewWithType:2];
}

- (IBAction)pressTimerThreeAction:(id)sender {
    EHOMETimerTableViewController *timerTVC = [[EHOMETimerTableViewController alloc] initWithNibName:@"EHOMETimerTableViewController" bundle:nil];
    timerTVC.device = self.stripDevice;
    timerTVC.stripTag = 3;
    [self.navigationController pushViewController:timerTVC animated:YES];
}

-(void)popSetCountdownViewWithType:(int)type{
    BOOL isOn = false;
    if(type == 0){
        isOn = ([[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(0, 1)] intValue] == 1) ? true:false;
    }else if (type == 1){
        isOn = ([[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(1, 1)] intValue] == 1) ? true:false;
    }else if (type == 2){
        isOn = ([[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(2, 1)] intValue] == 1) ? true:false;
    }
    
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
        
            [self.stripDevice addTimingCountdownWithIsPowerStrips:true clockId:type Duration:duration status:!isOn success:^(id responseObject) {
                NSLog(@"add timing countdown success. res = %@", responseObject);
//                int duration = [[responseObject objectForKey:@"duration"] intValue];
//                [weakSelf countdownLabelWithType:type Duration:duration];
            } failure:^(NSError *error) {
                NSLog(@"add timing countdown failed. error = %@", error);
            }];
        }
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)cancelCountdownWithMode:(int)mode{
    NSLog(@"取消的模式 = %d",mode);
    
    BOOL status = ([[self.stripDevice.functionValuesMap.stripsPower substringWithRange:NSMakeRange(mode-1, 1)] intValue] == 1) ? true:false;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    long dTime = [[NSNumber numberWithDouble:time] longValue];
    
    NSDictionary *dic = @{
                          @"protocol":@(12),
                          @"timestamp":@(dTime),
                          @"data":@{
                                  @"clockId":@(mode-1),
                                  @"devId":self.stripDevice.device.devId,
                                  @"dps":@{
                                          @"stripsMode":@(mode),
                                          @"stripsStatus":@(!status)
                                          },
                                  @"duration":@(0),
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
    
    NSString *topicOut = [NSString stringWithFormat:@"d9lab/device/in/%@",self.stripDevice.device.devId];
    
    [[EHOMEMQTTClientManager shareInstance] publishAndWaitData:data2 onTopic:topicOut];
}
@end
