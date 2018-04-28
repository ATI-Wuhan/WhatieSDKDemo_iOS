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
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Update Login Password";
            }
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
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"Update Login Password");
            [self updateLoginPassword];
        }
    }
    
    if (indexPath.section == 2) {
        [EHOMEUserModel logoutWithStartBlock:^{
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

-(void)updateLoginPassword{
    NSString *title = @"Login Password";
    NSString *message = @"Update your login password with your old password.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Please key your old password";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Please key your new password";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ;
        
        NSString *oldPasswordMD5 = [EHOMEExtensions MD5EncryptedWith:[[alertController textFields] firstObject].text];
        NSString *newPasswordMD5 = [EHOMEExtensions MD5EncryptedWith:[[alertController textFields] lastObject].text];
        
        [EHOMEUserModel updateLoginPasswordOldPasswordMD5:oldPasswordMD5 newPasswordMD5:newPasswordMD5 startBlock:^{
            NSLog(@"Start Updating Login Password");
        } successBlock:^(id responseObject) {
            NSLog(@"Update Login Password Success = %@", responseObject);
        } failBlock:^(NSError *error) {
            NSLog(@"Update Login Password Failed = %@", error);
        }];
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
