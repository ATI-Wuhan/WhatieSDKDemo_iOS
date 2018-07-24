//
//  EHOMEProfileInfoTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/26.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define cellId @"defaultValueCell"
#define avatarCellId @"EHOMEProfileInfoTableViewCell"

#import "EHOMEProfileInfoTableViewController.h"
#import "EHOMEProfileInfoTableViewCell.h"
#import "EHOMEUpdatePasswordVC.h"
#import "ViewController.h"

@interface EHOMEProfileInfoTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation EHOMEProfileInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEProfileInfoTableViewCell" bundle:nil] forCellReuseIdentifier:avatarCellId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    if (indexPath.section == 0) {
        EHOMEProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:avatarCellId];
        
        if (!cell) {
            cell = [[EHOMEProfileInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:avatarCellId];
        }
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[EHOMEUserModel shareInstance].portraitThumb.path]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterHeadPortrait:)];
        cell.avatarImageView.userInteractionEnabled = YES;
        [cell.avatarImageView addGestureRecognizer:singleTap];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        
        if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedStringFromTable(@"Name", @"Info", nil);
                cell.detailTextLabel.text = [EHOMEUserModel shareInstance].name;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.textLabel.text = NSLocalizedStringFromTable(@"Email", @"Info", nil);
                cell.detailTextLabel.text = [EHOMEUserModel shareInstance].email;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section == 2){
            cell.textLabel.text = NSLocalizedStringFromTable(@"Update Login Password", @"Info", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = NSLocalizedStringFromTable(@"Logout", @"Info", nil);
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"update name");
        [self updateName];
    }
    
    if (indexPath.section == 2) {
        NSLog(@"update login password");
        //[self updateLoginPassword];
        EHOMEUpdatePasswordVC *vc=[[EHOMEUpdatePasswordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 3) {
        NSLog(@"Logout");
        [self loginOut];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 60.0;
    }else{
        return 10.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture{
    
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"choose photo", @"Info", nil) message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"From the album", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Photograph", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//PickerImage完成后的代理方法，提交头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if (newPhoto) {
        NSDictionary *dic = @{@"customerId":@([EHOMEUserModel shareInstance].id)};
        
        NSString *url = @"https://files.whatie.net/server/server/customer/updateCustomerPortrait";
        
        NSLog(@"开始上传头像");
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"uploading...", @"Info", nil) hideAfterDelay:10];
        
        [PPNetworkHelper uploadImagesWithURL:url parameters:dic name:@"portrait" images:@[newPhoto] fileNames:nil imageScale:1 imageType:nil progress:^(NSProgress *progress) {
            
        } success:^(id responseObject) {
            NSLog(@"上传成功 = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            
            NSDictionary* userDic =[responseObject objectForKey:@"value"];
            [EHOMEUserModel setCurrentUserWithUserModel:[EHOMEUserModel mj_objectWithKeyValues:userDic]];
            [EHOMEUserModel shareInstance].portraitThumb.path = [EHOMEUserModel getCurrentUser].portraitThumb.path;
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"上传失败 = %@",error.domain);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)updateName{
    NSString *title = NSLocalizedStringFromTable(@"Update Nickname", @"Info", nil);
    NSString *message = NSLocalizedStringFromTable(@"Update your nickname", @"Info", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [EHOMEUserModel shareInstance].name;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating user name", @"Info", nil) hideAfterDelay:10];
            
            [[EHOMEUserModel shareInstance] updateNickname:name success:^(id responseObject) {
                NSLog(@"update user name success. res = %@", responseObject);
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"update nickname success", @"Info", nil) hideAfterDelay:1.0];
                
                [self.tableView reloadData];
            } failure:^(NSError *error) {
                NSLog(@"update user name failed. error = %@", error);
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

-(void)loginOut{
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"logout...", @"Info", nil) hideAfterDelay:15];
    
    [[EHOMEUserModel shareInstance] loginOut:^(id responseObject) {
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"logout success", @"Info", nil) hideAfterDelay:1.0];
        
        NSLog(@"logout success = %@", responseObject);
        
        [EHOMEUserModel removeCurrentUser];
        [[EHOMEUserModel  shareInstance] removeCurrentHome];
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
