//
//  EHOMERGBLightViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

static NSString *cellId = @"EHOMELightMenuCollectionViewCell";

#import "EHOMERGBLightViewController.h"

#import "EHOMEStreamSettingViewController.h"

#import "EHOMELightMenuCollectionViewCell.h"

#import "EHOMEColorSlider.h"

@interface EHOMERGBLightViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;







@property (nonatomic, strong) UIButton *LightButton;
//white light
@property (nonatomic, strong) UISlider *brightnessSlider;
//RGB light
@property (nonatomic, strong) EHOMEColorSlider *slider;
@property (nonatomic, strong) UISlider *RGBBrightnessSlider;
//RGB light
@property (nonatomic, strong) UISlider *streamDurationSlider;
@property (nonatomic, strong) UISlider *StreamBrightnessSlider;


//datasource
@property (nonatomic, assign) NSInteger currentIndexPathItem;

@end

@implementation EHOMERGBLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Light";
    
    self.currentIndexPathItem = 0;
    
    
    [self initCollectionView];
    [self initScrollView];
    
    
    [self.menuCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
    
    [self updateCloseButton];
    
    
    
    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    

//    
//    
//    UILabel *brightnessLabel = [[UILabel alloc] init];
//    [self.view addSubview:brightnessLabel];
//    
//    brightnessLabel.text = @"Brightness";
//    
//    [brightnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.slider);
//        make.top.mas_equalTo(self.slider.mas_bottom).mas_offset(80);
//        make.height.mas_equalTo(40);
//    }];
//    
//    


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = THEMECOLOR;
}

