//
//  EHOMETimerTableViewCell.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMETimerTableViewCell.h"

@implementation EHOMETimerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updateTimerStatus:(id)sender {
    
    UISwitch *timerSwitch = sender;
    
    BOOL timerStatus = timerSwitch.on;
    
    [self.timer updateTimerStatus:timerStatus success:^(id responseObject) {
        NSLog(@"update timer status success.response = %@", responseObject);
        
        self.timer.deviceClock.clockStatus = timerStatus;
        
        [self.delegate updateTimerStatusIndexPath:self.indexPath timer:self.timer];
        
    } failure:^(NSError *error) {
        NSLog(@"update timer status failed.error = %@", error);
    }];
    
}

-(void)setTimer:(EHOMETimer *)timer{
    
    _timer = timer;
    
    if (_timer != nil) {
        
        NSString *dpsName = _timer.deviceClock.deviceStatus ? @"Turn on" : @"Turn off";
        
        self.timerDpsNameLabel.text = dpsName;
        self.timerFinishTimeLabel.text = _timer.finishTimeApp;
        
        BOOL timerStatus = _timer.deviceClock.clockStatus;
        
        [self.timerSwitch setOn:timerStatus animated:YES];
        
        NSString *loops = _timer.deviceClock.timerType;
        
        NSString *loopsCopy = [loops copy];
        
        NSMutableArray *loopsArray = [NSMutableArray array];
        
        for (int i = 0; i<loops.length; i++) {
            NSString *loop = [loopsCopy substringWithRange:NSMakeRange(i, 1)];
            [loopsArray addObject:loop];
        }
        
        NSLog(@"loopsARRAY = %@", loopsArray);
        
        NSArray *WEEK = @[@"Sunday",@"Saturday",@"Friday",@"Thursday",@"Wednesday",@"Tuesday",@"Monday"];
        
        NSMutableString *loopsShow = [NSMutableString string];
        
        if ([loops isEqualToString:@"1100000"]) {
            loopsShow = [NSMutableString stringWithString:@"weekend"];
        }else if([loops isEqualToString:@"0011111"]){
            loopsShow = [NSMutableString stringWithString:@"weekday"];
        }else if ([loops isEqualToString:@"1111111"]){
            loopsShow = [NSMutableString stringWithString:@"Everyday"];
        }else{
            for (int i = 0; i < loopsArray.count; i++) {
                if ([loopsArray[i] isEqualToString:@"1"]) {
                    [loopsShow appendString:[NSString stringWithFormat:@"%@ ",WEEK[i]]];
                }
            }
        }
        
        self.timerLoopsLabel.text = loopsShow;
    }
}
@end
