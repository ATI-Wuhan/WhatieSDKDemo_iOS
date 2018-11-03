//
//  EHColorslider.m
//  eHome
//
//  Created by clj on 2018/6/22.
//  Copyright © 2018年 丁一冉. All rights reserved.
//

#import "EHColorslider.h"

@implementation EHColorslider

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.colorSlider=[[UISlider alloc] init];
        self.colorSlider.minimumTrackTintColor=[UIColor clearColor];
        self.colorSlider.maximumTrackTintColor=[UIColor clearColor];
        self.colorSlider.minimumValue=0.0;
        self.colorSlider.maximumValue=1534.0;
        if (CurrentApp == Geek) {
            [self.colorSlider setThumbImage:[UIImage imageNamed:@"滑块白色"] forState:UIControlStateNormal];
        }else if (CurrentApp == Ozwi){
            [self.colorSlider setThumbImage:[UIImage imageNamed:@"Ozwi_滑块白色"] forState:UIControlStateNormal];
        }else{
            [self.colorSlider setThumbImage:[UIImage imageNamed:@"ehome_滑块白色"] forState:UIControlStateNormal];
        }
        
        [self.colorSlider addTarget:self action:@selector(colorsliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.colorSlider];
        
        UIImageView *colorView=[[UIImageView alloc] init];
        colorView.image=[UIImage imageNamed:@"colorview"];
        [self.colorSlider addSubview:colorView];
        
        [self.colorSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(16);
        }];
    }
    return self;
}

-(void)colorsliderValueChange:(UISlider *)slider{
    NSLog(@"改变了彩色滑动条，当前的值 = %f",slider.value);
    [self.delegate changeColorSliderValueWith:slider andSliderTag:self.sliderTag];
}
@end
