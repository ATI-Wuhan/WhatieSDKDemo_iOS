//
//  EHOMERGBLightViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

static NSString *cellId = @"EHOMELightMenuCollectionViewCell";

#import "EHOMERGBLightViewController.h"

#import "EHOMELightMenuCollectionViewCell.h"

#import "EHOMEColorSlider.h"

@interface EHOMERGBLightViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;


@property (nonatomic, strong) EHOMEColorSlider *slider;

@property (nonatomic, strong) UISlider *brightnessSlider;

//white light
@property (nonatomic, strong) UIButton *whiteLightButton;


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
    
    
    
    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    
//    _slider=[[EHOMEColorSlider alloc] initWithFrame:CGRectMake(20, 100, width - 40, 30)];
//    _slider.value=0.5;
//    [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_slider];
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
//    self.brightnessSlider = [[UISlider alloc] init];
//    [self.view addSubview:self.brightnessSlider];
//    self.brightnessSlider.maximumValue = 100;
//    self.brightnessSlider.minimumValue = 1;
//    
//    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.slider);
//        make.top.mas_equalTo(brightnessLabel.mas_bottom).mas_offset(30);
//        make.height.mas_equalTo(30);
//    }];
//    [self.brightnessSlider addTarget:self action:@selector(brightnessSliderValueChange:) forControlEvents:UIControlEventValueChanged];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
//    UIView *whiteLightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    whiteLightView.backgroundColor = GREYCOLOR;
//    [self.menuScrollView addSubview:whiteLightView];
//
//    UIView *RGBLightView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
//    RGBLightView.backgroundColor = GREYCOLOR;
//    [self.menuScrollView addSubview:RGBLightView];
//
//    UIView *StreamLightView = [[UIView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
//    StreamLightView.backgroundColor = GREYCOLOR;
//    [self.menuScrollView addSubview:StreamLightView];

    
    UIView *whiteLightView = [[UIView alloc] init];
    whiteLightView.backgroundColor = GREYCOLOR;
    [self.menuScrollView addSubview:whiteLightView];
    
    UIView *RGBLightView = [[UIView alloc] init];
    RGBLightView.backgroundColor = GREYCOLOR;
    [self.menuScrollView addSubview:RGBLightView];
    
    UIView *StreamLightView = [[UIView alloc] init];
    StreamLightView.backgroundColor = GREYCOLOR;
    [self.menuScrollView addSubview:StreamLightView];
    
    [whiteLightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.menuScrollView);
        make.width.mas_equalTo(width);
    }];
    
    [RGBLightView mas_makeConstraints:^(MASConstraintMaker *make) {

    }];
    
    
    [self initWhiteLightView:whiteLightView];
    [self initRGBLightView];
    [self initStreamLightView];
}

-(void)initWhiteLightView:(UIView *)whiteView{
    
    self.whiteLightButton = [[UIButton alloc] init];
    self.whiteLightButton.layer.masksToBounds = YES;
    self.whiteLightButton.layer.cornerRadius = 49.0;
    self.whiteLightButton.backgroundColor = THEMECOLOR;
    [self.whiteLightButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.view addSubview:self.whiteLightButton];
    [self.whiteLightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(98);
        make.bottom.mas_equalTo(whiteView.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(whiteView);
    }];
    
}

-(void)initRGBLightView{
    
}

-(void)initStreamLightView{
    
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
    
    NSLog(@"brightness slider value = %d", (int)slider.value);
    
//    [self.device update]
    
}


-(void)sliderValueChange:(EHOMEColorSlider *)slider{
    NSLog(@"%f",slider.value);
    CGPoint  point=CGPointMake(slider.frame.size.width*slider.value,5);
    UIColor* color=[self colorOfPoint:point];
    if (slider.value<0.98) {
        self.view.backgroundColor=color;
        
        
        NSArray *colors = [self getRGBWithColor:color];
        
        
        
        [self.device updateLightColorWithR:[colors[0] intValue] G:[colors[1] intValue] B:[colors[2] intValue] success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }
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

// 获取RGB和Alpha
- (NSArray *)getRGBWithColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}

@end
