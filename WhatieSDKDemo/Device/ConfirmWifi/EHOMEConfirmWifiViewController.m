//
//  EHOMEConfirmWifiViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/21.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEConfirmWifiViewController.h"
#import "UIImage+GIF.h"
#import "EHOMESmartConfigViewController.h"

@interface EHOMEConfirmWifiViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonAction:(id)sender;

@end

@implementation EHOMEConfirmWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Confirm";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"deviceGIF" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.deviceImageView.image = [UIImage sd_animatedGIFWithData:data];
    
    self.descriptionLabel.text = @"1.Power outlet,if the indicator light flashing alternately,click NEXT.\n\n2.If not,press 'switch' 3-12seconds,until the indicator light flashing,and then click NEXT.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)nextButtonAction:(id)sender {
    
    NSString *title = @"Alert";
    NSString *message = @"Please key your wifi password.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *cancel = @"Cancel";
    NSString *next = @"OK";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:next style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *password = [alertController.textFields firstObject].text;
        [self gotoSmartConfigActionWithPassword:password];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"wifi password";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)gotoSmartConfigActionWithPassword:(NSString *)password{
    EHOMESmartConfigViewController *smartConfigVC = [[EHOMESmartConfigViewController alloc] initWithNibName:@"EHOMESmartConfigViewController" bundle:nil];
    smartConfigVC.wifiPassword = password;
    [self.navigationController pushViewController:smartConfigVC animated:YES];
}



@end