-(void)initCollectionView{
    
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.dataSource = self;
    
    self.menuCollectionView.backgroundColor = GREYCOLOR;
    
    
    [self.menuCollectionView registerNib:[UINib nibWithNibName:@"EHOMELightMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellId];
}

-(void)initScrollView{
    
    self.menuScrollView.backgroundColor = GREYCOLOR;
    
    
    
    CGFloat width = self.menuScrollView.frame.size.width;
    CGFloat height = self.menuScrollView.frame.size.height;
    
    self.menuScrollView.contentSize = CGSizeMake(width * 3, height);
    
    UIView *whiteLightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    whiteLightView.backgroundColor = GREYCOLOR;
    [self.menuScrollView addSubview:whiteLightView];

    UIView *RGBLightView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    RGBLightView.backgroundColor = GREYCOLOR;
    [self.menuScrollView addSubview:RGBLightView];

    UIView *StreamLightView = [[UIView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
    StreamLightView.backgroundColor = GREYCOLOR;
    [self.menuScrollView addSubview:StreamLightView];

    
    
    [self initWhiteLightView:whiteLightView];
    [self initRGBLightView:RGBLightView];
    [self initStreamLightView:StreamLightView];
    
    self.LightButton = [[UIButton alloc] init];
    self.LightButton.layer.masksToBounds = YES;
    self.LightButton.layer.cornerRadius = 49.0;
    self.LightButton.backgroundColor = THEMECOLOR;
    [self.LightButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.LightButton addTarget:self action:@selector(updateLightStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LightButton];
    [self.LightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(98);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-30);
        make.centerX.mas_equalTo(self.view);
    }];
}

-(void)initWhiteLightView:(UIView *)whiteView{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(whiteView);
        make.top.mas_equalTo(whiteView).mas_offset(15);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *brightnessLabel = [[UILabel alloc] init];
    brightnessLabel.text = @"Update brightness";
    brightnessLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView addSubview:brightnessLabel];
    
    [brightnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(bgView).mas_offset(15);
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightdark"]];
    [bgView addSubview:leftImageView];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(18);
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(bgView);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightbright"]];
    [bgView addSubview:rightImageView];
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(21);
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(bgView);
    }];
    
    //brightness
    self.brightnessSlider = [[UISlider alloc] init];
    self.brightnessSlider.maximumValue = 100;
    self.brightnessSlider.minimumValue = 1;
    self.brightnessSlider.minimumTrackTintColor = THEMECOLOR;
    self.brightnessSlider.value = [self.device.functionValuesMap.brightness floatValue];
    [bgView addSubview:self.brightnessSlider];

    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(rightImageView.mas_left).mas_offset(-15);
        make.centerY.mas_equalTo(bgView);
        make.height.mas_equalTo(30);
    }];
    [self.brightnessSlider addTarget:self action:@selector(brightnessSliderValueChange:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)initRGBLightView:(UIView *)RGBView{
    
    
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = [UIColor whiteColor];
    [RGBView addSubview:bgView1];
    
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(RGBView);
        make.top.mas_equalTo(RGBView).mas_offset(15);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *rgbLabel = [[UILabel alloc] init];
    rgbLabel.text = @"Update Color";
    rgbLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView1 addSubview:rgbLabel];
    
    [rgbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(bgView1).mas_offset(15);
    }];
    
    
    _slider=[[EHOMEColorSlider alloc] initWithFrame:CGRectMake(15, 60,[UIScreen mainScreen].bounds.size.width - 30, 30)];
    _slider.value=0.5;
    [_slider addTarget:self action:@selector(rgbColorSliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:_slider];
    
    
    ///bg2
    UIView *bgView2 = [[UIView alloc] init];
    bgView2.backgroundColor = [UIColor whiteColor];
    [RGBView addSubview:bgView2];

    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(bgView1);
        make.top.mas_equalTo(bgView1.mas_bottom).mas_offset(15);
    }];

    UILabel *brightnessLabel = [[UILabel alloc] init];
    brightnessLabel.text = @"Update brightness";
    brightnessLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView2 addSubview:brightnessLabel];

    [brightnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(bgView2).mas_offset(15);
    }];

    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightdark"]];
    [bgView2 addSubview:leftImageView];

    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(18);
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(bgView2);
    }];

    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightbright"]];
    [bgView2 addSubview:rightImageView];

    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(21);
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(bgView2);
    }];

    //brightness
    self.RGBBrightnessSlider = [[UISlider alloc] init];
    self.RGBBrightnessSlider.maximumValue = 100;
    self.RGBBrightnessSlider.minimumValue = 1;
    self.RGBBrightnessSlider.minimumTrackTintColor = THEMECOLOR;
    self.RGBBrightnessSlider.value = [self.device.functionValuesMap.brightness floatValue];
    [bgView2 addSubview:self.RGBBrightnessSlider];

    [self.RGBBrightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(rightImageView.mas_left).mas_offset(-15);
        make.centerY.mas_equalTo(bgView2);
        make.height.mas_equalTo(30);
    }];
    [self.RGBBrightnessSlider addTarget:self action:@selector(rgbBrightnessSliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initStreamLightView:(UIView *)streamView{
    
    
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = [UIColor whiteColor];
    [streamView addSubview:bgView1];
    
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(streamView);
        make.top.mas_equalTo(streamView).mas_offset(15);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *durationLabel = [[UILabel alloc] init];
    durationLabel.text = @"Update Duration";
    durationLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView1 addSubview:durationLabel];
    
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(bgView1).mas_offset(15);
    }];
    

    UIImageView *durationLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slow"]];
    [bgView1 addSubview:durationLeftImageView];
    
    [durationLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(13);
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(bgView1);
    }];
    
    UIImageView *brightnessRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fast"]];
    [bgView1 addSubview:brightnessRightImageView];
    
    [brightnessRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(13);
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(bgView1);
    }];
    
    self.streamDurationSlider = [[UISlider alloc] init];
    self.streamDurationSlider.maximumValue = 5000;
    self.streamDurationSlider.minimumValue = 1000;
    self.streamDurationSlider.minimumTrackTintColor = THEMECOLOR;
    self.streamDurationSlider.value = [self.device.functionValuesMap.duration floatValue];
    [bgView1 addSubview:self.streamDurationSlider];
    
    [self.streamDurationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(durationLeftImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(brightnessRightImageView.mas_left).mas_offset(-15);
        make.centerY.mas_equalTo(bgView1);
        make.height.mas_equalTo(30);
    }];
    [self.streamDurationSlider addTarget:self action:@selector(durationBrightnessSliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    
    
    ///bg2
    UIView *bgView2 = [[UIView alloc] init];
    bgView2.backgroundColor = [UIColor whiteColor];
    [streamView addSubview:bgView2];
    
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(bgView1);
        make.top.mas_equalTo(bgView1.mas_bottom).mas_offset(15);
    }];
    
    UILabel *brightnessLabel = [[UILabel alloc] init];
    brightnessLabel.text = @"Update brightness";
    brightnessLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView2 addSubview:brightnessLabel];
    
    [brightnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(bgView2).mas_offset(15);
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightdark"]];
    [bgView2 addSubview:leftImageView];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(18);
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(bgView2);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightbright"]];
    [bgView2 addSubview:rightImageView];
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(21);
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(bgView2);
    }];
    
    //brightness
    self.StreamBrightnessSlider = [[UISlider alloc] init];
    self.StreamBrightnessSlider.maximumValue = 100;
    self.StreamBrightnessSlider.minimumValue = 1;
    self.StreamBrightnessSlider.minimumTrackTintColor = THEMECOLOR;
    self.StreamBrightnessSlider.value = [self.device.functionValuesMap.brightness floatValue];
    [bgView2 addSubview:self.StreamBrightnessSlider];
    
    [self.StreamBrightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(rightImageView.mas_left).mas_offset(-15);
        make.centerY.mas_equalTo(bgView2);
        make.height.mas_equalTo(30);
    }];
    [self.StreamBrightnessSlider addTarget:self action:@selector(streamBrightnessSliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *settingButton = [[UIButton alloc] init];
    settingButton.layer.masksToBounds = YES;
    settingButton.layer.cornerRadius = 20;
    settingButton.layer.borderWidth = 1.0;
    settingButton.layer.borderColor = RGB(3, 3, 3).CGColor;
    [settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [settingButton setTitle:@"Setting" forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(gotoSettingStreamPage) forControlEvents:UIControlEventTouchUpInside];
    [streamView addSubview:settingButton];
    
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(streamView);
        make.top.mas_equalTo(bgView2.mas_bottom).mas_offset(30);
    }];
}


