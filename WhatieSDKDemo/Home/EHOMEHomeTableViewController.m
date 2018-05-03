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

@interface EHOMEHomeTableViewController ()<HomeDeviceDelegate>

@property (nonatomic, strong) NSMutableArray *myDevicesArray;

@end

@implementation EHOMEHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Home";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStylePlain target:self action:@selector(gotoScanPage)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addDeviceAction)];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.myDevicesArray = [NSMutableArray array];
    
    [self initTableView];
    
    /**
     Recived MQTT Data Here With Block
     */
    [[EHOMEMQTTClientManager shareInstance] setMqttBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"**********MQTT********** = %@",dic);
    }];
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

-(void)gotoScanPage{
    EHOMEScanViewController *scanVC = [[EHOMEScanViewController alloc] initWithNibName:@"EHOMEScanViewController" bundle:nil];
    [self.navigationController pushViewController:scanVC animated:YES];
}

-(void)beginPullDownRefresh{
    [self.tableView.mj_header beginRefreshing];
}

-(void)pullDownRefresh{
    [EHOMEDeviceModel getMyDeviceListWithStartBlock:^{
        NSLog(@"Start request my devices...");
    } successBlock:^(id responseObject) {
        NSLog(@"Get my devices successful : %@", responseObject);
        
        [self.myDevicesArray removeAllObjects];
        [self.myDevicesArray addObjectsFromArray:responseObject];
        
        if (self.myDevicesArray.count == 0) {

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"There is no device in your HOME,try to Add devices to build your eHome." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failBlock:^(NSError *error) {
        NSLog(@"Get my devices failed : %@", error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.myDevicesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    if (!cell) {
        cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.deviceModel = self.myDevicesArray[indexPath.section];
    cell.indexpath = indexPath;
    cell.delegate = self;
    
    return cell;
}





#pragma mark - Table view delegate

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEDeviceModel *model = self.myDevicesArray[indexPath.section];
    
    NSString *title = @"Delete";
    if (model.host) {
        title = @"Unbind";
    }
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [EHOMEDeviceModel unBindDeviceWithDeviceModel:model startBlock:^{
            NSLog(@"Start unbinding...");
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Loading" hideAfterDelay:10];
            });
        } successBlock:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            });
            NSLog(@"unbind success = %@", responseObject);
            
            [self.myDevicesArray removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
            
        } failBlock:^(NSError *error) {
            NSLog(@"unbind failed = %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            });
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
    
    EHOMEDeviceModel *device = self.myDevicesArray[indexPath.section];
    
    NSString *title = @"Alert";
    NSString *message = @"Edit your device's name here.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Please key device name here...";
        textField.text = device.device.name;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        [EHOMEDeviceModel updateDeviceNameWithDeviceModel:device name:name startBlock:^{
            NSLog(@"Editting device name...");
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Loading" hideAfterDelay:10];
            });
        } successBlock:^(id responseObject) {
            NSLog(@"Edit device name success = %@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            });
            device.device.name = name;
            [self.myDevicesArray replaceObjectAtIndex:indexPath.section withObject:device];
            [self.tableView reloadData];
            
        } failBlock:^(NSError *error) {
            NSLog(@"Edit device name failed = %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            });
        }];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(void)switchDeviceStatusSuccessWithStatus:(BOOL)isOn indexPath:(NSIndexPath *)indexPath{
    
    EHOMEDeviceModel *model = self.myDevicesArray[indexPath.section];
    model.functionValuesMap.power = isOn;
    [self.myDevicesArray replaceObjectAtIndex:indexPath.section withObject:model];
    
}





-(void)addDeviceAction{
    EHOMEAddDeviceTableViewController *addDeviceVC = [[EHOMEAddDeviceTableViewController alloc] initWithNibName:@"EHOMEAddDeviceTableViewController" bundle:nil];
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}


@end
