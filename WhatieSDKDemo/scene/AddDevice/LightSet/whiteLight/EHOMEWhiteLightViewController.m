//
//  EHOMEWhiteLightViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/3.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEWhiteLightViewController.h"
#import "EHMySlider.h"
#import "EHOMEIntelligentSettingTableViewController.h"

@interface EHOMEWhiteLightViewController ()
@property (retain, nonatomic) IBOutlet UILabel *adjustBrightnessLabel;
@property (retain, nonatomic) IBOutlet EHMySlider *whiteLightBrightnessSlider;
@property (retain, nonatomic) IBOutlet UIImageView *LightDarkImage;
@property (retain, nonatomic) IBOutlet UIImageView *LightBrightImage;
- (IBAction)AdjustBrightAndDark:(id)sender;

@property (nonatomic, strong) NSString *BrightnessString;
@end

@implementation EHOMEWhiteLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add Scene", nil);
    self.adjustBrightnessLabel.text = NSLocalizedStringFromTable(@"Update brightness", @"DeviceFunction", nil);
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(DoneSetBrightness)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    if (CurrentApp == Geek) {
        [self.whiteLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"滑动条"] forState:UIControlStateNormal];
        self.LightDarkImage.image = [UIImage imageNamed:@"小灯泡"];
        self.LightBrightImage.image = [UIImage imageNamed:@"小灯泡发光"];
    }else if (CurrentApp == Ozwi){
        [self.whiteLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"Ozwi_滑动条"] forState:UIControlStateNormal];
        self.LightDarkImage.image = [UIImage imageNamed:@"Ozwi_lightdark"];
        self.LightBrightImage.image = [UIImage imageNamed:@"Ozwi_lightbright"];
    }else{
        [self.whiteLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"ehome_滑动条"] forState:UIControlStateNormal];
        self.LightDarkImage.image = [UIImage imageNamed:@"lightdark"];
        self.LightBrightImage.image = [UIImage imageNamed:@"lightbright"];
    }
    
    self.whiteLightBrightnessSlider.minimumTrackTintColor = [UIColor THEMECOLOR];
    
    if(self.isEditWhiteLight){
        
        int LightMode = [[self.deviceDps objectForKey:@"lightMode"] intValue];
        if(LightMode == 1){
            self.BrightnessString = [self.deviceDps objectForKey:@"l"];
            self.whiteLightBrightnessSlider.value = [[self.deviceDps objectForKey:@"l"] intValue];
        }else{
            self.BrightnessString = @"10";
            self.whiteLightBrightnessSlider.value = 10;
        }
    }else{
        self.BrightnessString = @"10";
        self.whiteLightBrightnessSlider.value = 10;
        
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)DoneSetBrightness{
    NSLog(@"日光灯亮度 = %@",self.BrightnessString);
    if(self.isEditWhiteLight){
        NSDictionary *DpsDic = @{@"dps":@{@"lightMode":@(1),
                                          @"l": self.BrightnessString
                                          }
                                 };
        
        NSNotification *notification =[NSNotification notificationWithName:@"EditSceneWhiteLightToIntelligent" object:nil userInfo:DpsDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"要编辑的日光灯 =%@",DpsDic);
    }else{
        NSLog(@"奇怪的日光灯");
        EHOMEDeviceModel *model = [self.whiteLight copy];
        
        model.sceneActionDic = @{@"lightMode":@(1),
                                 @"l": self.BrightnessString
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
        NSNotification *notification =[NSNotification notificationWithName:@"AddSceneWhiteLightToIntelligent" object:nil userInfo:Dic];
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
    [_whiteLightBrightnessSlider release];
    [_adjustBrightnessLabel release];
    [_LightDarkImage release];
    [_LightBrightImage release];
    [super dealloc];
}
- (IBAction)AdjustBrightAndDark:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int brightness = slider.value;
    self.BrightnessString = [NSString stringWithFormat:@"%d",brightness];
    NSLog(@"change brightness value = %f", slider.value);
}
@end
