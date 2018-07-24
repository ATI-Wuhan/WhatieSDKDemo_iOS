//
//  EHOMEAddDeviceTableViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/21.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define cellId @"AddDeviceCellID"

#import "EHOMEAddDeviceTableViewController.h"
#import "EHOMEConfirmWifiViewController.h"

@interface EHOMEAddDeviceTableViewController ()

@end

@implementation EHOMEAddDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedStringFromTable(@"Add Device", @"Device", nil);
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    self.tableView.rowHeight = 80.0;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"socket"];
        cell.textLabel.text = NSLocalizedStringFromTable(@"Outlets", @"Device", nil);
    }else{
        cell.imageView.image = [UIImage imageNamed:@"rgb_light"];
        cell.textLabel.text = NSLocalizedStringFromTable(@"RGB_Light", @"Device", nil);
    }

    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHOMEConfirmWifiViewController *confirmWifiVC = [[EHOMEConfirmWifiViewController alloc] initWithNibName:@"EHOMEConfirmWifiViewController" bundle:nil];
    
    [self.navigationController pushViewController:confirmWifiVC animated:YES];
}



@end
