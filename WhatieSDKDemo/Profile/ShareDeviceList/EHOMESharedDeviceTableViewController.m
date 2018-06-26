//
//  EHOMESharedDeviceTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define cellId @"EHOMEHomeTableViewCell"

#import "EHOMESharedDeviceTableViewController.h"

#import "EHOMEHomeTableViewCell.h"

@interface EHOMESharedDeviceTableViewController ()

@end

@implementation EHOMESharedDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Shared Devices";
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationSharedDeviceArrayChanged object:nil];
    
    
    self.tableView.rowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEHomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullDownRefresh];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void) reloadData {
    //可以在这里刷新UI
    
    NSLog(@"[EHOMEUserModel shareInstance].deviceArray 有变更");
    
    [self.tableView reloadData];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)pullDownRefresh{
    
    [[EHOMEUserModel shareInstance] syncSharedDeviceWithCloud:^(id responseObject) {
        NSLog(@"Get shared devices successful : %@", responseObject);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Get shared devices failed : %@", error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [EHOMEUserModel shareInstance].sharedDeviceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.deviceModel = [EHOMEUserModel shareInstance].sharedDeviceArray[indexPath.section];
    
    return cell;
}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEDeviceModel *model = [EHOMEUserModel shareInstance].sharedDeviceArray[indexPath.section];
    
    NSString *title = @"Remove";
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [model removeDevice:^(id responseObject) {
            
            NSLog(@"remove success = %@", responseObject);
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:[EHOMEUserModel shareInstance].sharedDeviceArray];
            
            [temp removeObjectAtIndex:indexPath.section];
            
            [EHOMEUserModel shareInstance].sharedDeviceArray = temp;
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"remove failed = %@", error);
        }];
        
    }];
    
    return @[deleteRowAction];
    
}



@end
