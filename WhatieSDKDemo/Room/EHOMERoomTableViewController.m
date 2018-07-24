//
//  EHOMERoomTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define roomcellId @"EHOMEHomeTableViewCell"

#import "EHOMERoomTableViewController.h"
#import "EHOMRoomCell.h"
#import "EHOMERoomDetailTableViewController.h"
#import "EHOMEAddRoomTableViewController.h"

@interface EHOMERoomTableViewController ()

@property (nonatomic, strong) NSMutableArray *rooms;

@end

@implementation EHOMERoomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"Room", @"Room", nil);
    self.rooms = [NSMutableArray array];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addRoomAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self initTableView];
}

-(void)initTableView{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMRoomCell" bundle:nil] forCellReuseIdentifier:roomcellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getRoomList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)getRoomList{
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        
        EHOMEHomeModel *currenthome = responseObject;
        
        [currenthome syncRoomByHomeSuccess:^(id responseObject) {
            self.rooms = responseObject;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Get current home failed.error = %@", error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.rooms.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHOMRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:roomcellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:roomcellId];
    }
    
    cell.roomModel = self.rooms[indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHOMERoomDetailTableViewController *VC = [[EHOMERoomDetailTableViewController alloc] initWithNibName:@"EHOMERoomDetailTableViewController" bundle:nil];
    EHOMERoomModel *model = self.rooms[indexPath.section];
    VC.roomModel = model;
    
    __weak typeof(self) weakSelf = self;
    [VC setDeleteBlock:^(BOOL isDelete) {
        [weakSelf getRoomList];
    }];
    
    [VC setRoomNameBlock:^(NSString *name) {
        model.room.name=name;
        
        [weakSelf.rooms replaceObjectAtIndex:indexPath.section withObject:model];
        [weakSelf.tableView reloadData];
    }];
    
    [VC setRoomBgBlock:^(NSString *path) {
        model.room.backgroundThumb.path=path;
        [weakSelf.rooms replaceObjectAtIndex:indexPath.section withObject:model];
        [weakSelf.tableView reloadData];
    }];
    
    [VC setChangeAccountBlock:^(BOOL isRefresh) {
        [weakSelf getRoomList];
    }];
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(void)addRoomAction{
    EHOMEAddRoomTableViewController *addRoomVC = [[EHOMEAddRoomTableViewController alloc] initWithNibName:@"EHOMEAddRoomTableViewController" bundle:nil];
    
    __weak typeof(self) weakSelf = self;
    [addRoomVC setRefreshRLBlock:^(BOOL isRefresh) {
        [weakSelf getRoomList];
    }];
    [self.navigationController pushViewController:addRoomVC animated:YES];
}

@end
