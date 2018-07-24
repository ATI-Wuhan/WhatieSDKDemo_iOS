//
//  EHOMEStreamSettingViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/15.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEStreamSettingViewController.h"

#import "EHOMEColorCollectionViewCell.h"

#import "EHOMEColorSlider.h"

static NSString *cellId = @"EHOMEColorCollectionViewCell";

@interface EHOMEStreamSettingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *colorCollectionView;

@property (nonatomic, strong) NSMutableArray *colorsArray;

//RGB light
@property (nonatomic, strong) EHOMEColorSlider *slider;

@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation EHOMEStreamSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = GREYCOLOR;
    
    self.title = @"RGB Colors";
    
    NSString *rgb1 = self.device.functionValuesMap.rgb1;
    NSString *rgb2 = self.device.functionValuesMap.rgb2;
    NSString *rgb3 = self.device.functionValuesMap.rgb3;
    NSString *rgb4 = self.device.functionValuesMap.rgb4;
    

    
    self.colorsArray = [NSMutableArray arrayWithArray:@[[UIColor redColor],
                                                        [UIColor yellowColor],
                                                        [UIColor greenColor],
                                                        [UIColor blueColor]
                                                        ]];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(updateStreamLight)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [self initCollectionView];


    self.indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.colorCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
    
    _slider=[[EHOMEColorSlider alloc] initWithFrame:CGRectMake(15, 180,[UIScreen mainScreen].bounds.size.width - 30, 30)];
    _slider.value=0.5;
    [_slider addTarget:self action:@selector(rgbColorSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
}

-(void)initCollectionView{
    
    self.colorCollectionView.delegate = self;
    self.colorCollectionView.dataSource = self;
    
    self.colorCollectionView.backgroundColor = GREYCOLOR;
    
    
    [self.colorCollectionView registerNib:[UINib nibWithNibName:@"EHOMEColorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellId];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEColorCollectionViewCell alloc] init];
    }

    cell.colorView.backgroundColor = self.colorsArray[indexPath.item];

    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.indexpath = indexPath;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.view.frame.size.width - 3)/4;

    return CGSizeMake(width, 100);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rgbColorSliderValueChange:(EHOMEColorSlider *)slider{
    
    NSLog(@"color slider = %f",slider.value);
    
    CGPoint  point=CGPointMake(slider.frame.size.width*slider.value,5);
    UIColor* color=[self colorOfPoint:point];
    if (slider.value<0.98) {

        
        [self.colorsArray replaceObjectAtIndex:self.indexpath.item withObject:color];
        
        [self.colorCollectionView reloadData];

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

-(void)updateStreamLight{
    
    NSMutableArray *colors = [NSMutableArray array];
    
    for (UIColor *color in self.colorsArray) {
        const CGFloat *colorComponents = CGColorGetComponents(color.CGColor);

        int r = (int)(colorComponents[0] * 255.0);
        int g = (int)(colorComponents[1] * 255.0);
        int b = (int)(colorComponents[2] * 255.0);
        
        NSString *rgb = [NSString stringWithFormat:@"%d_%d_%d", r, g, b];
        
        [colors addObject:rgb];
    }
    
    [self.device updateStreamLightColorWithRGB1:colors[0] RGB2:colors[1] RGB3:colors[2] RGB4:colors[3] success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    

}



@end
