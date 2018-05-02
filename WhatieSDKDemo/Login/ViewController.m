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
    
//    [self POSTTEST];
//    return;
    

    NSString *email = @"15207136550@163.com";
//    NSString *email = @"zhouwei20150901@icoud.com";
//    NSString *email = @"huqintest";
//NSString *email = @"whatieTest0002";
//    NSString *email = self.emailTextField.text;
//    NSString *password = [EHOMEExtensions MD5EncryptedWith:self.passwordTextField.text];
    NSString *password = [EHOMEExtensions MD5EncryptedWith:@"123456789"];
    
    if ([email length] > 0 && [password length] > 0) {
        [EHOMEUserModel loginWithEmail:email password:password startBlock:^{
            
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"LoginFailed", nil) hideAfterDelay:1.0];
            });
            
        }];
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:@"Please check email or password" hideAfterDelay:1.0];
    }

}

-(void)POSTTEST{
    
    NSString *email = @"zhouwei20150901@icloud.com";
    

    
    NSDictionary *params = @{@"phone":@(76182),           @"password":[EHOMEExtensions MD5EncryptedWith:@"123456"]};
    
    

    
    NSURL *url = [NSURL URLWithString:@"https://app.ceks100.com/server/login/loginAdvisor"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    
    NSString *str = [self HTTPBodyWithParameters:params];
    
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Do sth to process returend data
        if(!error)
        {
            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

- (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if (value != nil) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else{
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,@""]];
        }
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}

@end
