//
//  EHOMESetRgbLightViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/31.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESetRgbLightViewController.h"
#import "EHMySlider.h"
#import "EHColorslider.h"
#import "EHOMEIntelligentSettingTableViewController.h"

@interface EHOMESetRgbLightViewController ()<ColorSliderDelegate>
@property (retain, nonatomic) IBOutlet UILabel *adjustColorLabel;
@property (retain, nonatomic) IBOutlet UILabel *adjustBrightLabel;

@property (retain, nonatomic) IBOutlet EHMySlider *rgbLightBrightnessSlider;
@property (retain, nonatomic) IBOutlet UIImageView *rgbLightDark;
@property (retain, nonatomic) IBOutlet UIImageView *rgbLightBright;

- (IBAction)changeRgbBrightnessValue:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *colorBackgroundView;

@property(nonatomic,strong)EHColorslider *colorsld;
@property (nonatomic, strong) NSString *BrightnessStr;
@property (nonatomic, strong) NSString *colorStr;
@end

@implementation EHOMESetRgbLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add Scene", nil);
    self.adjustColorLabel.text = NSLocalizedStringFromTable(@"Update Color", @"DeviceFunction", nil);
    self.adjustBrightLabel.text = NSLocalizedStringFromTable(@"Update brightness", @"DeviceFunction", nil);
    
    self.colorsld=[[EHColorslider alloc] initWithFrame:CGRectMake(40, 60, DEVICE_W-80, 20)];
    self.colorsld.delegate = self;
    self.colorsld.sliderTag=0;
    [self.colorBackgroundView addSubview:self.colorsld];
    if(self.isEditRgbLight){
        int LightMode = [[self.devicedps objectForKey:@"lightMode"] intValue];
        if(LightMode == 2){
            self.colorStr= [self.devicedps objectForKey:@"rgb"];
            self.BrightnessStr = [self.devicedps objectForKey:@"l"];
            
            NSArray *colors = [[self.devicedps objectForKey:@"rgb"] componentsSeparatedByString:@"_"];
            self.colorsld.colorSlider.value = [self getLocationValue:colors];
            self.rgbLightBrightnessSlider.value = [[self.devicedps objectForKey:@"l"] intValue];
            
        }else{
            self.colorStr=[self getRgbValueWith:0];
            self.BrightnessStr = @"10";
            self.colorsld.colorSlider.value = 0;
            self.rgbLightBrightnessSlider.value = 10;
        }
    }else{
        self.colorStr=[self getRgbValueWith:0];
        self.BrightnessStr = @"10";
        self.colorsld.colorSlider.value = 0;
        self.rgbLightBrightnessSlider.value = 10;
    }
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(DoneSetRGBLight)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    if (CurrentApp == Geek) {
        [self.rgbLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"滑动条"] forState:UIControlStateNormal];
        self.rgbLightDark.image = [UIImage imageNamed:@"小灯泡"];
        self.rgbLightBright.image = [UIImage imageNamed:@"小灯泡发光"];
    }else if (CurrentApp == Ozwi){
        [self.rgbLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"Ozwi_滑动条"] forState:UIControlStateNormal];
        self.rgbLightDark.image = [UIImage imageNamed:@"Ozwi_lightdark"];
        self.rgbLightBright.image = [UIImage imageNamed:@"Ozwi_lightbright"];
    }else{
        [self.rgbLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"ehome_滑动条"] forState:UIControlStateNormal];
        self.rgbLightDark.image = [UIImage imageNamed:@"lightdark"];
        self.rgbLightBright.image = [UIImage imageNamed:@"lightbright"];
    }
    
    self.rgbLightBrightnessSlider.minimumTrackTintColor = [UIColor THEMECOLOR];
    
}

-(void)changeColorSliderValueWith:(UISlider *)slider andSliderTag:(int)tag{
    int colorSliderValue=slider.value;
    self.colorStr=[self getRgbValueWith:colorSliderValue];
    NSLog(@"滑动了彩灯的rgb = %@",self.colorStr);
    
}

