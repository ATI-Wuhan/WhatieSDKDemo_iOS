//
//  EHOMEHomeTableViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define cellId @"EHOMEHomeTableViewCell"

#import "EHOMEHomeTableViewController.h"
#import "EHOMEHomeTableViewCell.h"
#import "EHOMEAddDeviceTableViewController.h"
#import "EHOMEQRCodeViewController.h"
#import "EHOMEScanViewController.h"
#import "EHOMEOutletDetailViewController.h"

@interface EHOMEHomeTableViewController ()

@end

@implementation EHOMEHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Home";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addDeviceAction)];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    [self initTableView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationDeviceArrayChanged object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    
    self.tableView.rowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEHomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullDownRefresh];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPullDownRefresh) name:@"GetStartedNotice" object:nil];
}


-(void) reloadData {
    //可以在这里刷新UI

    NSLog(@"[EHOMEUserModel shareInstance].deviceArray 有变更");
    
    [self.tableView reloadData];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)beginPullDownRefresh{
    [self.tableView.mj_header beginRefreshing];
}

-(void)pullDownRefresh{
    
    [[EHOMEUserModel shareInstance] syncDeviceWithCloud:^(id responseObject) {
        NSLog(@"Get my devices successful : %@", responseObject);

        
        if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"There is no device in your HOME,try to Add devices to build your eHome." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Get my devices failed : %@", error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [EHOMEUserModel shareInstance].deviceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    if (!cell) {
        cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.deviceModel = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
    
    return cell;
}





#pragma mark - Table view delegate

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEDeviceModel *model = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
    
    NSString *title = @"Remove";
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [model removeDevice:^(id responseObject) {
            
            NSLog(@"unbind success = %@", responseObject);
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:[EHOMEUserModel shareInstance].deviceArray];
            
            [temp removeObject:model];
            
            [EHOMEUserModel shareInstance].deviceArray = temp;
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"unbind failed = %@", error);
        }];

    }];
    
    UITableViewRowAction *editNameRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Edit Name" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self editDeviceNameWithIndexPath:indexPath];
        
    }];
    editNameRowAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *shareRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Share Device" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EHOMEQRCodeViewController *qrCodeVC = [[EHOMEQRCodeViewController alloc] initWithNibName:@"EHOMEQRCodeViewController" bundle:nil];
        qrCodeVC.deviceModel = model;
        [self.navigationController pushViewController:qrCodeVC animated:YES];
    }];
    shareRowAction.backgroundColor = [UIColor greenColor];
    
    return @[deleteRowAction, editNameRowAction, shareRowAction];
    
}

-(void)editDeviceNameWithIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEDeviceModel *device = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
    
    NSString *title = @"Alert";
    NSString *message = @"update device name";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"device name";
        textField.text = device.device.name;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        [device updateDeviceName:name success:^(id responseObject) {
            NSLog(@"update device name success. res = %@", responseObject);
            
            device.device.name = name;
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[EHOMEUserModel shareInstance].deviceArray];
            [tempArray replaceObjectAtIndex:indexPath.section withObject:device];
            [EHOMEUserModel shareInstance].deviceArray = tempArray;
            [self.tableView reloadData];

        } failure:^(NSError *error) {
            NSLog(@"update device name failed. error = %@", error);
        }];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHOMEOutletDetailViewController *outletVC = [[EHOMEOutletDetailViewController alloc] initWithNibName:@"EHOMEOutletDetailViewController" bundle:nil];
    outletVC.device = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
    [outletVC setUpdateDeviceStatusBlock:^(EHOMEDeviceModel *device) {
        [tableView reloadData];
    }];
    [self.navigationController pushViewController:outletVC animated:YES];
}

-(void)addDeviceAction{
    EHOMEAddDeviceTableViewController *addDeviceVC = [[EHOMEAddDeviceTableViewController alloc] initWithNibName:@"EHOMEAddDeviceTableViewController" bundle:nil];
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}



@end
