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
#import "EHOMESharedDeviceTableViewController.h"
#import "EHOMEFeedbackTableViewController.h"

@interface EHOMEProfileTableViewController ()

@end

@implementation EHOMEProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EHOMEProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellId];
        
        if (!cell) {
            cell = [[EHOMEProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCellId];
        }
        
        cell.userModel = [EHOMEUserModel shareInstance];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        if (indexPath.section == 1) {
            cell.textLabel.text = @"Update Login Password";
        }
        
        if (indexPath.section == 2) {
            cell.textLabel.text = @"Received Shared Devices";
        }
        
        if (indexPath.section == 3) {
            cell.textLabel.text = @"Feedback";
        }
        
        if (indexPath.section == 4) {
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}



// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        NSLog(@"Update Nickname");
        
        [self updateNickName];
    }
    
    if (indexPath.section == 1) {
        NSLog(@"Update Login Password");
        [self updateLoginPassword];
    }
    
    if (indexPath.section == 2) {
        NSLog(@"received shared devices");
        EHOMESharedDeviceTableViewController *sharedDeviceVC = [[EHOMESharedDeviceTableViewController alloc] initWithNibName:@"EHOMESharedDeviceTableViewController" bundle:nil];
        [self.navigationController pushViewController:sharedDeviceVC animated:YES];
    }
    
    if (indexPath.section == 3) {
        NSLog(@"feedback");
        EHOMEFeedbackTableViewController *feedbackVC = [[EHOMEFeedbackTableViewController alloc] initWithNibName:@"EHOMEFeedbackTableViewController" bundle:nil];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    
    if (indexPath.section == 4) {
        [self loginOut];
    }
}

-(void)updateNickName{
    NSString *title = @"Update Nickname";
    NSString *message = @"Update your nickname";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Please enter nickname";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"updating name" hideAfterDelay:10];
            
            [[EHOMEUserModel shareInstance] updateNickname:name success:^(id responseObject) {
                NSLog(@"update nickname success. res = %@", responseObject);
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:@"update nickname success" hideAfterDelay:1.0];
                
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                NSLog(@"update nickname failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
            }];
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:@"please enter name" hideAfterDelay:1.0];
        }
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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

        NSString *oldPassword = [[alertController textFields] firstObject].text;
        NSString *newPassword = [[alertController textFields] lastObject].text;
        NSString *email = [EHOMEUserModel shareInstance].email;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"updating password" hideAfterDelay:10];
        
        [[EHOMEUserModel shareInstance] resetPasswordByOldPassword:oldPassword newPassword:newPassword email:email success:^(id responseObject) {
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:@"update password success" hideAfterDelay:1.0];
            NSLog(@"Update Login Password Success = %@", responseObject);
        } failure:^(NSError *error) {
            NSLog(@"Update Login Password Failed = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)loginOut{
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"logout..." hideAfterDelay:15];
    
    [[EHOMEUserModel shareInstance] loginOut:^(id responseObject) {
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:@"logout success" hideAfterDelay:1.0];
        
        NSLog(@"logout success = %@", responseObject);
        
        [EHOMEUserModel removeCurrentUser];
        [[EHOMEMQTTClientManager shareInstance] close];
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:loginVC animated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"logout failed = %@", error);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        
        [EHOMEUserModel removeCurrentUser];
        [[EHOMEMQTTClientManager shareInstance] close];
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
}



@end
