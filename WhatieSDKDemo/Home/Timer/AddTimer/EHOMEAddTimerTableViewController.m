//
//  EHOMEAddTimerTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAddTimerTableViewController.h"
#import "EHOMESetTimeViewController.h"

@interface EHOMEAddTimerTableViewController ()

@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSMutableArray *loopsArray;

@end

@implementation EHOMEAddTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(addTimer)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    if (self.isEditTimer) {
        self.title = @"Update Timer";
        
        self.time = self.timer.finishTimeApp;
        self.status = self.timer.deviceClock.deviceStatus;
        
        NSString *loopsString = self.timer.deviceClock.timerType;
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (int i = 0; i<self.timer.deviceClock.timerType.length; i++) {
            int loop = [[loopsString substringWithRange:NSMakeRange(i, 1)] intValue];
            [tempArray addObject:[NSNumber numberWithInt:loop]];
        }
        
        self.loopsArray = tempArray;
    }else{
        self.title = @"Add Timer";
        
        self.time = @"18:30";
        self.status = YES;
        self.loopsArray = [[NSMutableArray alloc] initWithArray:@[@(1),@(1),@(1),@(1),@(1),@(1),@(1)]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addTimer{

    NSMutableString *loops = [NSMutableString string];
    for (NSNumber *loop in self.loopsArray) {
        [loops appendString:[loop stringValue]];
    }
    
    NSLog(@"Add Timer Info ,time = %@, status = %d, loops = %@",self.time, self.status, loops);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.isEditTimer) {
        //update timer
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"updating timer..." hideAfterDelay:10];
        
        [self.timer updateTimerWithLoops:loops time:self.time status:self.status success:^(id responseObject) {
            NSLog(@"update timer success, response = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];

            EHOMETimer *timer = responseObject;
            
            weakSelf.updateTimerBlock(timer);
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            NSLog(@"update timer failed, error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1];
        }];
    }else{
        //add timer
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Adding timer..." hideAfterDelay:10];
        
        [self.device addTimerWithLoops:loops time:self.time status:self.status success:^(id responseObject) {
            NSLog(@"add timer success, response = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddTimerNoticeSuccess" object:nil userInfo:nil];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            NSLog(@"add timer failed, error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1];
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 7;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.time;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1){
        cell.textLabel.text = @[@"Turn on",@"Turn off"][indexPath.row];
        
        if (self.status) {
            if (indexPath.row == 0) {
                cell.textLabel.textColor = THEMECOLOR;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.textLabel.textColor = [UIColor blackColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            if (indexPath.row == 1) {
                cell.textLabel.textColor = THEMECOLOR;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.textLabel.textColor = [UIColor blackColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
    }else{
        cell.textLabel.text = @[@"Sunday",@"Saturday",@"Friday",@"Thursday",@"Wednesday",@"Tuesday",@"Monday"][indexPath.row];
        
        if ([self.loopsArray[indexPath.row] intValue] == 1) {
            cell.textLabel.textColor = THEMECOLOR;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        EHOMESetTimeViewController *setTime = [[EHOMESetTimeViewController alloc] initWithNibName:@"EHOMESetTimeViewController" bundle:nil];
        
        __weak typeof(self) weakSelf = self;
        [setTime setTimeblock:^(NSString *time) {
            NSLog(@"选择的时间为 = %@", time);
            weakSelf.time = time;
            [tableView reloadData];
        }];
        [self.navigationController pushViewController:setTime animated:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            self.status = YES;
        }else{
            self.status = NO;
        }
        [self.tableView reloadData];
    }else{

        int loop = [self.loopsArray[indexPath.row] intValue];

        if (loop == 1) {
            [self.loopsArray replaceObjectAtIndex:indexPath.row withObject:@(0)];
        }else{
            [self.loopsArray replaceObjectAtIndex:indexPath.row withObject:@(1)];
        }

        [self.tableView reloadData];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @[@"Time",@"Status",@"Loops"][section];
}


@end
