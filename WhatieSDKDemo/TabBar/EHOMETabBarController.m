//
//  EHOMETabBarController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMETabBarController.h"
#import "EHOMEHomeTableViewController.h"
#import "EHOMEProfileTableViewController.h"
#import "EHOMENavigationController.h"

@interface EHOMETabBarController ()

@end

@implementation EHOMETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    EHOMENavigationController *homeNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEHomeTableViewController alloc] initWithNibName:@"EHOMEHomeTableViewController" bundle:nil]];
    EHOMENavigationController *profileNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEProfileTableViewController alloc] initWithNibName:@"EHOMEProfileTableViewController" bundle:nil]];
    
    homeNav.tabBarItem.title = @"Home";
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_sel_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    profileNav.tabBarItem.title = @"Profile";
    profileNav.tabBarItem.image = [[UIImage imageNamed:@"profile_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"profile_sel_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[homeNav, profileNav];
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

@end
