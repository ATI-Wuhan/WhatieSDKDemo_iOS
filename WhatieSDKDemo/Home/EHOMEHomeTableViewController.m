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
#import "EHOMEHomeListTableViewController.h"

@interface EHOMEHomeTableViewController ()<addDeviceDelegate>

@property (nonatomic, strong) NSArray *devices;

@end

@implementation EHOMEHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedStringFromTable(@"Home", @"Home", nil);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *light = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"switchHomeIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoHomeListPage)];
    self.navigationItem.leftBarButtonItem = light;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addDeviceAction)];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    [self initTableView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationDeviceArrayChanged object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoHomeListPage{
    
    EHOMEHomeListTableViewController *homeListVC = [[EHOMEHomeListTableViewController alloc] initWithNibName:@"EHOMEHomeListTableViewController" bundle:nil];
    homeListVC.isEditHomes = YES;
    
    homeListVC.selectHomeBlock = ^(EHOMEHomeModel *home) {
        [self pullDownRefresh];
    };
    
    [self.navigationController pushViewController:homeListVC animated:YES];
}

-(void)initTableView{
    
//    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeBackground"]];
    self.tableView.backgroundColor =RGB(240, 240, 240);
    
    
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

    NSLog(@"[EHOMEUserModel shareInstance].deviceArray 有变更, 当前线程 = %@", [NSThread currentThread]);
    
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)beginPullDownRefresh{
    [self.tableView.mj_header beginRefreshing];
}

-(void)pullDownRefresh{
    
    //syncDeviceWithCloud without Home
    
//    [[EHOMEUserModel shareInstance] syncDeviceWithCloud:^(id responseObject) {
//        NSLog(@"Get my devices successful : %@", responseObject);
//
//        for (EHOMEDeviceModel *device in responseObject) {
//            NSLog(@"device version = %@", device.device.version.version);
//        }
//
//
//        if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
//
//            NSLog(@"没有设备");
//        }
//
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"Get my devices failed : %@", error);
//
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView reloadData];
//    }];
    
    
    
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        
        EHOMEHomeModel *home = responseObject;
        NSLog(@"Get current home success.home = %d", home.id);
        self.navigationItem.title = home.name;
        
        [home syncDeviceByHomeSuccess:^(id responseObject) {
            self.devices = responseObject;
            NSLog(@"Get devices success.home = %@", self.devices);

            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];

    } failure:^(NSError *error) {
        NSLog(@"Get current home failed.error = %@", error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
//        return 1;
//    }else{
//        return [EHOMEUserModel shareInstance].deviceArray.count;
//    }
    
    if (self.devices.count == 0) {
        return 1;
    }else{
        return self.devices.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
//        EHOMEHomeEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCellId];
//
//        if (!cell) {
//            cell = [[EHOMEHomeEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellId];
//        }
//
//        cell.delegate = self;
//
//        return cell;
//    }else{
//        EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
//
//        if (!cell) {
//            cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        }
//
//        cell.deviceModel = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
//
//        return cell;
//    }


    if (self.devices.count == 0) {
        EHOMEHomeEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCellId];
        
        if (!cell) {
            cell = [[EHOMEHomeEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellId];
        }
        
        cell.delegate = self;
        
        return cell;
    }else{
        EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.deviceModel = self.devices[indexPath.section];
        
        return cell;
    }
}





#pragma mark - Table view delegate

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([EHOMEUserModel shareInstance].deviceArray.count > 0) {
//        EHOMEDeviceModel *model = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];

    if (self.devices.count > 0) {
        EHOMEDeviceModel *model = self.devices[indexPath.section];
        
        NSString *title = NSLocalizedStringFromTable(@"Remove", @"Profile", nil);
        
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Remove Device", @"Device", nil) message:NSLocalizedStringFromTable(@"unsure remove", @"Device", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Remove", @"Profile", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Removing", @"Device", nil) hideAfterDelay:10];
                
                [model removeDevice:^(id responseObject) {
                    
                    [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                    [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Remove device success", @"Device", nil) hideAfterDelay:1.0];
                    
                    NSLog(@"remove success = %@", responseObject);
                    
                    NSMutableArray *currentArray = [NSMutableArray arrayWithArray:self.devices];
                    [currentArray removeObject:model];
                    self.devices = currentArray;
                    [self.tableView reloadData];

                } failure:^(NSError *error) {
                    NSLog(@"remove failed = %@", error);
                    [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                    [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
                }];
            }];
            
            [alertView addAction:cancel];
            [alertView addAction:ok];
            
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        deleteRowAction.backgroundColor =RGB(255, 56, 38);
        
        UITableViewRowAction *editNameRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedStringFromTable(@"ReName", @"Device", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [self editDeviceNameWithIndexPath:indexPath];
            
        }];
        editNameRowAction.backgroundColor = RGB(0, 162, 199);
        
        UITableViewRowAction *shareRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedStringFromTable(@"Share", @"Device", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self shareDevice:model];
        }];
        shareRowAction.backgroundColor = RGB(0, 199, 164);
        
        return @[deleteRowAction, editNameRowAction, shareRowAction];
    }else{
        return nil;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
//        return NO;
//    }else{
//        return YES;
//    }

    if (self.devices.count == 0) {
        return NO;
    }else{
        return YES;
    }
    
}

-(void)shareDevice:(EHOMEDeviceModel *)device{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Device", nil) message:NSLocalizedStringFromTable(@"share by email", @"Device", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"friends email", @"Device", nil);
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        
        NSString *email = [alertController.textFields firstObject].text;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Sharing", @"Device", nil) hideAfterDelay:10];
        
        [device shareDeviceByEmail:email success:^(id responseObject) {
            NSLog(@"share device success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Share success", @"Device", nil) hideAfterDelay:1.5];
            
        } failure:^(NSError *error) {
            NSLog(@"share device failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)editDeviceNameWithIndexPath:(NSIndexPath *)indexPath{
    
//    EHOMEDeviceModel *device = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];

    EHOMEDeviceModel *device = self.devices[indexPath.section];
    
    NSString *title = NSLocalizedStringFromTable(@"Alert", @"Device", nil);
    NSString *message = NSLocalizedStringFromTable(@"update device name", @"Device", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"device name";
        textField.text = device.device.name;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating device name", @"Device", nil) hideAfterDelay:10];
        
        [device updateDeviceName:name success:^(id responseObject) {
            NSLog(@"update device name success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"update devName success", @"Device", nil) hideAfterDelay:1.0];
            
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
    
//    if ([EHOMEUserModel shareInstance].deviceArray.count > 0) {
//
//        EHOMEDeviceModel *device = [EHOMEUserModel shareInstance].deviceArray[indexPath.section];
//
//
//        NSArray *products = @[@"RgbLight",@"Plug"];
//
//        NSInteger index = [products indexOfObject:device.productName];
//
//        switch (index) {
//            case 0:{
//                NSLog(@"Clicked RgbLight");
//
//                EHOMERGBLightViewController *lightVC = [[EHOMERGBLightViewController alloc] initWithNibName:@"EHOMERGBLightViewController" bundle:nil];
//
//                lightVC.device = device;
//
//                [self.navigationController pushViewController:lightVC animated:YES];
//            }
//                break;
//
//            case 1:{
//                NSLog(@"Clicked Plug");
//
//                EHOMEOutletDetailViewController *outletVC = [[EHOMEOutletDetailViewController alloc] initWithNibName:@"EHOMEOutletDetailViewController" bundle:nil];
//                outletVC.device = device;
//
//                [self.navigationController pushViewController:outletVC animated:YES];
//            }
//                break;
//
//            default:
//                break;
//        }
//    }
    
    
    
    if (self.devices.count > 0) {
        
        EHOMEDeviceModel *device = self.devices[indexPath.section];
        
        
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
//        return tableView.frame.size.height;
//    }else{
//        return 120.0;
//    }

    if (self.devices.count == 0) {
        return tableView.frame.size.height;
    }else{
        return 120.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
//        return 0.001;
//    }else{
//        return 8.0;
//    }
    
    if (self.devices.count == 0) {
        return 0.001;
    }else{
        return 8.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if ([EHOMEUserModel shareInstance].deviceArray.count == 0) {
//        return 0.001;
//    }else{
//        return 2.0;
//    }

    if (self.devices.count == 0) {
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


#pragma MARK- addDeviceDelegate

- (void)gotoAddDevicePage{
    [self addDeviceAction];
}



@end
