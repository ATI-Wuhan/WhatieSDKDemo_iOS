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
@property (retain, nonatomic) IBOutlet UIButton *changeBtn;

- (IBAction)sendVerifyCode:(id)sender;
- (IBAction)resetLoginPassword:(id)sender;
- (IBAction)changePasswordDisplay:(id)sender;

@end

@implementation EHOMEForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Reset Password", nil);
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.sendBtn.backgroundColor=[UIColor THEMECOLOR];
    [self.sendBtn setTitle:NSLocalizedString(@"send code", nil) forState:UIControlStateNormal];
    self.ResetBtn.backgroundColor=[UIColor THEMECOLOR];
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
    
    if (email.length > 0 && [email containsString:@"@"]) {
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"sending", nil) hideAfterDelay:5];
        
        [[EHOMEUserModel shareInstance] sendVerifyCodeByEmail:email success:^(id responseObject) {
            NSLog(@"Verify Code sent success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"code sent success", @"Info", nil) hideAfterDelay:1.0];
            
            [self.codeTextField becomeFirstResponder];
            
        } failure:^(NSError *error) {
            NSLog(@"Verify Code sent filed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
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
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Reseting", @"Info", nil) hideAfterDelay:10];
        
        [[EHOMEUserModel shareInstance] resetPasswordByEmail:email newPassword:password code:code success:^(id responseObject) {
            NSLog(@"Reset password success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"reset password success", nil) hideAfterDelay:1.0];
            
            //重置密码成功，存至数据库
            [EHOMEDataStore setUserToDB:email andPassword:password];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSError *error) {
            NSLog(@"Reset password failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
        
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Please check email,code,or password", nil) hideAfterDelay:1.0];
    }
    

}

- (IBAction)changePasswordDisplay:(id)sender {
    self.changeBtn = sender;
    self.changeBtn.selected = !self.changeBtn.selected;
    NSLog(@"是否选中 = %d",self.changeBtn.selected);
    if (self.changeBtn.selected) { // 按下去了就是明文

        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTextField.secureTextEntry = NO;
        self.passwordTextField.text = tempPwdStr;

    } else { // 暗文

        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @"";
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.text = tempPwdStr;
    }
    
    if (self.passwordTextField.secureTextEntry) {
        
        // 解决输入框从明文切换为密文时进行二次编辑出现清空现象
        
        [self.passwordTextField insertText:self.passwordTextField.text];
        
    }
}
- (void)dealloc {
    [_changeBtn release];
    [super dealloc];
}

@end
