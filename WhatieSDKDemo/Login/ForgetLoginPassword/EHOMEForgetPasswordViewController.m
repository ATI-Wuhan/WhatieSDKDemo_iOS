//
//  EHOMEForgetPasswordViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEForgetPasswordViewController.h"

@interface EHOMEForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)sendVerifyCode:(id)sender;
- (IBAction)resetLoginPassword:(id)sender;

@end

@implementation EHOMEForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Reset Password";
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
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
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:@"sending" hideAfterDelay:5];
    
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

        [HUDHelper addHUDInView:sharedKeyWindow text:@"Please enter email" hideAfterDelay:1.0];
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
            
            [HUDHelper addHUDInView:sharedKeyWindow text:@"reset password success" hideAfterDelay:1.0];
            
        } failure:^(NSError *error) {
            NSLog(@"Reset password failed. error = %@", error);
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:@"Please check email,code,or password" hideAfterDelay:1.0];
    }
    

}
@end
