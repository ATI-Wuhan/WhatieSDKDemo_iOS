//
//  EHOMEStreamLightViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/1.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEStreamLightViewController.h"
#import "EHOMEColorCollectionViewCell.h"
#import "EHColorslider.h"
#import "EHMySlider.h"
#import "EHOMEIntelligentSettingTableViewController.h"

static NSString *CellId = @"EHOMEColorCollectionViewCell";

@interface EHOMEStreamLightViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ColorSliderDelegate>
@property (retain, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (retain, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (retain, nonatomic) IBOutlet UILabel *modifyLabel;
@property (retain, nonatomic) IBOutlet UIImageView *streamerLightDark;
@property (retain, nonatomic) IBOutlet UIImageView *streamerLightBright;
@property (retain, nonatomic) IBOutlet UIImageView *fastImageView;
@property (retain, nonatomic) IBOutlet UIImageView *slowImageView;
@property (retain, nonatomic) IBOutlet EHMySlider *timeSlider;
@property (retain, nonatomic) IBOutlet EHMySlider *brightSlider;
@property (retain, nonatomic) IBOutlet UIView *selectedColorBackgroundView;
@property (retain, nonatomic) IBOutlet UICollectionView *ColorCollectionView;

- (IBAction)changeStreamLightDuration:(id)sender;
- (IBAction)changeStreamLightBrightness:(id)sender;

@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) NSMutableArray *colorsStrAry;
@property (nonatomic, strong) EHColorslider *colorslider;

@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) NSString *TimeStr;
@property (nonatomic, strong) NSString *BrightnessStr;
@end

@implementation EHOMEStreamLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add Scene", nil);
    self.frequencyLabel.text = NSLocalizedStringFromTable(@"Update Duration", @"DeviceFunction", nil);
    self.brightnessLabel.text = NSLocalizedStringFromTable(@"Update brightness", @"DeviceFunction", nil);
    self.modifyLabel.text = NSLocalizedString(@"Modify the color", nil);
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(DoneSetStreamLight)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [self InitCollectionView];
    
    self.colorslider=[[EHColorslider alloc] initWithFrame:CGRectMake(40, 160, DEVICE_W-80, 20)];
    self.colorslider.delegate = self;
    self.colorslider.sliderTag=0;
    [self.selectedColorBackgroundView addSubview:self.colorslider];
    
    if(self.isEditStreamLight){
        int LightMode = [[self.DeviceDps objectForKey:@"lightMode"] intValue];
        if(LightMode == 5){
            NSString *str1 = [self.DeviceDps objectForKey:@"rgb1"];
            NSString *str2 = [self.DeviceDps objectForKey:@"rgb2"];
            NSString *str3 = [self.DeviceDps objectForKey:@"rgb3"];
            NSString *str4 = [self.DeviceDps objectForKey:@"rgb4"];
            
            self.colorsStrAry = [NSMutableArray arrayWithArray:@[str1,str2,str3,str4]];
            self.BrightnessStr = [self.DeviceDps objectForKey:@"l"];
            self.TimeStr = [self.DeviceDps objectForKey:@"t"];
            
            self.colorsArray = [NSMutableArray arrayWithArray:@[[self getRGBcolorWith:str1],
                                                                [self getRGBcolorWith:str2],
                                                                [self getRGBcolorWith:str3],
                                                                [self getRGBcolorWith:str4]
                                                                ]];
            self.brightSlider.value = [[self.DeviceDps objectForKey:@"l"] intValue];
            self.timeSlider.value = [[self.DeviceDps objectForKey:@"t"] intValue];
            
        }else{
            self.colorsStrAry = [NSMutableArray arrayWithArray:@[@"255_0_0",@"255_255_0",@"0_255_0",@"0_0_255"]];
            self.BrightnessStr = @"10";
            self.TimeStr = @"1500";
            
            self.colorsArray = [NSMutableArray arrayWithArray:@[RGB(255, 0, 0),
                                                                RGB(255, 255, 0),
                                                                RGB(0, 255, 0),
                                                                RGB(0, 0, 255)]];
            self.brightSlider.value = 10;
            self.timeSlider.value = 1500;
        }
    }else{
        self.colorsStrAry = [NSMutableArray arrayWithArray:@[@"255_0_0",@"255_255_0",@"0_255_0",@"0_0_255"]];
        self.BrightnessStr = @"10";
        self.TimeStr = @"1500";
        
        self.colorsArray = [NSMutableArray arrayWithArray:@[RGB(255, 0, 0),
                                                            RGB(255, 255, 0),
                                                            RGB(0, 255, 0),
                                                            RGB(0, 0, 255)]];
        self.brightSlider.value = 10;
        self.timeSlider.value = 1500;
    }
    
    if (CurrentApp == Geek) {
        [self.timeSlider setThumbImage:[UIImage imageNamed:@"滑动条"] forState:UIControlStateNormal];
        [self.brightSlider setThumbImage:[UIImage imageNamed:@"滑动条"] forState:UIControlStateNormal];
        self.fastImageView.image = [UIImage imageNamed:@"汽车"];
        self.slowImageView.image = [UIImage imageNamed:@"自行车"];
        self.streamerLightDark.image = [UIImage imageNamed:@"小灯泡"];
        self.streamerLightBright.image = [UIImage imageNamed:@"小灯泡发光"];
    }else if (CurrentApp == Ozwi){
        [self.timeSlider setThumbImage:[UIImage imageNamed:@"Ozwi_滑动条"] forState:UIControlStateNormal];
        [self.brightSlider setThumbImage:[UIImage imageNamed:@"Ozwi_滑动条"] forState:UIControlStateNormal];
        self.fastImageView.image = [UIImage imageNamed:@"Ozwi_fast"];
        self.slowImageView.image = [UIImage imageNamed:@"Ozwi_slow"];
        self.streamerLightDark.image = [UIImage imageNamed:@"Ozwi_lightdark"];
        self.streamerLightBright.image = [UIImage imageNamed:@"Ozwi_lightbright"];
    }else{
        [self.timeSlider setThumbImage:[UIImage imageNamed:@"ehome_滑动条"] forState:UIControlStateNormal];
        [self.brightSlider setThumbImage:[UIImage imageNamed:@"ehome_滑动条"] forState:UIControlStateNormal];
        self.fastImageView.image = [UIImage imageNamed:@"fast"];
        self.slowImageView.image = [UIImage imageNamed:@"slow"];
        self.streamerLightDark.image = [UIImage imageNamed:@"lightdark"];
        self.streamerLightBright.image = [UIImage imageNamed:@"lightbright"];
    }
    
    self.timeSlider.minimumTrackTintColor = [UIColor THEMECOLOR];
    self.brightSlider.minimumTrackTintColor = [UIColor THEMECOLOR];
    
}

