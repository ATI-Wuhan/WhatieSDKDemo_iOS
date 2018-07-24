//
//  EHOMESelectTimeViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESelectTimeViewController.h"

@interface EHOMESelectTimeViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *timeDatePicker;


@end

@implementation EHOMESelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Time", @"DeviceFunction", nil);
    
    UIBarButtonItem *Cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = Cancel;
    
    UIBarButtonItem *Done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneTimeAction)];
    self.navigationItem.rightBarButtonItem = Done;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneTimeAction{
    
    NSLog(@"当前时区 = %zd", [self getSourceGMTOffset:self.timeDatePicker.date]);

    NSLog(@"当前所选时间 = %@", [self dateToString:self.timeDatePicker.date]);
    
    self.timeblock([self dateToString:self.timeDatePicker.date]);
    [self pop];
    
}

- (NSInteger)getSourceGMTOffset:(NSDate *)date{

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [zone secondsFromGMTForDate:date];
    
    NSInteger GMT = (NSInteger)(sourceGMTOffset / 3600);
    
    return GMT;
}

- (NSString *)dateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}



@end
