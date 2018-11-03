//
//  EHOMESetTimeViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESetTimeViewController.h"

@interface EHOMESetTimeViewController ()

@property (retain, nonatomic) IBOutlet UIDatePicker *timeDatePicker;

@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minuteArray;

@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *minute;


@end

@implementation EHOMESetTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Time", @"DeviceFunction", nil);
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneTime)];
    self.navigationItem.rightBarButtonItem = doneItem;

    
    
}


-(void)doneTime{
    
    self.timeblock([self dateToString:self.timeDatePicker.date]);
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)dateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    [_timeDatePicker release];
    [super dealloc];
}
@end
