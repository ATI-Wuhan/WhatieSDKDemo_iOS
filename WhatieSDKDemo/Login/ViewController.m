//
//  ViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "ViewController.h"
#import "EHOMETabBarController.h"
#import "EHOMERegisterAccountViewController.h"
#import "EHOMEForgetPasswordViewController.h"
#import "EHOMENavigationController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.emailView.backgroundColor=GREYCOLOR;
    self.passwordView.backgroundColor=GREYCOLOR;
    
    self.signinLabel.text = NSLocalizedString(@"Sign in", nil);
    self.signinLabel2.text = NSLocalizedString(@"with your email", nil);
    self.emailLabel.text = NSLocalizedStringFromTable(@"Email", @"Info", nil);
    self.passwordLabel.text = NSLocalizedString(@"Password", nil);
    
    [self.forgetPasswordBtn setTitle:NSLocalizedString(@"Forgot your password?", nil) forState:UIControlStateNormal];
    [self.signupBtn setTitle:NSLocalizedString(@"Don't have an account?", nil) forState:UIControlStateNormal];
    
    [self.logInBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    self.logInBtn.backgroundColor=THEMECOLOR;

    self.accountTF.placeholder = NSLocalizedString(@"PleaseKeyEmail", nil);
    self.passwordTF.placeholder = NSLocalizedString(@"PleaseKeyPassword", nil);    
    [self.forgetPasswordBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.signupBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupAct:(id)sender{
    EHOMERegisterAccountViewController *registerAccountVC = [[EHOMERegisterAccountViewController alloc] initWithNibName:@"EHOMERegisterAccountViewController" bundle:nil];
    
    EHOMENavigationController *registerAccountNav = [[EHOMENavigationController alloc] initWithRootViewController:registerAccountVC];
    
    [self presentViewController:registerAccountNav animated:YES completion:nil];
}

- (IBAction)forgetPasswordAct:(id)sender {
    EHOMEForgetPasswordViewController *forgetPasswordVC = [[EHOMEForgetPasswordViewController alloc] initWithNibName:@"EHOMEForgetPasswordViewController" bundle:nil];
    
    EHOMENavigationController *forgetPasswordNav = [[EHOMENavigationController alloc] initWithRootViewController:forgetPasswordVC];
    
    [self presentViewController:forgetPasswordNav animated:YES completion:nil];
}

- (IBAction)logInAct:(id)sender {
    NSString *email = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    
    
    if ([email length] > 0 && [password length] > 0) {
        
        
        NSLog(@"start login");
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Loading", nil) hideAfterDelay:25.0];
        
        [[EHOMEUserModel shareInstance] loginByEmail:email password:password success:^(id responseObject) {
            NSLog(@"login success = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"LoginSuccess", nil) hideAfterDelay:1.0];
            
            EHOMETabBarController *homeTabbar = [[EHOMETabBarController alloc] initWithNibName:@"EHOMETabBarController" bundle:nil];
            [self presentViewController:homeTabbar animated:YES completion:nil];
        } failure:^(NSError *error) {
            NSLog(@"login failed = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"LoginFailed", nil) hideAfterDelay:1.0];
        }];
        
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"check", nil) hideAfterDelay:1.0];
    }
}
@end
