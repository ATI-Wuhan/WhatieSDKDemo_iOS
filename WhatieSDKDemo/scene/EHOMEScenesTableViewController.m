//
//  EHOMEScenesTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define manualSceneCellId @"EHOMEManualSceneCell"
#define timingSceneCellId @"EHOMETimingSceneCell"

#import "EHOMEScenesTableViewController.h"
#import "EHOMEManualSceneCell.h"
#import "EHOMETimingSceneCell.h"
#import "EHOMEAddSceneTableViewController.h"

@interface EHOMEScenesTableViewController ()
@property (nonatomic, strong) NSArray *ManualScenes;
@property (nonatomic, strong) NSArray *TimingScenes;
@end

@implementation EHOMEScenesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Smart Scenes", nil);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addSceneAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self initTableView];
}

-(void)initTableView{
    self.tableView.backgroundColor =RGB(240, 240, 240);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEManualSceneCell" bundle:nil] forCellReuseIdentifier:manualSceneCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMETimingSceneCell" bundle:nil] forCellReuseIdentifier:timingSceneCellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullScenesList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)pullScenesList{
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        
        EHOMEHomeModel *currenthome = responseObject;
        
        [currenthome syncSceneByHomeSuccess:^(id responseObject) {
            //self.scenes = responseObject;
            NSLog(@"Get cscenes success. = %@", responseObject);
            
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        EHOMEManualSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:manualSceneCellId forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[EHOMEManualSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manualSceneCellId];
        }
        cell.manualSceneName.text = @"Back home";
        [cell.deviceImage1 setImage:[UIImage imageNamed:@"bulb-Icon"]];
        [cell.deviceImage1 setImage:[UIImage imageNamed:@"socket-Icon"]];
        return cell;
    }else{
        EHOMETimingSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:timingSceneCellId forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[EHOMETimingSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timingSceneCellId];
        }
        cell.timingSceneName.text = @"Leave home";
        [cell.DeviceImage1 setImage:[UIImage imageNamed:@"bulb-Icon"]];
        [cell.DeviceImage2 setImage:[UIImage imageNamed:@"socket-Icon"]];
        cell.timeLabel.text = @"09:00";
        return cell;
    }
}


#pragma mark - Table view delegate

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //EHOMESceneModel *model = self.scenes[indexPath.row];

    NSString *title = NSLocalizedStringFromTable(@"Remove", @"Profile", nil);

    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Remove Scene", nil) message:NSLocalizedString(@"sure remove scene", nil) preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Remove", @"Profile", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

//            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Removing", @"Device", nil) hideAfterDelay:10];
//
//            [model removeScenesuccess:^(id responseObject) {
//                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
//                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Removing scene successfully", nil) hideAfterDelay:1.0];
//
//                NSLog(@"remove success = %@", model.scene.name);
//
//                NSMutableArray *currentArray = [NSMutableArray arrayWithArray:self.scenes];
//                [currentArray removeObject:model];
//                self.scenes = currentArray;
//                [self.tableView reloadData];
//            } failure:^(NSError *error) {
//                NSLog(@"remove failed = %@", error);
//                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
//                [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
//            }];

        }];

        [alertView addAction:cancel];
        [alertView addAction:ok];

        [self presentViewController:alertView animated:YES completion:nil];
    }];
    deleteRowAction.backgroundColor =RGB(255, 56, 38);

    return @[deleteRowAction];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    EHOMEAddSceneTableViewController *editSceneVC = [[EHOMEAddSceneTableViewController alloc] initWithNibName:@"EHOMEAddSceneTableViewController" bundle:nil];
//    editSceneVC.Scene = self.scenes[indexPath.row];
//    editSceneVC.isEditScene = YES;
//    
//    EHOMESceneModel *smodel = self.scenes[indexPath.row];
//    if(smodel.sceneDeviceVos.count ==0){
//        NSLog(@"wuawua");
//    }
//    for(EHOMESceneDeviceModel *model in smodel.sceneDeviceVos){
//        NSLog(@"产品的类型= %d",model.device.product.productType);
//    }
//    
//    __weak typeof(self) weakSelf = self;
//    [editSceneVC setRefreshScene:^(BOOL isRefresh) {
//        [weakSelf.tableView.mj_header beginRefreshing];
//    }];
//    [self.navigationController pushViewController:editSceneVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 设置section字体颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightHeavy]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(20, 0.0, 300.0, 44.0)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont italicSystemFontOfSize:20];
    headerLabel.frame = CGRectMake(40.0, 0.0, 300.0, 44.0);
    if(section == 0){
        headerLabel.text = @"Manual executation";
    }else{
        headerLabel.text = @"Timing executation";
    }
    
    [customView addSubview:headerLabel];
    [headerLabel release];
    
    return [customView autorelease];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return 44.0;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return @"Manual execution";
    }else{
        return @"Timing execution";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)addSceneAction{
    EHOMEAddSceneTableViewController *addSceneVC = [[EHOMEAddSceneTableViewController alloc] initWithNibName:@"EHOMEAddSceneTableViewController" bundle:nil];
    addSceneVC.isEditScene = NO;
    
    __weak typeof(self) weakSelf = self;
    [addSceneVC setRefreshScene:^(BOOL isRefresh) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    [self.navigationController pushViewController:addSceneVC animated:YES];
}

@end
