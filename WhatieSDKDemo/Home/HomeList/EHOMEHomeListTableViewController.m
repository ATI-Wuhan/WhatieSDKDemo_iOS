//
//  EHOMEHomeListTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/3.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define centerCellId @"EHOMEDefaultCenterTableViewCell"

#import "EHOMEHomeListTableViewController.h"
#import "EHOMEDefaultCenterTableViewCell.h"
#import "EHOMEEditHomeListTableViewController.h"

@interface EHOMEHomeListTableViewController ()

@end

@implementation EHOMEHomeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Homes", @"Home", nil);
    
    if(self.isEditHomes){
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Edit", @"Device", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editHomesAction)];
        self.navigationItem.rightBarButtonItem = editItem;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEDefaultCenterTableViewCell" bundle:nil] forCellReuseIdentifier:centerCellId];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self syncHomeWithCloud];
    }];
    
    if ([EHOMEUserModel shareInstance].homeArray.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncHomeWithCloud) name:@"changeHomeName" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncHomeWithCloud) name:@"AddHomeSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncHomeWithCloud) name:@"tranferHome" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncHomeWithCloud) name:@"exitHome" object:nil];

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)syncHomeWithCloud{
    [[EHOMEUserModel shareInstance] syncHomeWithCloud:^(id responseObject) {
        NSLog(@"Home List = %@", responseObject);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        NSLog(@"Home List failed = %@", error);
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return [EHOMEUserModel shareInstance].homeArray.count;
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
        
        EHOMEHomeModel *home = [EHOMEUserModel shareInstance].homeArray[indexPath.row];
        cell.textLabel.text = home.name;
        
        if(self.isEditHomes){
            [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
                
                EHOMEHomeModel *model = responseObject;
                
                if (home.id == model.id) {
                    cell.textLabel.textColor = THEMECOLOR;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.tintColor = THEMECOLOR;
                }else{
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
            } failure:^(NSError *error) {
                
            }];
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }else{
        EHOMEDefaultCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellId];
        
        if (!cell) {
            cell = [[EHOMEDefaultCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:centerCellId];
        }
        
        cell.centerTitleLabel.text = NSLocalizedStringFromTable(@"Add New Home", @"Home", nil);
        cell.centerTitleLabel.textColor = THEMECOLOR;
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if(self.isEditHomes){
            EHOMEHomeModel *home = [EHOMEUserModel shareInstance].homeArray[indexPath.row];
            
            [[EHOMEUserModel shareInstance] setCurrentHome:home];
            
            [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
                EHOMEHomeModel *model =responseObject;
                NSLog(@"选中当前家庭的id = %d",model.id);
            } failure:^(NSError *error) {
                
            }];
            
            
            self.selectHomeBlock(home);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self addHomeAlert];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if ([EHOMEUserModel shareInstance].homeArray.count > 0) {
            return NSLocalizedStringFromTable(@"Homes", @"Home", nil);
        }else{
            return @"";
        }
    }else{
        return NSLocalizedStringFromTable(@"Add New Home", @"Home", nil);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if ([EHOMEUserModel shareInstance].homeArray.count > 0) {
            return 50;
        }else{
            return 0.001;
        }
    }else{
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(void)editHomesAction{
    EHOMEEditHomeListTableViewController *homeVC = [[EHOMEEditHomeListTableViewController alloc] initWithNibName:@"EHOMEEditHomeListTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:homeVC animated:YES];
}

-(void)addHomeAlert{
    NSString *title = NSLocalizedStringFromTable(@"Add Home", @"Home", nil);
    NSString *message = NSLocalizedStringFromTable(@"Please enter home name", @"Home", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"name", @"Home", nil);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Creating home", @"Home", nil) hideAfterDelay:10];
            
            [[EHOMEUserModel shareInstance] addNewHomeWithName:name success:^(id responseObject) {
                NSLog(@"add home success. res = %@", responseObject);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"add home success", @"Home", nil) hideAfterDelay:1.0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddHomeSuccess" object:nil userInfo:nil];
            } failure:^(NSError *error) {
                NSLog(@"add home failed. error = %@", error);
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

@end
