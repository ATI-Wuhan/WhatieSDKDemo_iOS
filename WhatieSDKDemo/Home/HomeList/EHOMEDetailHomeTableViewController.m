//
//  EHOMEDetailHomeTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/9.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define memberCellId @"EHOMEMemberCell"
#define centerCellId @"EHOMEDefaultCenterTableViewCell"

#import "EHOMEDetailHomeTableViewController.h"
#import "EHOMEMemberCell.h"
#import "EHOMEDefaultCenterTableViewCell.h"
#import "EHOMEFamilyViewController.h"
#import "EHOMEShareViewController.h"

@interface EHOMEDetailHomeTableViewController ()
@property (nonatomic, strong) NSMutableArray *homeMemberModelArray;
@property (nonatomic, strong) EHomeMemberModel *homeHostModel;//管理员
@property (nonatomic, strong) EHomeMemberModel *homeMemberModel;
@end

@implementation EHOMEDetailHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.homeModel.name;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEMemberCell" bundle:nil] forCellReuseIdentifier:memberCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEDefaultCenterTableViewCell" bundle:nil] forCellReuseIdentifier:centerCellId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMember) name:@"deleteMember" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMember) name:@"transferAdmin" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMember];
}

-(void)getMember{
    self.homeMemberModelArray = [NSMutableArray array];
    //获取家庭成员
    [self.homeModel getHomeMemberSuccess:^(id responseObject) {
        self.homeMemberModelArray = responseObject;
        
        for (EHomeMemberModel *model in self.homeMemberModelArray) {
            if(model.host){
                self.homeHostModel = model;
                NSLog(@"管理员的id = %d和家庭主人id = %d", self.homeHostModel.customer.id,[EHOMEUserModel shareInstance].id);
                break;
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"家庭成员列表数据请求失败 = %@", error);
        [self.tableView reloadData];
    }];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
        return 4;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==1){
        return self.homeMemberModelArray.count + 1;
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
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.homeModel.name;
        
        return cell;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == self.homeMemberModelArray.count) {
            //邀请家庭成员
            static NSString *cellId = @"addMemberCellId";
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.text = NSLocalizedStringFromTable(@"Invite member", @"Home", nil);
            cell.textLabel.textColor = [UIColor THEMECOLOR];
            
            return cell;
        }else{
            //成员列表
            EHOMEMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:memberCellId];
            if (!cell) {
                cell = [[EHOMEMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:memberCellId];
            }
            
            EHomeMemberModel *memberModel = self.homeMemberModelArray[indexPath.row];
            self.homeMemberModel = memberModel;
            
            cell.memberNameLabel.text=memberModel.customer.name;
            [cell.memberImageView sd_setImageWithURL:[NSURL URLWithString:memberModel.customer.portraitThumb.path] placeholderImage:[UIImage imageNamed:@"avatar"]];
            
            if (memberModel.host) {
                cell.memberTypeLabel.text=NSLocalizedStringFromTable(@"Administrator", @"Home", nil);
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                cell.memberTypeLabel.text=NSLocalizedStringFromTable(@"Member", @"Home", nil);
                if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
            }
            
            //非管理员不能进入成员详情
            if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
    }else{
        EHOMEDefaultCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellId];
        
        if (!cell) {
            cell = [[EHOMEDefaultCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:centerCellId];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
            if (indexPath.section ==2) {
                cell.centerTitleLabel.text = NSLocalizedStringFromTable(@"Transfer Home", @"Home", nil);
            }else{
                if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
                    cell.centerTitleLabel.text = NSLocalizedStringFromTable(@"Delete Home", @"Home", nil);
                }else{
                    cell.centerTitleLabel.text = NSLocalizedStringFromTable(@"Exit Home", @"Home", nil);
                }
                
            }
        }else{
            if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
                cell.centerTitleLabel.text = NSLocalizedStringFromTable(@"Delete Home", @"Home", nil);
            }else{
                cell.centerTitleLabel.text = NSLocalizedStringFromTable(@"Exit Home", @"Home", nil);
            }
        }
        
        cell.centerTitleLabel.textColor = [UIColor redColor];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self updateHomeName];
        
    }else if(indexPath.section==1){
        if(indexPath.row == self.homeMemberModelArray.count){
            //[self inviteMember];
            EHOMEShareViewController *shareVC = [[EHOMEShareViewController alloc] initWithNibName:@"EHOMEShareViewController" bundle:nil];
            shareVC.codeType = 1;
            shareVC.homeModel = self.homeModel;
            [self.navigationController pushViewController:shareVC animated:YES];
        }else{
            EHomeMemberModel *member = self.homeMemberModelArray[indexPath.row];
            if (member.host) {
                
            }else{
                if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
                    
                    EHOMEFamilyViewController *vc = [[EHOMEFamilyViewController alloc] initWithNibName:@"EHOMEFamilyViewController" bundle:nil];
                    vc.memberModel = member;
                    vc.homeModel = self.homeModel;
                    vc.hostId = self.homeHostModel.customer.id;
                    NSLog(@"传入的成员=%d  ，传入的hostid=%d, homeid=%d",vc.memberModel.customer.id,self.homeModel.id,self.homeModel.host.id);
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }else{
        if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
            if (indexPath.section == 2){
                [self transferHome];
            }else{
                [self exitHome];
            }
        }else{
            [self exitHome];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
        NSArray *titles=@[NSLocalizedStringFromTable(@"Home", @"Home", nil),
                          NSLocalizedStringFromTable(@"Family Member", @"Home", nil),
                          NSLocalizedStringFromTable(@"Transfer Home", @"Home", nil),
                          NSLocalizedStringFromTable(@"Delete Home Or Exit Home", @"Home", nil)];
        return titles[section];
    }else{
        
        NSArray *titles=@[NSLocalizedStringFromTable(@"Home", @"Home", nil),
                          NSLocalizedStringFromTable(@"Family Member", @"Home", nil),
                          NSLocalizedStringFromTable(@"Delete Home Or Exit Home", @"Home", nil)];
        return titles[section];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(void)updateHomeName{
    NSString *title = NSLocalizedStringFromTable(@"Update Homename", @"Home", nil);
    NSString *message = NSLocalizedStringFromTable(@"Update your home name", @"Home", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = self.homeModel.name;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating home name", @"Home", nil) hideAfterDelay:10];
            
            [self.homeModel updateHomeName:name success:^(id responseObject) {
                NSLog(@"update home name success. res = %@", responseObject);
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"update home success", @"Home", nil) hideAfterDelay:1.0];
                self.homeModel.name = name;
                
                NSNotification *notice = [NSNotification notificationWithName:@"changeHomeName" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
                
                [self.tableView reloadData];
            } failure:^(NSError *error) {
                NSLog(@"update home name failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper showErrorDomain:error];
            }];
            
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"please enter name", @"Info", nil) hideAfterDelay:1.0];
        }
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)inviteMember{
    NSString *title = NSLocalizedStringFromTable(@"Invitation", @"Home", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"inviting home member", @"Home", nil) hideAfterDelay:10];
            
            [self.homeModel inviteHomeMemberByEmail:name success:^(id responseObject) {
                NSLog(@"邀请成功");
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Invite successfully", @"Home", nil) hideAfterDelay:1];
                [self getMember];
            } failure:^(NSError *error) {
                NSLog(@"inviting home failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper showErrorDomain:error];
            }];
            
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil) hideAfterDelay:1.0];
        }
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)transferHome{
    
    if ([EHOMEUserModel shareInstance].id == self.homeHostModel.customer.id) {
        NSLog(@"转让家庭");
        EHOMEShareViewController *shareVC = [[EHOMEShareViewController alloc] initWithNibName:@"EHOMEShareViewController" bundle:nil];
        shareVC.codeType = 3;
        shareVC.homeModel = self.homeModel;
        [self.navigationController pushViewController:shareVC animated:YES];
//        NSString *title = NSLocalizedStringFromTable(@"Transfer", @"Home", nil);
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
//
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.placeholder = NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil);
//        }];
//
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            NSString *name = [[alertController textFields] firstObject].text;
//
//            if (name.length > 0) {
//                [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"transfering home", @"Home", nil) hideAfterDelay:10];
//
//                [self.homeModel transferHomeWithByEmail:name success:^(id responseObject) {
//                    NSLog(@"转让家庭成功");
//                    [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
//                    [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Tranfer home sucessfully", @"Home", nil) hideAfterDelay:1];
//
//                    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
//                        EHOMEHomeModel *home = responseObject;
//                        NSLog(@"要删除的家庭id=%d，当前家庭id=%d",self.homeModel.id,home.id);
//                        if(self.homeModel.id == home.id){
//                            [[EHOMEUserModel shareInstance] removeCurrentHome];
//                        }
//
//                    } failure:^(NSError *error) {
//                        NSLog(@"Get current home failed.error = %@", error);
//                    }];
//
//                    NSNotification *notice = [NSNotification notificationWithName:@"tranferHome" object:nil userInfo:nil];
//                    [[NSNotificationCenter defaultCenter] postNotification:notice];
//
//                    [self.navigationController popViewControllerAnimated:YES];
//                } failure:^(NSError *error) {
//                    NSLog(@"转让家庭失败. error = %@", error);
//                    [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
//                    [HUDHelper showErrorDomain:error];
//                }];
//
//            }else{
//                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil) hideAfterDelay:1.0];
//            }
//
//        }];
//
//        [alertController addAction:cancel];
//        [alertController addAction:action];
//
//        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        //删除家庭or退出家庭
        [self exitHome];
    }
}

