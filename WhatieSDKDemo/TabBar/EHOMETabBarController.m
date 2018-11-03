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
//#import "EHOMEStoreCollectionViewController.h"
#import "EHOMEMallViewController.h"

@interface EHOMETabBarController ()

@end

@implementation EHOMETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSystemTabbarController{
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    EHOMENavigationController *homeNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEHomeTableViewController alloc] initWithNibName:@"EHOMEHomeTableViewController" bundle:nil]];
    EHOMENavigationController *roomNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMERoomTableViewController alloc] initWithNibName:@"EHOMERoomTableViewController" bundle:nil]];
    EHOMENavigationController *sceneNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEScenesTableViewController alloc] initWithNibName:@"EHOMEScenesTableViewController" bundle:nil]];
    EHOMENavigationController *profileNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEProfileTableViewController alloc] initWithNibName:@"EHOMEProfileTableViewController" bundle:nil]];
    //只有eHome才有
    EHOMENavigationController *storeNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEMallViewController alloc] initWithNibName:@"EHOMEMallViewController" bundle:nil]];
    
    
    NSString *homeNormalIcon = @"home_icon";
    NSString *homeSelIcon = @"home_sel_icon";
    
    NSString *roomNormalIcon = @"room_icon";
    NSString *roomSelIcon = @"room_sel_icon";
    
    NSString *sceneNormalIcon = @"scene_icon";
    NSString *sceneSelIcon = @"scene_sel_icon";
    
    NSString *mallNormalIcon = @"mall_icon";
    NSString *mallSelIcon = @"mall_sel_icon";
    
    NSString *profileNormalIcon = @"profile_icon";
    NSString *profileSelIcon = @"profile_sel_icon";
    
    if (CurrentApp == Geek) {
        homeNormalIcon = @"Geek+home_normal";
        homeSelIcon = @"Geek+home_sel";
        
        roomNormalIcon = @"Geek+room_normal";
        roomSelIcon = @"Geek+room_sel";
        
        sceneNormalIcon = @"Geek+scene_normal";
        sceneSelIcon = @"Geek+scene_sel";
        
        profileNormalIcon = @"Geek+profile_normal";
        profileSelIcon = @"Geek+profile_sel";
    }else if (CurrentApp == Ozwi){
        homeNormalIcon = @"Ozwi+home_normal";
        homeSelIcon = @"Ozwi+home_sel";
        
        roomNormalIcon = @"Ozwi+room_normal";
        roomSelIcon = @"Ozwi+room_sel";
        
        sceneNormalIcon = @"Ozwi+scene_normal";
        sceneSelIcon = @"Ozwi+scene_sel";
        
        profileNormalIcon = @"Ozwi+profile_normal";
        profileSelIcon = @"Ozwi+profile_sel";
    }else{
        //eHome
        homeNormalIcon = @"home_icon";
        homeSelIcon = @"home_sel_icon";
        
        roomNormalIcon = @"room_icon";
        roomSelIcon = @"room_sel_icon";
        
        sceneNormalIcon = @"scene_icon";
        sceneSelIcon = @"scene_sel_icon";
        
        mallNormalIcon = @"mall_icon";
        mallSelIcon = @"mall_sel_icon";
        
        profileNormalIcon = @"profile_icon";
        profileSelIcon = @"profile_sel_icon";
    }
    
    homeNav.tabBarItem.title = NSLocalizedStringFromTable(@"Home", @"Home", nil);
    homeNav.tabBarItem.image = [[UIImage imageNamed:homeNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:homeSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
    
    
    roomNav.tabBarItem.title = NSLocalizedStringFromTable(@"Room", @"Room", nil);
    roomNav.tabBarItem.image = [[UIImage imageNamed:roomNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    roomNav.tabBarItem.selectedImage = [[UIImage imageNamed:roomSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [roomNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
    
    sceneNav.tabBarItem.title = NSLocalizedString(@"Scene", nil);
    sceneNav.tabBarItem.image = [[UIImage imageNamed:sceneNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    sceneNav.tabBarItem.selectedImage = [[UIImage imageNamed:sceneSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [sceneNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
    
    profileNav.tabBarItem.title = NSLocalizedStringFromTable(@"Profile", @"Profile", nil);
    profileNav.tabBarItem.image = [[UIImage imageNamed:profileNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileNav.tabBarItem.selectedImage = [[UIImage imageNamed:profileSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [profileNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
    
    
    
    
    storeNav.tabBarItem.title = NSLocalizedStringFromTable(@"Store", @"Home", nil);
    storeNav.tabBarItem.image = [[UIImage imageNamed:mallNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    storeNav.tabBarItem.selectedImage = [[UIImage imageNamed:mallSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [storeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
    
    
    
    if (CurrentApp == 0) {
        //eHome显示商城
        self.viewControllers = @[homeNav, roomNav, sceneNav, storeNav, profileNav];
    }else{
        self.viewControllers = @[homeNav, roomNav, sceneNav, profileNav];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.tabBar.backgroundColor = [UIColor whiteColor];
    
        EHOMENavigationController *homeNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEHomeTableViewController alloc] initWithNibName:@"EHOMEHomeTableViewController" bundle:nil]];
        EHOMENavigationController *roomNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMERoomTableViewController alloc] initWithNibName:@"EHOMERoomTableViewController" bundle:nil]];
        EHOMENavigationController *sceneNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEScenesTableViewController alloc] initWithNibName:@"EHOMEScenesTableViewController" bundle:nil]];
        EHOMENavigationController *profileNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEProfileTableViewController alloc] initWithNibName:@"EHOMEProfileTableViewController" bundle:nil]];
        //只有eHome才有
        EHOMENavigationController *storeNav = [[EHOMENavigationController alloc] initWithRootViewController:[[EHOMEMallViewController alloc] initWithNibName:@"EHOMEMallViewController" bundle:nil]];
        
        
        NSString *homeNormalIcon = @"home_icon";
        NSString *homeSelIcon = @"home_sel_icon";
        
        NSString *roomNormalIcon = @"room_icon";
        NSString *roomSelIcon = @"room_sel_icon";
        
        NSString *sceneNormalIcon = @"scene_icon";
        NSString *sceneSelIcon = @"scene_sel_icon";
        
        NSString *mallNormalIcon = @"mall_icon";
        NSString *mallSelIcon = @"mall_sel_icon";
        
        NSString *profileNormalIcon = @"profile_icon";
        NSString *profileSelIcon = @"profile_sel_icon";
        
        if (CurrentApp == Geek) {
            homeNormalIcon = @"Geek+home_normal";
            homeSelIcon = @"Geek+home_sel";
            
            roomNormalIcon = @"Geek+room_normal";
            roomSelIcon = @"Geek+room_sel";
            
            sceneNormalIcon = @"Geek+scene_normal";
            sceneSelIcon = @"Geek+scene_sel";
            
            profileNormalIcon = @"Geek+profile_normal";
            profileSelIcon = @"Geek+profile_sel";
        }else if (CurrentApp == Ozwi){
            homeNormalIcon = @"Ozwi+home_normal";
            homeSelIcon = @"Ozwi+home_sel";
            
            roomNormalIcon = @"Ozwi+room_normal";
            roomSelIcon = @"Ozwi+room_sel";
            
            sceneNormalIcon = @"Ozwi+scene_normal";
            sceneSelIcon = @"Ozwi+scene_sel";
            
            profileNormalIcon = @"Ozwi+profile_normal";
            profileSelIcon = @"Ozwi+profile_sel";
        }else{
            //eHome
            homeNormalIcon = @"home_icon";
            homeSelIcon = @"home_sel_icon";
            
            roomNormalIcon = @"room_icon";
            roomSelIcon = @"room_sel_icon";
            
            sceneNormalIcon = @"scene_icon";
            sceneSelIcon = @"scene_sel_icon";
            
            mallNormalIcon = @"mall_icon";
            mallSelIcon = @"mall_sel_icon";
            
            profileNormalIcon = @"profile_icon";
            profileSelIcon = @"profile_sel_icon";
        }
        
        homeNav.tabBarItem.title = NSLocalizedStringFromTable(@"Home", @"Home", nil);
        homeNav.tabBarItem.image = [[UIImage imageNamed:homeNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:homeSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
        
        
        roomNav.tabBarItem.title = NSLocalizedStringFromTable(@"Room", @"Room", nil);
        roomNav.tabBarItem.image = [[UIImage imageNamed:roomNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        roomNav.tabBarItem.selectedImage = [[UIImage imageNamed:roomSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [roomNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
        
        sceneNav.tabBarItem.title = NSLocalizedString(@"Scene", nil);
        sceneNav.tabBarItem.image = [[UIImage imageNamed:sceneNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sceneNav.tabBarItem.selectedImage = [[UIImage imageNamed:sceneSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sceneNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];
        
        profileNav.tabBarItem.title = NSLocalizedStringFromTable(@"Profile", @"Profile", nil);
        profileNav.tabBarItem.image = [[UIImage imageNamed:profileNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        profileNav.tabBarItem.selectedImage = [[UIImage imageNamed:profileSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [profileNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];

        storeNav.tabBarItem.title = NSLocalizedStringFromTable(@"Store", @"Home", nil);
        storeNav.tabBarItem.image = [[UIImage imageNamed:mallNormalIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        storeNav.tabBarItem.selectedImage = [[UIImage imageNamed:mallSelIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [storeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor THEMECOLOR]} forState:UIControlStateSelected];

        
        
        NSDictionary *dict1 = @{
                                CYLTabBarItemTitle : NSLocalizedStringFromTable(@"Home", @"Home", nil),
                                CYLTabBarItemImage : homeNormalIcon,
                                CYLTabBarItemSelectedImage : homeSelIcon,
                                };
        NSDictionary *dict2 = @{
                                CYLTabBarItemTitle : NSLocalizedStringFromTable(@"Room", @"Room", nil),
                                CYLTabBarItemImage : roomNormalIcon,
                                CYLTabBarItemSelectedImage : roomSelIcon,
                                };
        NSDictionary *dict3 = @{
                                CYLTabBarItemTitle : NSLocalizedString(@"Scene", nil),
                                CYLTabBarItemImage : sceneNormalIcon,
                                CYLTabBarItemSelectedImage : sceneSelIcon,
                                };
        NSDictionary *dict4 = @{
                                CYLTabBarItemTitle : NSLocalizedStringFromTable(@"Profile", @"Profile", nil),
                                CYLTabBarItemImage : profileNormalIcon,
                                CYLTabBarItemSelectedImage : profileSelIcon,
                                };
        NSDictionary *dict5 = @{
                                CYLTabBarItemTitle : NSLocalizedStringFromTable(@"Store", @"Home", nil),
                                CYLTabBarItemImage : mallNormalIcon,
                                CYLTabBarItemSelectedImage : mallSelIcon,
                                };
        

        
        if (CurrentApp == 0) {
            //eHome显示商城
            NSArray *tabBarItemsAttributes = @[dict1,dict2,dict5,dict3,dict4];
            self.tabBarItemsAttributes = tabBarItemsAttributes;
            [self setViewControllers:@[homeNav, roomNav, sceneNav, storeNav, profileNav]];

        }else{
            NSArray *tabBarItemsAttributes = @[dict1,dict2,dict3,dict4];
            self.tabBarItemsAttributes = tabBarItemsAttributes;
            [self setViewControllers:@[homeNav, roomNav, sceneNav, profileNav]];

        }

    }

    return self;
}

- (void)setupViewControllers {

}

/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {

}

@end
