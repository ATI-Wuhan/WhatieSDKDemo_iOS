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
#import "EHOMELoginAlertView.h"

@interface ViewController ()<UITextFieldDelegate, loginDelegate>

@property (retain, nonatomic) IBOutlet UIButton *downButton;
- (IBAction)showUserLoginList:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *changeBtn;
- (IBAction)changePswDisplay:(id)sender;

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
    self.logInBtn.backgroundColor=[UIColor THEMECOLOR];

    self.accountTF.placeholder = NSLocalizedString(@"PleaseKeyEmail", nil);
    self.accountTF.delegate = self;
    self.passwordTF.placeholder = NSLocalizedString(@"PleaseKeyPassword", nil);    
    [self.forgetPasswordBtn setTitleColor:[UIColor THEMECOLOR] forState:UIControlStateNormal];
    [self.signupBtn setTitleColor:[UIColor THEMECOLOR] forState:UIControlStateNormal];

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
    
    [self loginWithEmail:email password:password];
}

-(void)loginWithEmail:(NSString *)email password:(NSString *)password{
    
    if ([email length] > 0 && [password length] > 0) {
        
        
        NSLog(@"start login");
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Logining", nil) hideAfterDelay:25.0];
        
        [[EHOMEUserModel shareInstance] loginByEmail:email password:password success:^(id responseObject) {
            NSLog(@"login success = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"LoginSuccess", nil) hideAfterDelay:1.0];
            
            //登录成功，邮箱及密码存至数据库
            [EHOMEDataStore setUserToDB:email andPassword:password];
            
            EHOMETabBarController *homeTabbar = [[EHOMETabBarController alloc] initWithNibName:@"EHOMETabBarController" bundle:nil];
            [self presentViewController:homeTabbar animated:YES completion:nil];
        } failure:^(NSError *error) {
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
        
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"check", nil) hideAfterDelay:1.0];
    }
}

- (void)dealloc {
    [_downButton release];
    [_changeBtn release];
    [super dealloc];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.downButton.hidden = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.downButton.hidden = NO;
}


- (IBAction)showUserLoginList:(id)sender {
    
    [self.accountTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
    EHOMELoginAlertView *alertView = [[EHOMELoginAlertView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H)];
    alertView.delegate = self;
    [alertView show];
}

-(void)fastLoginWithEmail:(NSString *)email andPassword:(NSString *)password{
    
    [self loginWithEmail:email password:password];
}


- (IBAction)changePswDisplay:(id)sender {
    self.changeBtn = sender;
    self.changeBtn.selected = !self.changeBtn.selected;
    NSLog(@"是否选中 = %d",self.changeBtn.selected);
    if (self.changeBtn.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.passwordTF.text;
        self.passwordTF.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTF.secureTextEntry = NO;
        self.passwordTF.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.passwordTF.text;
        self.passwordTF.text = @"";
        self.passwordTF.secureTextEntry = YES;
        self.passwordTF.text = tempPwdStr;
    }
    
    if (self.passwordTF.secureTextEntry) {
        
        // 解决输入框从明文切换为密文时进行二次编辑出现清空现象
        
        [self.passwordTF insertText:self.passwordTF.text];
        
    }
}
@end
