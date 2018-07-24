//
//  EHOMETabBarController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMETabBarController.h"
#import "EHOMEHomeTableViewController.h"
#import "EHOMERoomTableViewController.h"
#import "EHOMEScenesTableViewController.h"
#import "EHOMEProfileTableViewController.h"
#import "EHOMENavigationController.h"

@interface EHOMETabBarController ()

@end

@implementation EHOMETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    EHOMENavigationController *homeNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEHomeTableViewController alloc] initWithNibName:@"EHOMEHomeTableViewController" bundle:nil]];
    EHOMENavigationController *roomNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMERoomTableViewController alloc] initWithNibName:@"EHOMERoomTableViewController" bundle:nil]];
    EHOMENavigationController *sceneNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEScenesTableViewController alloc] initWithNibName:@"EHOMEScenesTableViewController" bundle:nil]];
    EHOMENavigationController *profileNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEProfileTableViewController alloc] initWithNibName:@"EHOMEProfileTableViewController" bundle:nil]];
    
    
    NSString *homeNormalIcon = @"home_icon";
    NSString *homeSelIcon = @"home_sel_icon";
    
    NSString *roomNormalIcon = @"room_icon";
    NSString *roomSelIcon = @"room_sel_icon";
    
    NSString *sceneNormalIcon = @"scene_icon";
    NSString *sceneSelIcon = @"scene_sel_icon";
    
    NSString *profileNormalIcon = @"profile_icon";
    NSString *profileSelIcon = @"profile_sel_icon";
    
    if ([CurrentApp isEqualToString:@"Geek+"]) {
        homeNormalIcon = @"Geek+home_normal";
        homeSelIcon = @"Geek+home_sel";
        
        roomNormalIcon = @"Geek+room_normal";
        roomSelIcon = @"Geek+room_sel";
        
        sceneNormalIcon = @"Geek+scene_normal";
        sceneSelIcon = @"Geek+scene_sel";
        
        profileNormalIcon = @"Geek+profile_normal";
        profileSelIcon = @"Geek+profile_sel";
    }else if ([CurrentApp isEqualToString:@"Ozwi"]){
        
    }else{
        //eHome
        homeNormalIcon = @"home_icon";
        homeSelIcon = @"home_sel_icon";
        
        roomNormalIcon = @"room_icon";
        roomSelIcon = @"room_sel_icon";
        
        sceneNormalIcon = @"scene_icon";
        sceneSelIcon = @"scene_sel_icon";
        
        profileNormalIcon = @"profile_icon";
        profileSelIcon = @"profile_sel_icon";
    }
    
    homeNav.tabBarItem.title = @"Home";
    homeNav.tabBarItem.image = [[UIImage imageNamed:homeNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:homeSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:THEMECOLOR} forState:UIControlStateSelected];
    
    
    roomNav.tabBarItem.title = @"Room";
    roomNav.tabBarItem.image = [[UIImage imageNamed:roomNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    roomNav.tabBarItem.selectedImage = [[UIImage imageNamed:roomSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [roomNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:THEMECOLOR} forState:UIControlStateSelected];
    
    sceneNav.tabBarItem.title = @"Scene";
    sceneNav.tabBarItem.image = [[UIImage imageNamed:sceneNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    sceneNav.tabBarItem.selectedImage = [[UIImage imageNamed:sceneSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [sceneNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:THEMECOLOR} forState:UIControlStateSelected];
    
    profileNav.tabBarItem.title = @"Profile";
    profileNav.tabBarItem.image = [[UIImage imageNamed:profileNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileNav.tabBarItem.selectedImage = [[UIImage imageNamed:profileSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [profileNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:THEMECOLOR} forState:UIControlStateSelected];
    
    self.viewControllers = @[homeNav, roomNav, sceneNav, profileNav];
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