-(void)exitHome{
    NSString *title;
    NSString *successStr;
    
    if([EHOMEUserModel shareInstance].id ==self.homeHostModel.customer.id){
        title = NSLocalizedStringFromTable(@"Delete Home", @"Home", nil);
        successStr = NSLocalizedStringFromTable(@"Delete home successfully", @"Home", nil);
    }else{
        title = NSLocalizedStringFromTable(@"Exit Home", @"Home", nil);
        successStr = NSLocalizedStringFromTable(@"Exit home successfully", @"Home", nil);
    }
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:NSLocalizedStringFromTable(@"unsure exit", @"Home", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"sure", @"Home", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if([EHOMEUserModel shareInstance].id ==self.homeHostModel.customer.id){
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"deleting", @"Home", nil) hideAfterDelay:10];
        }else{
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"exiting", @"Home", nil) hideAfterDelay:10];
        }
        
        [self.homeModel removeHome:^(id responseObject) {
            NSLog(@"delete success = %@", responseObject);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:successStr hideAfterDelay:1.0];
            
            //删除该家庭成功，从数据库中删除对应的家庭。
            [EHOMEDataStore removeHomeFromDB:self.homeModel];
            
            [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
                EHOMEHomeModel *home = responseObject;
                NSLog(@"要删除的家庭id=%d，当前家庭id=%d",self.homeModel.id,home.id);
                if(self.homeModel.id == home.id){
                    [[EHOMEUserModel shareInstance] removeCurrentHome];
                }
                
            } failure:^(NSError *error) {
                NSLog(@"Get current home failed.error = %@", error);
            }];
            
            NSNotification *notice = [NSNotification notificationWithName:@"exitHome" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            NSLog(@"退出家庭失败！=%@",error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
    }];
    
    [alertView addAction:cancel];
    [alertView addAction:ok];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

@end
