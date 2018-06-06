//
//  EHOMEFeedbackTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

static NSString *cellId = @"EHOMEFeedbackTableViewCell";

#import "EHOMEFeedbackTableViewController.h"
#import "EHOMEAddFeedbackViewController.h"

#import "EHOMEFeedbackTableViewCell.h"

@interface EHOMEFeedbackTableViewController ()

@property (nonatomic, strong) NSArray *feedbackArray;

@end

@implementation EHOMEFeedbackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Feedback";
    
    UIBarButtonItem *addFeedbackItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addFeedback)];
    self.navigationItem.rightBarButtonItem = addFeedbackItem;
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getFeedbackList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEFeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addFeedback{
    EHOMEAddFeedbackViewController *addFeedbackVC = [[EHOMEAddFeedbackViewController alloc] initWithNibName:@"EHOMEAddFeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:addFeedbackVC animated:YES];
}

-(void)getFeedbackList{
    [[EHOMEUserModel shareInstance] getFeedbackListWithPage:1 size:10 success:^(id responseObject) {
        NSLog(@"get feedback list success. res = %@", responseObject);
        
        self.feedbackArray = [[responseObject objectForKey:@"page"] objectForKey:@"list"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"get feedback list failed. error = %@", error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.feedbackArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMEFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEFeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.feedbackLabel.text = [self.feedbackArray[indexPath.row] objectForKey:@"content"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}



@end
