//
//  EHOMESceneDeviceListTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/26.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define cellId @"EHOMEDeviceInfoCell"

#import "EHOMESceneDeviceListTableViewController.h"
#import "EHOMEDeviceInfoCell.h"
#import "EHOMEOutletStatusTableViewController.h"
#import "EHOMELightModeTableViewController.h"

@interface EHOMESceneDeviceListTableViewController ()
@property (nonatomic, strong) NSArray *devices;
@end

@implementation EHOMESceneDeviceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Scene", nil);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEDeviceInfoCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success. home = %@", responseObject);
        
        
        EHOMEHomeModel *home = responseObject;
        
        [home syncDeviceByHomeSuccess:^(id responseObject) {
            self.devices = responseObject;
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            [self.tableView reloadData];
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Get current home failed. = %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEDeviceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    EHOMEDeviceModel *device = self.devices[indexPath.row];
    
    cell.device = device;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EHOMEDeviceModel *devcieModel = self.devices[indexPath.row];
    if(devcieModel.device.product.productType == 2){
        EHOMELightModeTableViewController *lightModeVC = [[EHOMELightModeTableViewController alloc] initWithNibName:@"EHOMELightModeTableViewController" bundle:nil];
        lightModeVC.selectlight = devcieModel;
        [self.navigationController pushViewController:lightModeVC animated:YES];
    }else{
        EHOMEOutletStatusTableViewController *StatusVC = [[EHOMEOutletStatusTableViewController alloc] initWithNibName:@"EHOMEOutletStatusTableViewController" bundle:nil];
        StatusVC.selectDevice = devcieModel;
        [self.navigationController pushViewController:StatusVC animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
