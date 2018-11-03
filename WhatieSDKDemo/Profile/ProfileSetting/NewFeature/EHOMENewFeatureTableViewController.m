//
//  EHOMENewFeatureTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/1.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMENewFeatureTableViewController.h"
#import "EHOMENewFeatureTableViewCell.h"


#define cellId @"EHOMENewFeatureTableViewCell"

@interface EHOMENewFeatureTableViewController ()


@end

@implementation EHOMENewFeatureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Features", @"Profile", @"New Feature");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMENewFeatureTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, 30)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHOMENewFeatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[EHOMENewFeatureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSArray *titles = @[NSLocalizedStringFromTable(@"GeekNewFeatureTitle1", @"NewFeature", nil),
                        NSLocalizedStringFromTable(@"GeekNewFeatureTitle2", @"NewFeature", nil),
                        NSLocalizedStringFromTable(@"GeekNewFeatureTitle3", @"NewFeature", nil),
                        NSLocalizedStringFromTable(@"GeekNewFeatureTitle4", @"NewFeature", nil)];
    NSArray *contents = @[NSLocalizedStringFromTable(@"GeekNewFeatureContent1", @"NewFeature", nil),
                          NSLocalizedStringFromTable(@"GeekNewFeatureContent2", @"NewFeature", nil),
                          NSLocalizedStringFromTable(@"GeekNewFeatureContent3", @"NewFeature", nil),
                          NSLocalizedStringFromTable(@"GeekNewFeatureContent4", @"NewFeature", nil)];
    NSArray *images = @[@"NewFeatureGeek1",@"NewFeatureGeek2",@"NewFeatureGeek3",@"NewFeatureGeek4"];
    
    switch (CurrentApp) {
        case eHome:{
            titles = @[NSLocalizedStringFromTable(@"eHomeNewFeatureTitle1", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"eHomeNewFeatureTitle2", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"eHomeNewFeatureTitle3", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"eHomeNewFeatureTitle4", @"NewFeature", nil)];
            contents = @[NSLocalizedStringFromTable(@"eHomeNewFeatureContent1", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"eHomeNewFeatureContent2", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"eHomeNewFeatureContent3", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"eHomeNewFeatureContent4", @"NewFeature", nil)];
            images = @[@"NewFeatureEHome1",@"NewFeatureEHome2",@"NewFeatureEHome3",@"NewFeatureEHome4"];
        }
            
            break;
        case Geek:{
            titles = @[NSLocalizedStringFromTable(@"GeekNewFeatureTitle1", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"GeekNewFeatureTitle2", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"GeekNewFeatureTitle3", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"GeekNewFeatureTitle4", @"NewFeature", nil)];
            contents = @[NSLocalizedStringFromTable(@"GeekNewFeatureContent1", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"GeekNewFeatureContent2", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"GeekNewFeatureContent3", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"GeekNewFeatureContent4", @"NewFeature", nil)];
            images = @[@"NewFeatureGeek1",@"NewFeatureGeek2",@"NewFeatureGeek3",@"NewFeatureGeek4"];
        }
            
            break;
        case Ozwi:{
            titles = @[NSLocalizedStringFromTable(@"OzwiNewFeatureTitle1", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"OzwiNewFeatureTitle2", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"OzwiNewFeatureTitle3", @"NewFeature", nil),
                       NSLocalizedStringFromTable(@"OzwiNewFeatureTitle4", @"NewFeature", nil)];
            contents = @[NSLocalizedStringFromTable(@"OzwiNewFeatureContent1", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"OzwiNewFeatureContent2", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"OzwiNewFeatureContent3", @"NewFeature", nil),
                         NSLocalizedStringFromTable(@"OzwiNewFeatureContent4", @"NewFeature", nil)];
            images = @[@"NewFeatureOzwi1",@"NewFeatureOzwi2",@"NewFeatureOzwi3",@"NewFeatureOzwi4"];
        }
            
            break;
            
        default:
            break;
    }

    cell.titleLabel.text = titles[indexPath.section];
    cell.contentLabel.text = contents[indexPath.section];
    cell.featureImageView.image = [UIImage imageNamed:images[indexPath.section]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 390;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}



@end