-(void)InitCollectionView{
    self.ColorCollectionView.delegate = self;
    self.ColorCollectionView.dataSource = self;
    
    [self.ColorCollectionView registerNib:[UINib nibWithNibName:@"EHOMEColorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellId];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEColorCollectionViewCell alloc] init];
    }
    
    cell.colorView.backgroundColor = self.colorsArray[indexPath.item];
    if(indexPath.row==self.indexpath.row){
        cell.editImageView.hidden=NO;
    }else{
        cell.editImageView.hidden=YES;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.indexpath = indexPath;
    [collectionView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.view.frame.size.width - 3)/4;
    
    return CGSizeMake(width, 80);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}


-(void)DoneSetStreamLight{
    NSLog(@"选择的流光灯的时间 = %@",self.TimeStr);
    NSLog(@"选择的流光灯的亮度 = %@",self.BrightnessStr);
    for(NSString *str in self.colorsStrAry){
        NSLog(@"选择的流光灯的rgb = %@",str);
    }
    
    if(self.isEditStreamLight){
        NSDictionary *DpsDic = @{@"dps":@{@"lightMode":@(5),
                                          @"rgb1":self.colorsStrAry[0],
                                          @"rgb2":self.colorsStrAry[1],
                                          @"rgb3":self.colorsStrAry[2],
                                          @"rgb4":self.colorsStrAry[3],
                                          @"t":self.TimeStr,
                                          @"l":self.BrightnessStr
                                          }
                                 };
        
        NSNotification *notification =[NSNotification notificationWithName:@"EditSceneStreamLightToIntelligent" object:nil userInfo:DpsDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"要编辑的彩灯 =%@",DpsDic);
    }else{
        EHOMEDeviceModel *model = [self.streamLight copy];
        
        model.sceneActionDic = @{@"lightMode":@(5),
                                 @"rgb1":self.colorsStrAry[0],
                                 @"rgb2":self.colorsStrAry[1],
                                 @"rgb3":self.colorsStrAry[2],
                                 @"rgb4":self.colorsStrAry[3],
                                 @"t":self.TimeStr,
                                 @"l":self.BrightnessStr
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
        NSNotification *notification =[NSNotification notificationWithName:@"AddSceneStreamLightToIntelligent" object:nil userInfo:Dic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"要传的流光灯 =%@",Dic);
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[EHOMEIntelligentSettingTableViewController class]]) {
            EHOMEIntelligentSettingTableViewController *setController =(EHOMEIntelligentSettingTableViewController *)controller;
            [self.navigationController popToViewController:setController animated:YES];
        }
    }
}

-(void)changeColorSliderValueWith:(UISlider *)slider andSliderTag:(int)tag{
    int colorSliderValue=slider.value;
    NSString *colorStr=[self getRgbValueWith:colorSliderValue];
    [self.colorsStrAry replaceObjectAtIndex:self.indexpath.item withObject:colorStr];
    
    NSArray *array = [colorStr componentsSeparatedByString:@"_"];
    int red=[array[0] intValue];
    int green=[array[1] intValue];
    int blue=[array[2] intValue];
    UIColor *color=RGB(red, green, blue);
    [self.colorsArray replaceObjectAtIndex:self.indexpath.item withObject:color];
    [self.ColorCollectionView reloadData];
    
    NSLog(@"滑动了第%drgb = %@",self.indexpath.row+1,colorStr);
    
}

-(UIColor *)getRGBcolorWith:(NSString *)rgbStr{
    NSArray *colors = [rgbStr componentsSeparatedByString:@"_"];
    return RGB([colors[0] intValue], [colors[1] intValue], [colors[2] intValue]);
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
    [_ColorCollectionView release];
    [_timeSlider release];
    [_brightSlider release];
    [_selectedColorBackgroundView release];
    [_frequencyLabel release];
    [_brightnessLabel release];
    [_modifyLabel release];
    [_slowImageView release];
    [_fastImageView release];
    [_streamerLightDark release];
    [_streamerLightBright release];
    [_fastImageView release];
    [_slowImageView release];
    [super dealloc];
}

- (IBAction)changeStreamLightDuration:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int duration = slider.value;
    self.TimeStr = [NSString stringWithFormat:@"%d",duration];
    NSLog(@"change stream_duration value = %f", slider.value);
}

- (IBAction)changeStreamLightBrightness:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int bright = slider.value;
    self.BrightnessStr = [NSString stringWithFormat:@"%d",bright];
    NSLog(@"change stream_brightness value = %f", slider.value);
}

@end
