//
//  EHOMERegisterAccountViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMERegisterAccountViewController.h"

@interface EHOMERegisterAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)registerAccount:(id)sender;

@end

@implementation EHOMERegisterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Register";
    
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



- (IBAction)registerAccount:(id)sender {
    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (email.length > 0 && [email containsString:@"@"] && password.length > 0) {
        [[EHOMEUserModel shareInstance] registerByEmail:email password:password success:^(id responseObject) {
            NSLog(@"register success");
            
            [self dismissVC];
            
        } failure:^(NSError *error) {
            NSLog(@"register failed");
        }];
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:@"Please check your email or password" hideAfterDelay:1.0];
    }
    

    
}
@end
