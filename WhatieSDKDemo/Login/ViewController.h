//
//  ViewController.h
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/13.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *signinLabel;
@property (weak, nonatomic) IBOutlet UILabel *signinLabel2;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
- (IBAction)forgetPasswordAct:(id)sender;
- (IBAction)logInAct:(id)sender;
- (IBAction)signupAct:(id)sender;

@end

