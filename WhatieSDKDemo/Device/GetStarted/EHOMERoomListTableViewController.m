//
//  EHOMERoomListTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define CenterCellId @"EHOMEDefaultCenterTableViewCell"

#import "EHOMERoomListTableViewController.h"
#import "EHOMEDefaultCenterTableViewCell.h"
#import "EHOMEAddRoomTableViewController.h"

@interface EHOMERoomListTableViewController ()

@end

@implementation EHOMERoomListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Select Room", @"Room", nil);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEDefaultCenterTableViewCell" bundle:nil] forCellReuseIdentifier:CenterCellId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.ModelArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        static NSString *cellId = @"defaultCell";

        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }

        EHOMERoomModel *room = self.ModelArray[indexPath.row];
        cell.textLabel.text = room.room.name;
        
        if(room.room.id == self.selectedmodel.room.id){
            cell.textLabel.textColor = THEMECOLOR;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        return cell;
    }else{
        EHOMEDefaultCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CenterCellId];

        if (!cell) {
            cell = [[EHOMEDefaultCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CenterCellId];
        }
        cell.centerTitleLabel.text = @"Add New Room";
        cell.centerTitleLabel.textColor = THEMECOLOR;

        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        EHOMERoomModel *room = self.ModelArray[indexPath.row];
        self.selectedRoomBlock(room);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        EHOMEAddRoomTableViewController *addRoomVC = [[EHOMEAddRoomTableViewController alloc] initWithNibName:@"EHOMEAddRoomTableViewController" bundle:nil];
        
        __weak typeof(self) weakSelf = self;
        [addRoomVC setRefreshRLBlock:^(BOOL isRefresh) {
            [weakSelf pullRoomList];
        }];
        [self.navigationController pushViewController:addRoomVC animated:YES];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return NSLocalizedStringFromTable(@"ROOMS", @"Room", nil);
    }else{
        return NSLocalizedStringFromTable(@"NEW ROOM", @"Room", nil);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)pullRoomList{
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        
        EHOMEHomeModel *currenthome = responseObject;
        
        [currenthome syncRoomByHomeSuccess:^(id responseObject) {
            self.ModelArray = responseObject;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Get current home failed.error = %@", error);
    }];
}
@end
