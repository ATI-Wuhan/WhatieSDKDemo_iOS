//
//  EHOMEForgetPasswordViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEForgetPasswordViewController.h"

@interface EHOMEForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *recoverLabel;
@property (weak, nonatomic) IBOutlet UILabel *recoverLabel1;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinLabel;
@property (weak, nonatomic) IBOutlet UILabel *PswLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *ResetBtn;

- (IBAction)sendVerifyCode:(id)sender;
- (IBAction)resetLoginPassword:(id)sender;

@end

@implementation EHOMEForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Reset Password", nil);
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.sendBtn.backgroundColor=THEMECOLOR;
    [self.sendBtn setTitle:NSLocalizedString(@"send code", nil) forState:UIControlStateNormal];
    self.ResetBtn.backgroundColor=THEMECOLOR;
    [self.ResetBtn setTitle:NSLocalizedString(@"Reset Password", nil) forState:UIControlStateNormal];
    
    self.recoverLabel.text = NSLocalizedString(@"Recover Login Password", nil);
    self.recoverLabel1.text = NSLocalizedString(@"Enter the account you want to recover.", nil);
    self.emailLabel.text = NSLocalizedStringFromTable(@"Email", @"Info", nil);
    self.pinLabel.text = NSLocalizedString(@"PIN", nil);
    self.PswLabel.text = NSLocalizedStringFromTable(@"New password", @"Info", nil);
    
    self.emailTextField.placeholder = NSLocalizedString(@"Your Email", nil);
    self.codeTextField.placeholder = NSLocalizedString(@"Verify Code", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Your New Password", nil);
    
}

-(void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)sendVerifyCode:(id)sender {
    
    NSString *email = self.emailTextField.text;
    
    [self.emailTextField resignFirstResponder];
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"sending", nil) hideAfterDelay:5];
    
    if (email.length > 0 && [email containsString:@"@"]) {
        [[EHOMEUserModel shareInstance] sendVerifyCodeByEmail:email success:^(id responseObject) {
            NSLog(@"Verify Code sent success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:@"code sent success" hideAfterDelay:1.0];
            
            [self.codeTextField becomeFirstResponder];
            
        } failure:^(NSError *error) {
            NSLog(@"Verify Code sent filed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
    }else{

        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Please enter email", nil) hideAfterDelay:1.0];
    }
    
}

- (IBAction)resetLoginPassword:(id)sender {
    
    [self.emailTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    NSString *email = self.emailTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (email.length > 0 && code.length > 0 && password.length > 0) {
        [[EHOMEUserModel shareInstance] resetPasswordByEmail:email newPassword:password code:code success:^(id responseObject) {
            NSLog(@"Reset password success. res = %@", responseObject);
            
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"reset password success", nil) hideAfterDelay:1.0];
            
        } failure:^(NSError *error) {
            NSLog(@"Reset password failed. error = %@", error);
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Please check email,code,or password", nil) hideAfterDelay:1.0];
    }
    

}
@end
