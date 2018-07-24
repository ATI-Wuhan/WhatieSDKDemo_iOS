//
//  EHOMEProfileTableViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define profileCellId @"EHOMEProfileTableViewCell"
#define cellId @"EHOMEProfileMenuTableViewCell"

#import "EHOMEProfileTableViewController.h"
#import "EHOMEProfileTableViewCell.h"
#import "EHOMEProfileMenuTableViewCell.h"
#import "ViewController.h"
#import "EHOMESharedDeviceTableViewController.h"
#import "EHOMEFeedbackTableViewController.h"
#import "EHOMEProfileInfoTableViewController.h"
#import "EHOMEExperienceCenterViewController.h"
#import "EHOMEHomeListTableViewController.h"
#import "EHOMEMyDevicesTableViewController.h"
#import "EHOMESettingVC.h"
#import "EHOMEIntergrationVC.h"

@interface EHOMEProfileTableViewController ()

@end

@implementation EHOMEProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Profile", @"Profile", nil);
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoSettingsPage)];
    self.navigationItem.rightBarButtonItem = settingsItem;
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEProfileMenuTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = GREYCOLOR;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else{
        return 6;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EHOMEProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellId];
        
        if (!cell) {
            cell = [[EHOMEProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCellId];
        }
        
        cell.userModel = [EHOMEUserModel shareInstance];
        
        return cell;
    }else{
        EHOMEProfileMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
        if (!cell) {
            cell = [[EHOMEProfileMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        NSArray *titles = @[NSLocalizedStringFromTable(@"My Home", @"Profile", nil),NSLocalizedStringFromTable(@"My Devices", @"Profile", nil),NSLocalizedStringFromTable(@"Sharing", @"Profile", nil),NSLocalizedStringFromTable(@"Integration", @"Profile", nil),NSLocalizedStringFromTable(@"Experience", @"Profile", nil),NSLocalizedStringFromTable(@"Feedback", @"Profile", nil)];
        NSArray *images = @[@"profile_my_home",@"profile_my_devices",@"profile_sharing",@"profile_integration",@"profile_experience",@"profile_feedback"];
        
        cell.menuTitleLabel.text = titles[indexPath.row];
        cell.menuImageView.image = [UIImage imageNamed:images[indexPath.row]];
    
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }else{
        return 48;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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



// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        NSLog(@"go to Profile Info Page");
        EHOMEProfileInfoTableViewController *profileInfoVC = [[EHOMEProfileInfoTableViewController alloc] initWithNibName:@"EHOMEProfileInfoTableViewController" bundle:nil];
        [self.navigationController pushViewController:profileInfoVC animated:YES];
    }else{
        
        switch (indexPath.row) {
            case 0:{
                EHOMEHomeListTableViewController *homeListVC = [[EHOMEHomeListTableViewController alloc] initWithNibName:@"EHOMEHomeListTableViewController" bundle:nil];
                homeListVC.isEditHomes = NO;
                [self.navigationController pushViewController:homeListVC animated:YES];
            }
                break;
            case 1:{
                EHOMEMyDevicesTableViewController *myDevciesVC = [[EHOMEMyDevicesTableViewController alloc] initWithNibName:@"EHOMEMyDevicesTableViewController" bundle:nil];
                [self.navigationController pushViewController:myDevciesVC animated:YES];
            }
                break;
            case 2:{
                NSLog(@"received shared devices");
                EHOMESharedDeviceTableViewController *sharedDeviceVC = [[EHOMESharedDeviceTableViewController alloc] initWithNibName:@"EHOMESharedDeviceTableViewController" bundle:nil];
                [self.navigationController pushViewController:sharedDeviceVC animated:YES];
            }
                break;
            case 3:{
                NSLog(@"intergration");
                EHOMEIntergrationVC *IntergrationVC = [[EHOMEIntergrationVC alloc] init];
                [self.navigationController pushViewController:IntergrationVC animated:YES];
            }
                break;
            case 4:{
                NSLog(@"Experience Center");
                
                EHOMEExperienceCenterViewController *experienceVC = [[EHOMEExperienceCenterViewController alloc] initWithNibName:@"EHOMEExperienceCenterViewController" bundle:nil];
                [self.navigationController pushViewController:experienceVC animated:YES];
            }
                break;
            case 5:{
                NSLog(@"feedback");
                EHOMEFeedbackTableViewController *feedbackVC = [[EHOMEFeedbackTableViewController alloc] initWithNibName:@"EHOMEFeedbackTableViewController" bundle:nil];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)updateNickName{
    NSString *title = NSLocalizedStringFromTable(@"Update Nickname", @"Info", nil);
    NSString *message = NSLocalizedStringFromTable(@"Update your nickname", @"Info", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"Please enter nickname", @"Info", nil);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating user name", @"Info", nil) hideAfterDelay:10];
            
            [[EHOMEUserModel shareInstance] updateNickname:name success:^(id responseObject) {
                NSLog(@"update nickname success. res = %@", responseObject);
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"update nickname success", @"Info", nil) hideAfterDelay:1.0];
                
                [self.tableView reloadData];
                
            } failure:^(NSError *error) {
                NSLog(@"update nickname failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
            }];
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"please enter name", @"Info", nil) hideAfterDelay:1.0];
        }
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)updateLoginPassword{
    NSString *title = NSLocalizedStringFromTable(@"Login Password", @"Info", nil);
    NSString *message = NSLocalizedStringFromTable(@"Update your login password", @"Info", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"key old psw", @"Info", nil);
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"key new psw", @"Info", nil);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        NSString *oldPassword = [[alertController textFields] firstObject].text;
        NSString *newPassword = [[alertController textFields] lastObject].text;
        NSString *email = [EHOMEUserModel shareInstance].email;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating password", @"Info", nil) hideAfterDelay:10];
        
        [[EHOMEUserModel shareInstance] resetPasswordByOldPassword:oldPassword newPassword:newPassword email:email success:^(id responseObject) {
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"update password success", @"Info", nil) hideAfterDelay:1.0];
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


#pragma MARK - gotoPages

-(void)gotoSettingsPage{
    EHOMESettingVC *setvc=[[EHOMESettingVC alloc] init];
    [self.navigationController pushViewController:setvc animated:YES];
}



@end
