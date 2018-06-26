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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginAction:(id)sender;
- (IBAction)forgetLoginPassword:(id)sender;
- (IBAction)registerNewAccount:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];

    self.emailTextField.placeholder = NSLocalizedString(@"PleaseKeyEmail", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"PleaseKeyPassword", nil);
    self.emailTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.textColor = [UIColor whiteColor];
    


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)loginAction:(id)sender {
    
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    
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
        [HUDHelper addHUDInView:sharedKeyWindow text:@"Please check email or password" hideAfterDelay:1.0];
    }

}

- (IBAction)forgetLoginPassword:(id)sender {
    EHOMEForgetPasswordViewController *forgetPasswordVC = [[EHOMEForgetPasswordViewController alloc] initWithNibName:@"EHOMEForgetPasswordViewController" bundle:nil];
    
    EHOMENavigationController *forgetPasswordNav = [[EHOMENavigationController alloc] initWithRootViewController:forgetPasswordVC];
    
    [self presentViewController:forgetPasswordNav animated:YES completion:nil];
}

- (IBAction)registerNewAccount:(id)sender {
    EHOMERegisterAccountViewController *registerAccountVC = [[EHOMERegisterAccountViewController alloc] initWithNibName:@"EHOMERegisterAccountViewController" bundle:nil];
    
    EHOMENavigationController *registerAccountNav = [[EHOMENavigationController alloc] initWithRootViewController:registerAccountVC];
    
    [self presentViewController:registerAccountNav animated:YES completion:nil];
}



@end
