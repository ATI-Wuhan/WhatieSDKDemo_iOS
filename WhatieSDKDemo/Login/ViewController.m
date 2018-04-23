//
//  ViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "ViewController.h"
#import "EHOMETabBarController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginAction:(id)sender;

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
    

    NSString *email = @"15207136550@163.com";
//    NSString *email = @"zhouwei20150901@icoud.com";
    [EHOMEUserModel loginWithEmail:email password:[EHOMEExtensions MD5EncryptedWith:@"123456789"] accessId:AccessId accessKey:AccessKey startBlock:^{
        
        NSLog(@"开始注册");
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Loading", nil) hideAfterDelay:25.0];
        
    } successBlock:^(id responseObject) {
        NSLog(@"注册成功 = %@", responseObject);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"LoginSuccess", nil) hideAfterDelay:1.0];
        
//        [EHOMEUserModel updateLoginPasswordWithEmail:@"zhouwei20150901@icloud.com" OldPasswordMD5:@"123456" newPasswordMD5:[EHOMEExtensions MD5EncryptedWith:@"123456"] startBlock:^{
//            NSLog(@"开始修改密码");
//        } successBlock:^(id responseObject) {
//            NSLog(@"修改密码成功 = %@", responseObject);
//        } failBlock:^(NSError *error) {
//            NSLog(@"修改密码失败 = %@", error);
//        }];
        
        [[EHOMEMQTTClientManager shareInstance] loginMQTT];
        
        EHOMETabBarController *homeTabbar = [[EHOMETabBarController alloc] initWithNibName:@"EHOMETabBarController" bundle:nil];
        [self presentViewController:homeTabbar animated:YES completion:nil];
    } failBlock:^(NSError *error) {
        NSLog(@"注册失败 = %@", error);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"LoginFailed", nil) hideAfterDelay:1.0];
    }];

}

@end
