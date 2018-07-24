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
        
        NSString *dpsName = _timer.deviceClock.deviceStatus ? NSLocalizedStringFromTable(@"Turn on", @"DeviceFunction", nil) : NSLocalizedStringFromTable(@"Turn off", @"DeviceFunction", nil);
        
        NSString *tagStr=NSLocalizedStringFromTable(@"Tag", @"DeviceFunction", nil);
        NSString *toStr=NSLocalizedStringFromTable(@"TO", @"DeviceFunction", nil);
        self.timerDpsNameLabel.text = [NSString stringWithFormat:@"%@:%@(%@:%@)",tagStr, _timer.deviceClock.tag,toStr,dpsName];
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
        
        NSArray *WEEK = @[NSLocalizedStringFromTable(@"Sunday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Saturday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Friday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Thursday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Wednesday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Tuesday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Monday", @"DeviceFunction", nil)];
        
        NSMutableString *loopsShow = [NSMutableString string];
        
        if ([loops isEqualToString:@"1100000"]) {
            loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"weekend", @"DeviceFunction", nil)];
        }else if([loops isEqualToString:@"0011111"]){
            loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"weekday", @"DeviceFunction", nil)];
        }else if ([loops isEqualToString:@"1111111"]){
            loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"Everyday", @"DeviceFunction", nil)];
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
