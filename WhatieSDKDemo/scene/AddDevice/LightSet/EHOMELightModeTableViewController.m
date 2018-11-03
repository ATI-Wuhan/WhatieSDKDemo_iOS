//
//  EHOMELightModeTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMELightModeTableViewController.h"
#import "EHOMEOutletStatusTableViewController.h"
#import "EHOMESetWhiteLightViewController.h"
#import "EHOMEWhiteLightViewController.h"
#import "EHOMESetRgbLightViewController.h"
#import "EHOMEStreamLightViewController.h"

@interface EHOMELightModeTableViewController ()

@end

@implementation EHOMELightModeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add Scene", nil);
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
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = @[NSLocalizedString(@"Switch", nil),NSLocalizedString(@"WhiteLight", nil),NSLocalizedString(@"ColorLight", nil),NSLocalizedString(@"StreamLight", nil)][indexPath.row];
    if(self.isEditLight){
        int LightMode = [[self.lighDps objectForKey:@"lightMode"] intValue];
        if(LightMode == 4){
            if(indexPath.row == 0){
                cell.textLabel.textColor = [UIColor THEMECOLOR];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.tintColor = [UIColor THEMECOLOR];
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            if(LightMode == 1){
                if(indexPath.row == 1){
                    cell.textLabel.textColor = [UIColor THEMECOLOR];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = [UIColor THEMECOLOR];
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else if(LightMode == 2){
                if(indexPath.row == 2){
                    cell.textLabel.textColor = [UIColor THEMECOLOR];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = [UIColor THEMECOLOR];
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else if(LightMode == 5){
                if(indexPath.row == 3){
                    cell.textLabel.textColor = [UIColor THEMECOLOR];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = [UIColor THEMECOLOR];
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){
        EHOMEOutletStatusTableViewController *vc = [[EHOMEOutletStatusTableViewController alloc] initWithNibName:@"EHOMEOutletStatusTableViewController" bundle:nil];
        if(self.isEditLight){
            vc.isEditAction = YES;
            vc.dpsDIC = self.lighDps;
        }else{
            vc.selectDevice = self.selectlight;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1){
//        EHOMESetWhiteLightViewController *WhiteLightvc = [[EHOMESetWhiteLightViewController alloc] initWithNibName:@"EHOMESetWhiteLightViewController" bundle:nil];
//        if(self.isEditLight){
//            WhiteLightvc.isEditWhiteLight = YES;
//        }else{
//            WhiteLightvc.whiteLight = self.selectlight;
//        }
        
        EHOMEWhiteLightViewController *whiteLightvc= [[EHOMEWhiteLightViewController alloc] initWithNibName:@"EHOMEWhiteLightViewController" bundle:nil];
        if(self.isEditLight){
            whiteLightvc.isEditWhiteLight = YES;
            whiteLightvc.deviceDps = self.lighDps;
        }else{
            whiteLightvc.whiteLight = self.selectlight;
        }
        [self.navigationController pushViewController:whiteLightvc animated:YES];
    }else if (indexPath.row == 2){
        EHOMESetRgbLightViewController *RgbLightvc= [[EHOMESetRgbLightViewController alloc] initWithNibName:@"EHOMESetRgbLightViewController" bundle:nil];
        if(self.isEditLight){
            RgbLightvc.isEditRgbLight = YES;
            RgbLightvc.devicedps = self.lighDps;
        }else{
            RgbLightvc.rgbLight = self.selectlight;
        }
        
        [self.navigationController pushViewController:RgbLightvc animated:YES];
    }else{
        EHOMEStreamLightViewController *StreamLightvc= [[EHOMEStreamLightViewController alloc] initWithNibName:@"EHOMEStreamLightViewController" bundle:nil];
        if(self.isEditLight){
            StreamLightvc.isEditStreamLight = YES;
            StreamLightvc.DeviceDps = self.lighDps;
        }else{
            StreamLightvc.streamLight = self.selectlight;
        }
        
        [self.navigationController pushViewController:StreamLightvc animated:YES];
    }
    
    //[tableView reloadData];
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
