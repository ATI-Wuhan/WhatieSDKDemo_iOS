//
//  EHOMEEditHomeListTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/9.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEEditHomeListTableViewController.h"
#import "EHOMEDetailHomeTableViewController.h"

@interface EHOMEEditHomeListTableViewController ()

@end

@implementation EHOMEEditHomeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Homes", @"Home", nil);
    
    [self getHomeList];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(void)getHomeList{
    [[EHOMEUserModel shareInstance] syncHomeWithCloud:^(id responseObject) {
        NSLog(@"Home List = %@", responseObject);
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"Home List failed = %@", error);
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

    return [EHOMEUserModel shareInstance].homeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"defaultCell";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    EHOMEHomeModel *home = [EHOMEUserModel shareInstance].homeArray[indexPath.row];
    cell.textLabel.text = home.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHOMEDetailHomeTableViewController *detailViewController = [[EHOMEDetailHomeTableViewController alloc] initWithNibName:@"EHOMEDetailHomeTableViewController" bundle:nil];
    detailViewController.homeModel = [EHOMEUserModel shareInstance].homeArray[indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([EHOMEUserModel shareInstance].homeArray.count > 0) {
        return NSLocalizedStringFromTable(@"Homes", @"Home", nil);
    }else{
        return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([EHOMEUserModel shareInstance].homeArray.count > 0) {
        return 50;
    }else{
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

@end
