//
//  EHOMERegisterAccountViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMERegisterAccountViewController.h"

@interface EHOMERegisterAccountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *signupLabel;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel1;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *pswLabel;
    
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *ResetBtn;
@property (retain, nonatomic) IBOutlet UIButton *ChangeBtn;

- (IBAction)registerAccount:(id)sender;
- (IBAction)changePswDisplay:(id)sender;

@end

@implementation EHOMERegisterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Register", nil);
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    self.signupLabel.text = NSLocalizedString(@"Sign up", nil);
    self.signupLabel1.text = NSLocalizedString(@"email and password", nil);
    self.emailLabel.text = NSLocalizedStringFromTable(@"Email", @"Info", nil);
    self.pswLabel.text = NSLocalizedString(@"Password", nil);
    self.emailTextField.placeholder = NSLocalizedStringFromTable(@"Email", @"Info", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    [self.ResetBtn setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    self.ResetBtn.backgroundColor=[UIColor THEMECOLOR];
}

-(void)dismissVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registerAccount:(id)sender {
    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;

    if (email.length > 0 && [email containsString:@"@"] && password.length > 0) {
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Registering", @"Info", nil) hideAfterDelay:10];
        
        [[EHOMEUserModel shareInstance] registerByEmail:email password:password success:^(id responseObject) {
            NSLog(@"register success");
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];\
            
            [HUDHelper addHUDInView:sharedKeyWindow text:@"Register success" hideAfterDelay:1.0];
            
            [self dismissVC];
            
        } failure:^(NSError *error) {
            NSLog(@"register failed");
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"check", nil) hideAfterDelay:1.0];
    }
    

    
}

- (IBAction)changePswDisplay:(id)sender {
    self.ChangeBtn = sender;
    self.ChangeBtn.selected = !self.ChangeBtn.selected;
    NSLog(@"是否选中 = %d",self.ChangeBtn.selected);
    if (self.ChangeBtn.selected) { // 按下去了就是明文
        
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
    [_ChangeBtn release];
    [super dealloc];
}
@end
