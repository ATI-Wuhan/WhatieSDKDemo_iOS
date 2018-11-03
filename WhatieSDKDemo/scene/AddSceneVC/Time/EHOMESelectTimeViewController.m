//
//  EHOMESelectTimeViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define InfoCellId @"EHOMEAddSceneInfoTableViewCell"

#import "EHOMESelectTimeViewController.h"
#import "EHOMELoopsTableViewController.h"
#import "EHOMEAddSceneInfoTableViewCell.h"

@interface EHOMESelectTimeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIDatePicker *timeDatePicker;
@property (retain, nonatomic) IBOutlet UITableView *repeatTableView;

@property (nonatomic, copy) NSString *sceneRepeat;
@property (nonatomic, strong) NSMutableArray *loopsArray;
@end

@implementation EHOMESelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Time", @"DeviceFunction", nil);
    
    self.loopsArray = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0)]];
    NSArray *LA = self.loopsArray;
    [self showDaysWithLoops:LA];
    
    UIBarButtonItem *Cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = Cancel;
    
    UIBarButtonItem *Done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneTimeAction)];
    self.navigationItem.rightBarButtonItem = Done;
    
    [self initTableView];
    
}

-(void)initTableView{
    [self.repeatTableView registerNib:[UINib nibWithNibName:@"EHOMEAddSceneInfoTableViewCell" bundle:nil] forCellReuseIdentifier:InfoCellId];
    
    self.repeatTableView.delegate = self;
    self.repeatTableView.dataSource = self;
    
    self.repeatTableView.backgroundColor = GREYCOLOR;
    self.repeatTableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneTimeAction{
    
    NSLog(@"当前时区 = %ld", (long)[self getSourceGMTOffset:self.timeDatePicker.date]);

    NSLog(@"当前所选时间 = %@", [self dateToString:self.timeDatePicker.date]);
    
    self.timeblock([self dateToString:self.timeDatePicker.date]);
    self.daysblock(self.loopsArray);
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



- (void)dealloc {
    [_repeatTableView release];
    [_repeatTableView release];
    [super dealloc];
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEAddSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEAddSceneInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoCellId];
    }
    
    cell.sceneTitleLabel.text = NSLocalizedString(@"Repeat", nil);
    cell.sceneContentLabel.text = self.sceneRepeat;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EHOMELoopsTableViewController *loopsVC = [[EHOMELoopsTableViewController alloc] initWithNibName:@"EHOMELoopsTableViewController" bundle:nil];
    EHOMENavigationController *setLoops = [[EHOMENavigationController alloc] initWithRootViewController:loopsVC];
    
    __weak typeof(self) weakSelf = self;
    
    [loopsVC setLoopsblock:^(NSArray *loops) {
        NSLog(@"loops = %@", loops);
        [weakSelf showDaysWithLoops:loops];
    }];
    
    [self presentViewController:setLoops animated:YES completion:nil];
}

-(void)showDaysWithLoops:(NSArray *)loops{
    
    NSArray *WEEK = @[NSLocalizedStringFromTable(@"Sun", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Sat", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Fri", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Thu", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Wed", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Tue", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Mon", @"DeviceFunction", nil)];
    
    NSMutableString *loopsShow = [NSMutableString string];
    
    if ([loops isEqualToArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0)]]) {
        loopsShow = [NSMutableString stringWithString:NSLocalizedString(@"Never", nil)];
    }else if ([loops isEqualToArray:@[@(1),@(1),@(0),@(0),@(0),@(0),@(0)]]) {
        loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"weekend", @"DeviceFunction", nil)];
    }else if([loops isEqualToArray:@[@(0),@(0),@(1),@(1),@(1),@(1),@(1)]]){
        loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"weekday", @"DeviceFunction", nil)];
    }else if ([loops isEqualToArray:@[@(1),@(1),@(1),@(1),@(1),@(1),@(1)]]){
        loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"Everyday", @"DeviceFunction", nil)];
    }else{
        for (int i = 0; i < loops.count; i++) {
            if ([loops[i] isEqualToNumber:@(1)]) {
                [loopsShow appendString:[NSString stringWithFormat:@"%@ ",WEEK[i]]];
            }
        }
    }
    
    self.sceneRepeat = loopsShow;
    
    self.loopsArray = [loops mutableCopy];
    
    [self.repeatTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

@end
