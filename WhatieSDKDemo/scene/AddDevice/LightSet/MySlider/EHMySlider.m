//
//  EHMySlider.m
//  eHome
//
//  Created by clj on 2018/6/12.
//  Copyright © 2018年 丁一冉. All rights reserved.
//

#import "EHMySlider.h"

@implementation EHMySlider

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 16, CGRectGetWidth(self.frame), 8);
    //return CGRectMake(0, 16, CGRectGetWidth(self.frame)-40, 8);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
