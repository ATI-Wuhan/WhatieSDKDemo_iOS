//
//  EHOMESetWhiteLightViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/30.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESetWhiteLightViewController.h"
#import "EHMySlider.h"
#import "EHOMEIntelligentSettingTableViewController.h"

@interface EHOMESetWhiteLightViewController ()
@property (retain, nonatomic) IBOutlet EHMySlider *whiteLightBrightnessSlider;
- (IBAction)AdjustBrightAndDark:(id)sender;

@property (nonatomic, strong) NSString *BrightnessString;
@end

@implementation EHOMESetWhiteLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add Scene", nil);
    
    self.BrightnessString = @"10";
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(DoneSetBrightness)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    if (CurrentApp == Geek) {
        [self.whiteLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"滑动条"] forState:UIControlStateNormal];
    }else if (CurrentApp == Ozwi){
        [self.whiteLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"Ozwi_滑动条"] forState:UIControlStateNormal];
    }else{
        [self.whiteLightBrightnessSlider setThumbImage:[UIImage imageNamed:@"ehome_滑动条"] forState:UIControlStateNormal];
    }
    
    self.whiteLightBrightnessSlider.minimumTrackTintColor = [UIColor THEMECOLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)AdjustBrightAndDark:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int brightness = slider.value;
    self.BrightnessString = [NSString stringWithFormat:@"%d",brightness];
    NSLog(@"change brightness value = %f", slider.value);
}
- (void)dealloc {
    [_whiteLightBrightnessSlider release];
    [super dealloc];
}
@end
