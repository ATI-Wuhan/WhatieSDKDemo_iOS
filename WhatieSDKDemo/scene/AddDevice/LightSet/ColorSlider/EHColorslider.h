//
//  EHColorslider.h
//  eHome
//
//  Created by clj on 2018/6/22.
//  Copyright © 2018年 丁一冉. All rights reserved.
//
@protocol ColorSliderDelegate <NSObject>;
-(void)changeColorSliderValueWith:(UISlider *)slider andSliderTag:(int)tag;
@end
#import <UIKit/UIKit.h>

@interface EHColorslider : UIView
@property (nonatomic, weak) id<ColorSliderDelegate> delegate; //事件代理协议
@property(nonatomic,strong) UISlider *colorSlider;
@property(nonatomic,assign) int sliderTag;
@end