-(void)updateLightStatus{
    
    BOOL status = self.device.functionValuesMap.colorLight;
    
    [self.device updateDeviceStatus:!status success:^(id responseObject) {
        
        NSLog(@"OPOPOPOPO");
        
        [self updateCloseButton];
    } failure:^(NSError *error) {
        
        NSLog(@"YYYYYYYYY");
        
        [self updateCloseButton];
    }];
}

-(void)updateCloseButton{
    
    NSLog(@"当前灯泡状态 = %d",self.device.functionValuesMap.colorLight);
    
    if (self.device.functionValuesMap.colorLight) {
        [self.LightButton setTitle:@"Close" forState:UIControlStateNormal];
        self.LightButton.backgroundColor = THEMECOLOR;
    }else{
        [self.LightButton setTitle:@"Open" forState:UIControlStateNormal];
        self.LightButton.backgroundColor = RGB(255, 108, 9);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMELightMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMELightMenuCollectionViewCell alloc] init];
    }
    
    NSArray *normalImages = @[@"WhiteNormal",@"RGBNormal",@"StreamNormal"];
    NSArray *selImages = @[@"WhiteSel",@"RGBSel",@"StreamSel"];
    
    NSArray *titles = @[@"White Light",@"RGB Light",@"Stream Light"];
    
    
    cell.menuImageView.image = [UIImage imageNamed:normalImages[indexPath.item]];
    
    cell.imageNormal = normalImages[indexPath.item];
    cell.imageSel = selImages[indexPath.item];
    
    cell.menuTitleLabel.text = titles[indexPath.item];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentIndexPathItem = indexPath.item;
    
    CGFloat width = self.menuScrollView.frame.size.width;
    
    if (indexPath.item == 2) {
//        [self.device updateStreamLightColorWithRGB1:@"187_20_10" RGB2:@"255_180_99" RGB3:@"222_88_10" RGB4:@"100_9_230" success:^(id responseObject) {
//
//        } failure:^(NSError *error) {
//
//        }];
    }
    
    [self.menuScrollView setContentOffset:CGPointMake(indexPath.item * width, 0) animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.menuScrollView.frame.size.width - 3)/3;
    
    
    
    return CGSizeMake(width, 100);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}