-(NSString *)getRgbValueWith:(int)value{
    int Rvalue;
    int Gvalue;
    int Bvalue;
    if(value<256){
        Rvalue=255;
        Gvalue=value;
        Bvalue=0;
    }else if (value>255 && value<512){
        Rvalue=511-value;
        Gvalue=255;
        Bvalue=0;
    }else if (value>511 && value<768){
        Rvalue=0;
        Gvalue=255;
        Bvalue=value-512;
    }else if (value>767 && value<1024){
        Rvalue=0;
        Gvalue=1023-value;
        Bvalue=255;
    }else if (value>1023 && value<1280){
        Rvalue=value-1024;
        Gvalue=0;
        Bvalue=255;
    }else {
        Rvalue=255;
        Gvalue=0;
        Bvalue=1535-value;
    }
    
    NSString *colorRGBstr=[NSString stringWithFormat:@"%d_%d_%d",Rvalue,Gvalue,Bvalue];
    return colorRGBstr;
}

-(int)getLocationValue:(NSArray *)array{
    int locationValue;
    int r_color = [array[0] intValue];
    int g_color = [array[1] intValue];
    int b_color = [array[2] intValue];
    if(r_color == 255 && b_color == 0){
        locationValue = g_color;
    }else if (g_color == 255 && b_color == 0){
        locationValue = 511-r_color;
    }else if (r_color == 0 && g_color == 255){
        locationValue = 512+b_color;
    }else if (r_color == 0 && b_color == 255){
        locationValue = 1023-g_color;
    }else if (g_color == 0 && b_color == 255){
        locationValue = 1024+r_color;
    }else{
        locationValue = 1535-b_color;
    }
    return locationValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DoneSetRGBLight{
    NSLog(@"选择的彩灯rgb = %@",self.colorStr);
    if(self.isEditRgbLight){
        NSDictionary *DpsDic = @{@"dps":@{@"lightMode":@(2),
                                          @"rgb":self.colorStr,
                                          @"l": self.BrightnessStr
                                          }
                                 };
        
        NSNotification *notification =[NSNotification notificationWithName:@"EditSceneRgbLightToIntelligent" object:nil userInfo:DpsDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"要编辑的彩灯 =%@",DpsDic);
    }else{
        EHOMEDeviceModel *model = [self.rgbLight copy];
        
        model.sceneActionDic = @{@"lightMode":@(2),
                                 @"rgb":self.colorStr,
                                 @"l": self.BrightnessStr
                                 };
        
        model.sceneDeviceId = -1;
        
        NSDictionary *Dic = @{@"deviceInfo":@{@"dps":model.sceneActionDic,
                                              @"deviceId":@(model.device.id),
                                              @"deviceName":model.device.name,
                                              @"deviceRoom":model.roomName,
                                              @"deviceImage":model.device.product.picture.path,
                                              @"deviceStatus":model.device.status,
                                              @"sceneDeviceId":@(model.sceneDeviceId)
                                              }
                              };
        NSNotification *notification =[NSNotification notificationWithName:@"AddSceneRGBLightToIntelligent" object:nil userInfo:Dic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"要传的日光灯 =%@",Dic);
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[EHOMEIntelligentSettingTableViewController class]]) {
            EHOMEIntelligentSettingTableViewController *setController =(EHOMEIntelligentSettingTableViewController *)controller;
            [self.navigationController popToViewController:setController animated:YES];
        }
    }
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
    [_rgbLightBrightnessSlider release];
    [_colorBackgroundView release];
    [_adjustColorLabel release];
    [_adjustBrightLabel release];
    [_rgbLightDark release];
    [_rgbLightBright release];
    [super dealloc];
}
- (IBAction)changeRgbBrightnessValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int brightness = slider.value;
    self.BrightnessStr = [NSString stringWithFormat:@"%d",brightness];
    NSLog(@"change rgb_brightness value = %f", slider.value);
}
@end
