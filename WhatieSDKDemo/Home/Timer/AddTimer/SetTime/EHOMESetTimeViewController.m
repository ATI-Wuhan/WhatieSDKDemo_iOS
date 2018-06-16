//
//  EHOMESetTimeViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESetTimeViewController.h"

@interface EHOMESetTimeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minuteArray;

@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *minute;


@end

@implementation EHOMESetTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Time";
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTime)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    
    NSMutableArray *tempHourArray = [NSMutableArray array];
    for (int i = 0; i<=23; i++) {
        if (i<10) {
            [tempHourArray addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [tempHourArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }

    self.hourArray = tempHourArray;
    
    NSMutableArray *tempMinuteArray = [NSMutableArray array];
    for (int i = 0; i<=60; i++) {
        if (i<10) {
            [tempMinuteArray addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [tempMinuteArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    self.minuteArray = tempMinuteArray;
    
    if ([self.time containsString:@":"]) {
        NSArray *timeArray = [self.time componentsSeparatedByString:@":"];
        
        self.hour = timeArray[0];
        self.minute = timeArray[1];
        
        for (int i = 0; i <= 24; i++) {
            if ([self.hourArray[i] isEqualToString:self.hour]) {
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
        
        for (int i = 0; i <= 60; i++) {
            if ([self.minuteArray[i] isEqualToString:self.minute]) {
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                break;
            }
        }
    }else{
        self.hour = @"18";
        self.minute = @"30";
        [self.pickerView selectRow:18 inComponent:0 animated:YES];
        [self.pickerView selectRow:30 inComponent:1 animated:YES];
    }
    
}


-(void)doneTime{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.hourArray.count;
    }else{
        return self.minuteArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.hourArray[row];
    }else{
        return self.minuteArray[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.hour = self.hourArray[row];
    }else{
        self.minute = self.minuteArray[row];
    }
    
    NSString *time = [NSString stringWithFormat:@"%@:%@", _hour, _minute];
    
    self.timeblock(time);
}



@end