-(void)brightnessSliderValueChange:(UISlider *)slider{
    
    NSLog(@"brightness slider value = %f", slider.value);
    
    
    
    
    self.brightnessSlider.value = slider.value;
    self.RGBBrightnessSlider.value = slider.value;
    self.StreamBrightnessSlider.value = slider.value;
    
    [self.device updateIncandescentLightBrightness:(int)slider.value success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)rgbBrightnessSliderValueChange:(UISlider *)slider{
    
    NSLog(@"rgb brightness slider value = %f", slider.value);
    
    self.brightnessSlider.value = slider.value;
    self.RGBBrightnessSlider.value = slider.value;
    self.StreamBrightnessSlider.value = slider.value;
    
    [self.device updateRGBLightBrightness:(int)slider.value success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)streamBrightnessSliderValueChange:(UISlider *)slider{
    
    
    NSLog(@"stream brightness slider value = %f", slider.value);
    
    self.brightnessSlider.value = slider.value;
    self.RGBBrightnessSlider.value = slider.value;
    self.StreamBrightnessSlider.value = slider.value;
    
    [self.device updateStreamLightBrightness:(int)slider.value success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)rgbColorSliderValueChange:(EHOMEColorSlider *)slider{
    
    NSLog(@"color slider = %f",slider.value);
    
    CGPoint  point=CGPointMake(slider.frame.size.width*slider.value,5);
    UIColor* color=[self colorOfPoint:point];
    if (slider.value<0.98) {
        self.navigationController.navigationBar.barTintColor =color;

        const CGFloat *colorComponents = CGColorGetComponents(color.CGColor);
        NSLog(@"r=%f, g=%f, b=%f", colorComponents[0], colorComponents[1], colorComponents[2]);
        
        int r = (int)(colorComponents[0] * 255.0);
        int g = (int)(colorComponents[1] * 255.0);
        int b = (int)(colorComponents[2] * 255.0);
        
        NSString *rgb = [NSString stringWithFormat:@"%d_%d_%d", r, g, b];


        [self.device updateRGBLightColorWithRGB:rgb success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}

-(void)durationBrightnessSliderValueChange:(UISlider *)slider{

    
    NSLog(@"stream duration slider value = %f", slider.value);

    
    [self.device updateStreamLightDuration:(int)slider.value success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)gotoSettingStreamPage{
    
    EHOMEStreamSettingViewController *settingVC = [[EHOMEStreamSettingViewController alloc] initWithNibName:@"EHOMEStreamSettingViewController" bundle:nil];
    settingVC.device = self.device;
    [self.navigationController pushViewController:settingVC animated:YES];
}


- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [_slider.gradientLayer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

//- (NSMutableArray *) changeUIColorToRGB:(UIColor *)color
//{
//
//    size_t  n = CGColorGetNumberOfComponents(color.CGColor);
//    const CGFloat *rgba = CGColorGetComponents(color.CGColor);
//    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:n];
//    for (int i=0; i<n; i++)
//    {
//        [resultArr addObject:@(rgba[i])];
//    }
//    return resultArr;
//}

@end
