//
//  EHOMEAddIntelligenceVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/24.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAddIntelligenceVC.h"
#import "EHOMEIntelligentSettingTableViewController.h"

@interface EHOMEAddIntelligenceVC ()
@property (retain, nonatomic) IBOutlet UILabel *AddTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *pleaseLabel;
@property (retain, nonatomic) IBOutlet UILabel *manualLabel;
@property (retain, nonatomic) IBOutlet UILabel *autoLabel;

@end

@implementation EHOMEAddIntelligenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.AddTitleLabel.text = NSLocalizedString(@"Add Smart Scene", nil);
    self.pleaseLabel.text = NSLocalizedString(@"Please Select Type", nil);
    self.manualLabel.text = NSLocalizedString(@"Manual", nil);
    self.autoLabel.text = NSLocalizedString(@"Auto", nil);
    
    self.manualView.layer.masksToBounds = YES;
    self.manualView.layer.cornerRadius = 6.0;
    
    self.timingView.layer.masksToBounds = YES;
    self.timingView.layer.cornerRadius = 6.0;
    
    self.manualView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapManualGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapManual)];
    [self.manualView addGestureRecognizer:tapManualGesture];
    
    self.timingView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapTimingGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTiming)];
    [self.timingView addGestureRecognizer:tapTimingGesture];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)TapManual{
    NSLog(@"添加手动执行场景");
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
//        NSDictionary *Dic = @{@"type":@"mamual"};
//        NSNotification *notification =[NSNotification notificationWithName:@"GotoIntelligentSetting" object:nil userInfo:Dic];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        NSLog(@"wua =%@",Dic);
//    }];
    
    NSDictionary *Dic = @{@"type":@"mamual"};
    [self gotoSettingAction:Dic];
}

-(void)TapTiming{
    NSLog(@"添加自动执行场景");
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
//        NSDictionary *Dic = @{@"type":@"timing"};
//        NSNotification *notification =[NSNotification notificationWithName:@"GotoIntelligentSetting" object:nil userInfo:Dic];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        NSLog(@"wua =%@",Dic);
//    }];
    
    NSDictionary *Dic = @{@"type":@"timing"};
    [self gotoSettingAction:Dic];
}

-(void)gotoSettingAction:(NSDictionary *)dic{
    EHOMEIntelligentSettingTableViewController *addvc = [[EHOMEIntelligentSettingTableViewController alloc] initWithNibName:@"EHOMEIntelligentSettingTableViewController" bundle:nil];
    addvc.isAddScene = YES;
    if([[dic objectForKey:@"type"] isEqualToString:@"timing"]){
        addvc.isManual = NO;
    }else{
        addvc.isManual = YES;
    }
    
    [self.navigationController pushViewController:addvc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_manualView release];
    [_timingView release];
    [_manualView release];
    [_timingView release];
    [_AddTitleLabel release];
    [_pleaseLabel release];
    [_manualLabel release];
    [_autoLabel release];
    [super dealloc];
}
- (IBAction)clickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
