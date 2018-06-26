//
//  EHOMEHomeTableViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define cellId @"EHOMEHomeTableViewCell"
#define emptyCellId @"EHOMEHomeEmptyTableViewCell"

#import "EHOMEHomeTableViewController.h"
#import "EHOMEHomeTableViewCell.h"
#import "EHOMEHomeEmptyTableViewCell.h"
#import "EHOMEAddDeviceTableViewController.h"
#import "EHOMEQRCodeViewController.h"
#import "EHOMEScanViewController.h"
#import "EHOMEOutletDetailViewController.h"
#import "EHOMERGBLightViewController.h"

@interface EHOMEHomeTableViewController ()

@end

@implementation EHOMEHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Home";
    
//    UIBarButtonItem *light = [[UIBarButtonItem alloc] initWithTitle:@"light" style:UIBarButtonItemStylePlain target:self action:@selector(gotoLightPage)];
//    self.navigationItem.leftBarButtonItem = light;
    
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

-(void)gotoLightPage{
    
    EHOMERGBLightViewController *light = [[EHOMERGBLightViewController alloc] initWithNibName:@"EHOMERGBLightViewController" bundle:nil];
    [self.navigationController pushViewController:light animated:YES];
}

-(void)initTableView{
    
    self.tableView.rowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEHomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEHomeEmptyTableViewCell" bundle:nil] forCellReuseIdentifier:emptyCellId];
    
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
    
    for (EHOMEDeviceModel *model in [EHOMEUserModel shareInstance].deviceArray) {
        NSLog(@"变更后的设备model = %@", model.functionValuesMap.mj_keyValues);
    }
    
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
        
        for (EHOMEDeviceModel *device in responseObject) {
            NSLog(@"device version = %@", device.device.version.version);
        }

        
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
    
    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
        return 1;
    }else{
        return [EHOMEUserModel shareInstance].deviceArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
        EHOMEHomeEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCellId];
        
        if (!cell) {
            cell = [[EHOMEHomeEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellId];
        }
        
        return cell;
    }else{
        EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.deviceModel = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
        
        return cell;
    }
}





#pragma mark - Table view delegate

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([EHOMEUserModel shareInstance].deviceArray.count > 0) {
        EHOMEDeviceModel *model = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
        
        NSString *title = @"Remove";
        
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Removing" hideAfterDelay:10];
            
            [model removeDevice:^(id responseObject) {
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:@"Remove device success" hideAfterDelay:1.0];
                
                NSLog(@"unbind success = %@", responseObject);
                
                NSMutableArray *temp = [NSMutableArray arrayWithArray:[EHOMEUserModel shareInstance].deviceArray];
                
                [temp removeObject:model];
                
                [EHOMEUserModel shareInstance].deviceArray = temp;
                
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                NSLog(@"unbind failed = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
            }];
            
        }];
        
        UITableViewRowAction *editNameRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Edit Name" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [self editDeviceNameWithIndexPath:indexPath];
            
        }];
        editNameRowAction.backgroundColor = [UIColor blueColor];
        
        UITableViewRowAction *shareRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Share Device" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self shareDevice:model];
        }];
        shareRowAction.backgroundColor = [UIColor greenColor];
        
        return @[deleteRowAction, editNameRowAction, shareRowAction];
    }else{
        return nil;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
        return NO;
    }else{
        return YES;
    }
}

-(void)shareDevice:(EHOMEDeviceModel *)device{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"share device to your friend by email." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"your friends email...";
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        
        NSString *email = [alertController.textFields firstObject].text;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Sharing" hideAfterDelay:10];
        
        [device shareDeviceByEmail:email success:^(id responseObject) {
            NSLog(@"share device success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:@"Share device success." hideAfterDelay:1.5];
            
        } failure:^(NSError *error) {
            NSLog(@"share device failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"Updating name" hideAfterDelay:10];
        
        [device updateDeviceName:name success:^(id responseObject) {
            NSLog(@"update device name success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:@"update name success" hideAfterDelay:1.0];
            
            device.device.name = name;
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[EHOMEUserModel shareInstance].deviceArray];
            [tempArray replaceObjectAtIndex:indexPath.section withObject:device];
            [EHOMEUserModel shareInstance].deviceArray = tempArray;
            [self.tableView reloadData];

        } failure:^(NSError *error) {
            NSLog(@"update device name failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([EHOMEUserModel shareInstance].deviceArray.count > 0) {
        
        EHOMEDeviceModel *device = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
        
        
        NSArray *products = @[@"RgbLight",@"Plug"];
        
        NSInteger index = [products indexOfObject:device.productName];
        
        switch (index) {
            case 0:{
                NSLog(@"Clicked RgbLight");
                
                EHOMERGBLightViewController *lightVC = [[EHOMERGBLightViewController alloc] initWithNibName:@"EHOMERGBLightViewController" bundle:nil];
                
                lightVC.device = device;
                
                [self.navigationController pushViewController:lightVC animated:YES];
            }
                break;
                
            case 1:{
                NSLog(@"Clicked Plug");
                
                EHOMEOutletDetailViewController *outletVC = [[EHOMEOutletDetailViewController alloc] initWithNibName:@"EHOMEOutletDetailViewController" bundle:nil];
                outletVC.device = device;
                
                [self.navigationController pushViewController:outletVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
        return 0.001;
    }else{
        return 8.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
        return 0.001;
    }else{
        return 2.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)addDeviceAction{
    EHOMEAddDeviceTableViewController *addDeviceVC = [[EHOMEAddDeviceTableViewController alloc] initWithNibName:@"EHOMEAddDeviceTableViewController" bundle:nil];
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}



@end
