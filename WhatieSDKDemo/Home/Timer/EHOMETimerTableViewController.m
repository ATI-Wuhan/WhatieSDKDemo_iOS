//
//  EHOMETimerTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

static NSString *cellId = @"EHOMETimerTableViewCell";

#import "EHOMETimerTableViewController.h"
#import "EHOMETimerTableViewCell.h"
#import "EHOMEAddTimerTableViewController.h"

@interface EHOMETimerTableViewController ()<updateTimerStatusDelegate>

@property (nonatomic, strong) NSArray *timerArray;

@end

@implementation EHOMETimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Timer", @"DeviceFunction", nil);
    
    UIBarButtonItem *addTimerItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Add", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addTimer)];
    self.navigationItem.rightBarButtonItem = addTimerItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMETimerTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    [self.tableView setTableFooterView:[UIView new]];
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAllTimers];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTimer) name:@"AddTimerNoticeSuccess" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadTimer{
    [self.tableView.mj_header beginRefreshing];
}


-(void)getAllTimers{
    [self.device getAllTimers:^(id responseObject) {
        NSLog(@"get all timers success,timers = %@", responseObject);
        
        for (EHOMETimer *timer in responseObject) {
            NSLog(@"Current timer tag is = %@", timer.deviceClock.tag);
        }
        
        self.timerArray = responseObject;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"get all timers failed,error = %@", error);
        [self.tableView.mj_header endRefreshing];
    }];
}


-(void)addTimer{
    EHOMEAddTimerTableViewController *addTimerVC = [[EHOMEAddTimerTableViewController alloc] initWithNibName:@"EHOMEAddTimerTableViewController" bundle:nil];
    addTimerVC.isEditTimer = NO;
    addTimerVC.device = self.device;
    
    [self.navigationController pushViewController:addTimerVC animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.timerArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMETimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMETimerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.timer = self.timerArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;

    return cell;
}

-(void)updateTimerStatusIndexPath:(NSIndexPath *)indexPath timer:(EHOMETimer *)timer{
    NSMutableArray *timersCopy = [NSMutableArray arrayWithArray:self.timerArray];
    [timersCopy replaceObjectAtIndex:indexPath.row withObject:timer];
    self.timerArray = timersCopy;
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHOMEAddTimerTableViewController *addTimerVC = [[EHOMEAddTimerTableViewController alloc] initWithNibName:@"EHOMEAddTimerTableViewController" bundle:nil];
    addTimerVC.isEditTimer = YES;
    addTimerVC.timer = self.timerArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [addTimerVC setUpdateTimerBlock:^(EHOMETimer *timer) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:weakSelf.timerArray];
        [tempArray replaceObjectAtIndex:indexPath.row withObject:timer];
        weakSelf.timerArray = tempArray;
        [tableView reloadData];
    }];
    
    [self.navigationController pushViewController:addTimerVC animated:YES];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedStringFromTable(@"Remove Timer", @"DeviceFunction", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        __weak typeof(self) weakSelf = self;
        
        //remove timer
        EHOMETimer *currentTimer = self.timerArray[indexPath.row];
        
        [currentTimer removeTimer:^(id responseObject) {
            NSLog(@"remove timer success.response = %@", responseObject);
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:weakSelf.timerArray];
            [tempArray removeObject:currentTimer];
            weakSelf.timerArray = tempArray;
            [tableView reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"remove timer failed.error = %@", error);
        }];
        
    }];
    return @[delete];
}



@end
