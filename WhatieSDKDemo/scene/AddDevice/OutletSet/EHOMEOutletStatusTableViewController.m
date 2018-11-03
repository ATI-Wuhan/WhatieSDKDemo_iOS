//
//  EHOMEOutletStatusTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/26.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEOutletStatusTableViewController.h"
#import "EHOMEIntelligentSettingTableViewController.h"

@interface EHOMEOutletStatusTableViewController ()
@property (nonatomic, assign) BOOL isOn;
@end

@implementation EHOMEOutletStatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"on-off", nil);
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(DoneAddDevice)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    if(self.isEditAction){
        if([[self.dpsDIC allKeys] containsObject:@"lightMode"]){
            if([[self.dpsDIC allKeys] containsObject:@"status"]){
                self.isOn = ([[self.dpsDIC objectForKey:@"status"] isEqualToString:@"true"]) ? YES : NO;
            }else{
                self.isOn = YES;
            }
            
        }else{
            self.isOn = [[[self.dpsDIC allValues] firstObject] boolValue];
        }
        
    }else{
        self.isOn = YES;
        
    }
    
}

-(void)DoneAddDevice{
    if(self.isEditAction){
        
        NSDictionary *DpsDic;
        if([[self.dpsDIC allKeys] containsObject:@"lightMode"]){
            NSString *lightStatus = (self.isOn == YES) ? @"true" : @"false";
            DpsDic = @{@"dps":@{@"lightMode":@(4),
                                @"status": lightStatus
                                }
                       };
        }else{
            DpsDic = @{@"dps":@{@"1":@(self.isOn),
                                @"2":@(self.isOn)
                                }
                       };
        }
        
        NSNotification *notification =[NSNotification notificationWithName:@"EditSceneOutletToIntelligent" object:nil userInfo:DpsDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"要编辑的设备 =%@",DpsDic);
    }else{
        EHOMEDeviceModel *model = [self.selectDevice copy];
        if(model.device.product.productType == 2){
            NSString *lightStatus = (self.isOn == YES) ? @"true" : @"false";
            model.sceneActionDic = @{@"lightMode":@(4),
                                     @"status": lightStatus
                                     };
        }else if(model.device.product.productType == 3){
            model.sceneActionDic = @{@"1":@(self.isOn),
                                     @"2":@(self.isOn)
                                     };
        }
        
        model.sceneDeviceId = -1;
        
        NSDictionary *dic2 = @{@"deviceInfo":@{@"dps":model.sceneActionDic,
                                              @"deviceId":@(model.device.id),
                                              @"deviceName":model.device.name,
                                              @"deviceRoom":model.roomName,
                                              @"deviceImage":model.device.product.picture.path,
                                              @"deviceStatus":model.device.status,
                                              @"sceneDeviceId":@(model.sceneDeviceId)
                                              }
                              };
        NSNotification *notification =[NSNotification notificationWithName:@"AddSceneOutletToIntelligent" object:nil userInfo:dic2];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"要添加的设备 =%@",dic2);
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[EHOMEIntelligentSettingTableViewController class]]) {
            EHOMEIntelligentSettingTableViewController *setController =(EHOMEIntelligentSettingTableViewController *)controller;
            [self.navigationController popToViewController:setController animated:YES];
        }
    }
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = @[NSLocalizedString(@"Turn On", nil),NSLocalizedString(@"Turn Off", nil)][indexPath.row];
    
    if (self.isOn) {
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor THEMECOLOR];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = [UIColor THEMECOLOR];
        }else{
            cell.textLabel.textColor = [UIColor darkTextColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor darkTextColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.textLabel.textColor = [UIColor THEMECOLOR];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = [UIColor THEMECOLOR];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        self.isOn = YES;
    }else{
        self.isOn = NO;
    }
    
    
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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

@end
