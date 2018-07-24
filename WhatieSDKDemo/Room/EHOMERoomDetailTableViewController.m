//
//  EHOMERoomDetailTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/10.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define DeviceCellId @"EHOMEHomeTableViewCell"
#import "EHOMERoomDetailTableViewController.h"
#import "EHOMEHomeTableViewCell.h"
#import "EHOMEOutletDetailViewController.h"
#import "EHOMERGBLightViewController.h"
#import "EHOMEBackgroundViewController.h"

@interface EHOMERoomDetailTableViewController ()
@property (nonatomic, strong) NSArray *roomdevices;
@property (nonatomic, strong)UIImageView *groundView;
@end

@implementation EHOMERoomDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.roomModel.room.name;
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Edit", @"Device", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editAct)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self initTableview];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadData) name: EHOMEUserNotificationDeviceArrayChanged object:nil];
}

-(void)initTableview{
    
    self.groundView = [[UIImageView alloc] init];
    [self.groundView sd_setImageWithURL:[NSURL URLWithString:self.roomModel.room.background.path] placeholderImage:nil];
    self.groundView.contentMode = UIViewContentModeScaleToFill;
    self.tableView.backgroundView = self.groundView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEHomeTableViewCell" bundle:nil] forCellReuseIdentifier:DeviceCellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf PullDownRefresh];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)editAct{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Edit", @"Device", nil) message:NSLocalizedStringFromTable(@"inforoom", @"Room", nil) preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Edit Name", @"Room", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self updateRoomName];

    }]];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Change Background", @"Room", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EHOMEBackgroundViewController *vc = [[EHOMEBackgroundViewController alloc]init];
        vc.tag=0;
        vc.roommodel=self.roomModel;

        __weak typeof(self) weakSelf = self;
        [vc setChangePictureBlock:^(EHOMEBackgroundModel *model) {
            weakSelf.roomModel.room.background.path=model.file.path;
            [weakSelf.groundView sd_setImageWithURL:[NSURL URLWithString:model.file.path] placeholderImage:[UIImage imageNamed:@""]];
            weakSelf.roomBgBlock(model.file.path);
        }];
        [self.navigationController pushViewController:vc animated:YES];

    }]];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Delete Room", @"profile", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击删除房间");
        [self.roomModel removeRoomSuccess:^(id responseObject) {
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Delete room successfully", @"Room", nil) hideAfterDelay:1];
            self.deleteBlock(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"删除家庭失败！=%@",error);
            [HUDHelper addHUDInView:sharedKeyWindow
                               text:error.domain
                     hideAfterDelay:1];
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    UIPopoverPresentationController *popover = alert.popoverPresentationController;

    if (popover) {

        popover.sourceView = self.view;
        popover.sourceRect = CGRectMake(0, DEVICE_H, DEVICE_W, DEVICE_H);
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)updateRoomName{
    NSString *title = NSLocalizedStringFromTable(@"Update Roomname", @"Room", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = self.roomModel.room.name;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating room name", @"Room", nil) hideAfterDelay:10];
            
            [self.roomModel updateRoomName:name success:^(id responseObject) {
                NSLog(@"update room name success. res = %@", responseObject);
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"update room name success", @"Room", nil) hideAfterDelay:1.0];
                
                self.roomModel.room.name = name;
                self.title = name;
                self.roomNameBlock(name);
                
                [self.tableView reloadData];
            } failure:^(NSError *error) {
                NSLog(@"update room name failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
            }];
            
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"please enter name", @"Info", nil) hideAfterDelay:1.0];
        }
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)PullDownRefresh{
    [self.roomModel syncDeviceByRoomSuccess:^(id responseObject) {
        self.roomdevices = responseObject;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

-(void) ReloadData {
    //可以在这里刷新UI
    
    NSLog(@"[EHOMEUserModel shareInstance].deviceArray 有变更, 当前线程 = %@", [NSThread currentThread]);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.roomdevices.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceCellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DeviceCellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.deviceModel = self.roomdevices[indexPath.section];
    
    return cell;
}

#pragma mark - Table view delegate

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.roomdevices.count > 0) {
        EHOMEDeviceModel *model = self.roomdevices[indexPath.section];
        
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
                    
                    self.changeAccountBlock(YES);
                    
                    NSMutableArray *currentArray = [NSMutableArray arrayWithArray:self.roomdevices];
                    [currentArray removeObject:model];
                    self.roomdevices = currentArray;
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
    
    return YES;
    
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
    
    EHOMEDeviceModel *device = self.roomdevices[indexPath.section];
    
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
    EHOMEDeviceModel *device = self.roomdevices[indexPath.section];
    
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

@end
