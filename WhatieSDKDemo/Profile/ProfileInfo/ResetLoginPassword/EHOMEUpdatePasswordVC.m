//
//  EHOMEUpdatePasswordVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/3.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEUpdatePasswordVC.h"
#import "ViewController.h"

@interface EHOMEUpdatePasswordVC ()
@property (weak, nonatomic) IBOutlet UIView *OldView;
@property (weak, nonatomic) IBOutlet UIView *NewView;
@property (weak, nonatomic) IBOutlet UIView *ComfirmView;


@property (weak, nonatomic) IBOutlet UITextField *OldPswTF;
@property (weak, nonatomic) IBOutlet UITextField *NewPswTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPswTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitAct:(id)sender;

@end

@implementation EHOMEUpdatePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"Update Login Password", @"Info", nil);
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.OldPswTF.placeholder=NSLocalizedStringFromTable(@"Old password", @"Info", nil);
    self.OldView.layer.masksToBounds = YES;
    self.OldView.layer.cornerRadius = 3.0;
    
    self.NewPswTF.placeholder=NSLocalizedStringFromTable(@"New password", @"Info", nil);
    self.NewView.layer.masksToBounds = YES;
    self.NewView.layer.cornerRadius = 3.0;
    
    self.confirmPswTF.placeholder=NSLocalizedStringFromTable(@"Confirm new password", @"Info", nil);
    self.ComfirmView.layer.masksToBounds = YES;
    self.ComfirmView.layer.cornerRadius = 3.0;
    
    self.submitBtn.backgroundColor=[UIColor THEMECOLOR];
    [self.submitBtn setTitle:NSLocalizedStringFromTable(@"SUBMIT", @"Info", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAct:(id)sender {
    NSLog(@"提交新密码");
    
    NSString *oldPassword = self.OldPswTF.text;
    NSString *oldPassword1 = [oldPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *newPassword = self.NewPswTF.text;
    NSString *newPassword1 = [newPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *confirmPsw = self.confirmPswTF.text;
    NSString *confirmPsw1 = [confirmPsw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([oldPassword1 length] ==0) {
        NSString *oldPasswordAlert = NSLocalizedStringFromTable(@"key old psw", @"Info", nil);
        [HUDHelper addHUDInView:sharedKeyWindow text:oldPasswordAlert hideAfterDelay:1];
    }else if ([newPassword1 length] ==0){
        NSString *newPasswordAlert = NSLocalizedStringFromTable(@"key new psw", @"Info", nil);
        [HUDHelper addHUDInView:sharedKeyWindow text:newPasswordAlert hideAfterDelay:1];
    }else if ([confirmPsw1 length] ==0){
        NSString *newPasswordAlert = NSLocalizedStringFromTable(@"comfirm new psw", @"Info", nil);
        [HUDHelper addHUDInView:sharedKeyWindow text:newPasswordAlert hideAfterDelay:1];
    }else{
        if ([confirmPsw1 isEqualToString:newPassword1]) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"updating password", @"Info", nil) hideAfterDelay:10];
            
            [[EHOMEUserModel shareInstance] resetPasswordByOldPassword:oldPassword1 newPassword:newPassword1 email:[EHOMEUserModel shareInstance].email success:^(id responseObject) {
                
                [HUDHelper addHUDInView:sharedKeyWindow
                                   text:NSLocalizedStringFromTable(@"update password success", @"Info", nil)
                         hideAfterDelay:2];
                [[EHOMEMQTTClientManager shareInstance] close];
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ViewController *loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginVC"];
                
                EHOMENavigationController *LoginNav = [[EHOMENavigationController alloc] initWithRootViewController:loginVC];
                
                [self presentViewController:LoginNav animated:YES completion:nil];
            } failure:^(NSError *error) {
                [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
                [HUDHelper showErrorDomain:error];
            }];
            
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"different password", @"Info", nil) hideAfterDelay:1];
        }
        
    }
}
@end
