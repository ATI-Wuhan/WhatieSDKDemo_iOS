//
//  EHOMELoopsTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMELoopsTableViewController.h"

@interface EHOMELoopsTableViewController ()

@property (nonatomic, strong) NSMutableArray *loopsArray;

@end

@implementation EHOMELoopsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Repeat", nil);
    
    UIBarButtonItem *Cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = Cancel;
    
    UIBarButtonItem *Done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneLoopsAction)];
    self.navigationItem.rightBarButtonItem = Done;
    
    self.loopsArray = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pop{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneLoopsAction{
    
    self.loopsblock(self.loopsArray);

    [self pop];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else{
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"Never", nil);
        
        if ([self.loopsArray containsObject:@(1)]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = THEMECOLOR;
        }
        
    }else{
        cell.textLabel.text = @[NSLocalizedStringFromTable(@"Sunday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Saturday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Friday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Thursday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Wednesday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Tuesday", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Monday", @"DeviceFunction", nil)][indexPath.row];
        
        if ([self.loopsArray[indexPath.row] isEqual:@(1)]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = THEMECOLOR;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self.loopsArray removeAllObjects];
        [self.loopsArray addObjectsFromArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0)]];
        [tableView reloadData];
    }else{
        
        NSNumber *number = self.loopsArray[indexPath.row];
        
        if ([number isEqualToNumber:@(0)]) {
            [self.loopsArray replaceObjectAtIndex:indexPath.row withObject:@(1)];
        }else{
            [self.loopsArray replaceObjectAtIndex:indexPath.row withObject:@(0)];
        }
        
        [tableView reloadData];
    }
    
}

@end
