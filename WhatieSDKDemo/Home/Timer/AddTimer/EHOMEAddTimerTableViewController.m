//
//  EHOMEAddTimerTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define tagCellId @"EHOMETimerTagTableViewCell"

#import "EHOMEAddTimerTableViewController.h"
#import "EHOMESetTimeViewController.h"
#import "EHOMETimerTagTableViewCell.h"

@interface EHOMEAddTimerTableViewController ()<UITextFieldDelegate>

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSMutableArray *loopsArray;

@end

@implementation EHOMEAddTimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addTimer)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    if (self.isEditTimer) {
        self.title = NSLocalizedStringFromTable(@"Update Timer", @"DeviceFunction", nil);
        
        self.time = self.timer.finishTimeApp;
        self.status = self.timer.deviceClock.deviceStatus;
        self.tag = self.timer.deviceClock.tag;
        
        NSString *loopsString = self.timer.deviceClock.timerType;
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (int i = 0; i<self.timer.deviceClock.timerType.length; i++) {
            int loop = [[loopsString substringWithRange:NSMakeRange(i, 1)] intValue];
            [tempArray addObject:[NSNumber numberWithInt:loop]];
        }
        
        self.loopsArray = tempArray;
    }else{
        self.title = NSLocalizedStringFromTable(@"Add Timer", @"DeviceFunction", nil);
        
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
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    NSMutableString *loops = [NSMutableString string];
    for (NSNumber *loop in self.loopsArray) {
        [loops appendString:[loop stringValue]];
    }
    
    NSLog(@"Add Timer Info ,time = %@, status = %d, loops = %@",self.time, self.status, loops);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.isEditTimer) {
        //update timer
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating timer", @"DeviceFunction", nil) hideAfterDelay:10];
        
        [self.timer updateTimerWithLoops:loops time:self.time status:self.status tag:self.tag success:^(id responseObject) {
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
    
        NSLog(@"The tag is %@", self.tag);
        
        [self.device addTimerWithLoops:loops time:self.time status:self.status tag:self.tag success:^(id responseObject) {
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

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 2) {
        return 2;
    }else if (section == 3){
        return 7;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"EHOMETimerTagTableViewCell" bundle:nil] forCellReuseIdentifier:tagCellId];
        EHOMETimerTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellId];
        if (!cell) {
            cell = [[EHOMETimerTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tagCellId];
        }
        
        if (_isEditTimer) {
            cell.tagTextField.text = self.tag;
        }
        
        
        cell.tagTextField.delegate = self;
        
        return cell;
    }else{
        static NSString *cellId = @"cellId";
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        
        if (indexPath.section == 1) {
            cell.textLabel.text = self.time;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.section == 2){
            cell.textLabel.text = @[NSLocalizedStringFromTable(@"Turn on", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Turn off", @"DeviceFunction", nil)][indexPath.row];
            
            if (self.status) {
                if (indexPath.row == 0) {
                    cell.textLabel.textColor = THEMECOLOR;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = THEMECOLOR;
                }else{
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else{
                if (indexPath.row == 1) {
                    cell.textLabel.textColor = THEMECOLOR;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = THEMECOLOR;
                }else{
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            
        }else{
            cell.textLabel.text = @[NSLocalizedStringFromTable(@"Sunday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Saturday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Friday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Thursday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Wednesday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Tuesday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Monday", @"DeviceFunction", nil)][indexPath.row];
            
            if ([self.loopsArray[indexPath.row] intValue] == 1) {
                cell.textLabel.textColor = THEMECOLOR;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.tintColor = THEMECOLOR;
            }else{
                cell.textLabel.textColor = [UIColor blackColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        EHOMESetTimeViewController *setTime = [[EHOMESetTimeViewController alloc] initWithNibName:@"EHOMESetTimeViewController" bundle:nil];
        
        __weak typeof(self) weakSelf = self;
        [setTime setTimeblock:^(NSString *time) {
            NSLog(@"选择的时间为 = %@", time);
            weakSelf.time = time;
            [tableView reloadData];
        }];
        [self.navigationController pushViewController:setTime animated:YES];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            self.status = YES;
        }else{
            self.status = NO;
        }
        [self.tableView reloadData];
    }else if (indexPath.section == 3){

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
    return @[NSLocalizedStringFromTable(@"Tag", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Time", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Status", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Loops", @"DeviceFunction", nil)][section];
}


#pragma MARK - TextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"TAG TextField Text = %@", textField.text);
    
    self.tag = textField.text;
    
}


@end
