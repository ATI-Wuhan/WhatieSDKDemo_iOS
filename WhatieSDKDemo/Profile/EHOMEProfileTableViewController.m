//
//  EHOMEProfileTableViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define profileCellId @"EHOMEProfileTableViewCell"
#define cellId @"defaultCellId"

#import "EHOMEProfileTableViewController.h"
#import "EHOMEProfileTableViewCell.h"
#import "ViewController.h"

@interface EHOMEProfileTableViewController ()

@end

@implementation EHOMEProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEProfileTableViewCell" bundle:nil] forCellReuseIdentifier:profileCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return 3;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EHOMEProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellId];
        if (!cell) {
            cell = [[EHOMEProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCellId];
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        if (indexPath.section == 2) {
            cell.textLabel.text = @"Logout";
        }
    
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else{
        return 48;
    }
}



// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        [EHOMEUserModel logoutWithAccessId:AccessId accessKey:AccessKey startBlock:^{
            NSLog(@"logout...");
            
            
        } successBlock:^(id responseObject) {
            NSLog(@"logout success = %@", responseObject);
            
            [EHOMEUserModel removeCurrentUser];
            [[EHOMEMQTTClientManager shareInstance] close];
            
            UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        } failBlock:^(NSError *error) {
            NSLog(@"logout failed = %@", error);
            [EHOMEUserModel removeCurrentUser];
            [[EHOMEMQTTClientManager shareInstance] close];
            
            UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
    }
}



@end
