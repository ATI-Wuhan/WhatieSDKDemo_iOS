//
//  EHOMESharedDeviceTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/6/6.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define cellId @"EHOMEHomeTableViewCell"
#define EHOMESharedOutUserTableViewCellId @"EHOMESharedOutUserTableViewCell"
#define EHOMEDefaultEmptyTableViewCellId @"EHOMEDefaultEmptyTableViewCell"

#import "EHOMESharedDeviceTableViewController.h"
#import "EHOMERGBLightViewController.h"
#import "EHOMEOutletDetailViewController.h"

#import "EHOMEHomeTableViewCell.h"
#import "EHOMESharedOutUserTableViewCell.h"
#import "EHOMEDefaultEmptyTableViewCell.h"

@interface EHOMESharedDeviceTableViewController ()

@property (nonatomic, assign) BOOL isSharedOut;

@property (nonatomic, strong) NSMutableDictionary *sharedOutDic;

@property (nonatomic, assign) BOOL isLoadingShared;
@property (nonatomic, assign) BOOL isLoadingSharedOut;

@end

@implementation EHOMESharedDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = NSLocalizedStringFromTable(@"Shared Devices", @"Profile", nil);
    
    self.tableView.backgroundColor = GREYCOLOR;
    self.tableView.tableFooterView = [UIView new];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"收到的分享",@"分享出去的"]];
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
    
    [segmentedControl addTarget:self action:@selector(clickedSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    self.isSharedOut = NO;
    self.sharedOutDic = [NSMutableDictionary dictionary];
    self.isLoadingShared = YES;
    self.isLoadingSharedOut = YES;
    
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name: EHOMEUserNotificationSharedDeviceArrayChanged object:nil];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEHomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMESharedOutUserTableViewCell" bundle:nil] forCellReuseIdentifier:EHOMESharedOutUserTableViewCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEDefaultEmptyTableViewCell" bundle:nil] forCellReuseIdentifier:EHOMEDefaultEmptyTableViewCellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullDownRefresh];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void) reloadData {
    //可以在这里刷新UI
    
    NSLog(@"[EHOMEUserModel shareInstance].deviceArray 有变更");
    
    [self.tableView reloadData];
    
}

-(void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)clickedSegmentedControl:(UISegmentedControl *)segmentedControl{
    if (segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"收到的分享设备列表");
        
        self.isSharedOut = NO;
        
        [self.tableView reloadData];
        
        if ([EHOMEUserModel shareInstance].sharedDeviceArray.count == 0) {
            [self.tableView.mj_header beginRefreshing];
        }
    }else{
        NSLog(@"分享出去的设备列表");
        
        self.isSharedOut = YES;
        
        [self.tableView reloadData];
        
        if ([[self.sharedOutDic allKeys] count] == 0) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}


-(void)pullDownRefresh{

    if (self.isSharedOut) {
        [[EHOMEUserModel shareInstance] syncSharedOutDeviceWithCloud:^(id responseObject) {
            NSLog(@"分享出去的设备列表res = %@", responseObject);
            
            [self.sharedOutDic removeAllObjects];
            
            for (EHOMEDeviceModel *model in responseObject) {

                if ([[self.sharedOutDic allKeys] containsObject:model.device.devId]) {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.sharedOutDic[model.device.devId]];
                    [tempArray addObject:model];
                    self.sharedOutDic[model.device.devId] = tempArray;
                }else{
                    self.sharedOutDic[model.device.devId] = @[model];
                }
            }
            
            self.isLoadingSharedOut = NO;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"分享出去的设备列表error = %@", error);
            self.isLoadingSharedOut = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    }else{
        
        [[EHOMEUserModel shareInstance] syncSharedDeviceWithCloud:^(id responseObject) {
            NSLog(@"Get shared devices successful : %@", responseObject);
            
            self.isLoadingShared = NO;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"Get shared devices failed : %@", error);
            
            self.isLoadingShared = NO;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSharedOut) {

        if (self.isLoadingSharedOut) {
            return [[self.sharedOutDic allKeys] count] > 0 ? [[self.sharedOutDic allKeys] count] : 0;
        }else{
            return [[self.sharedOutDic allKeys] count] > 0 ? [[self.sharedOutDic allKeys] count] : 1;
        }
        
    }else{
        if (self.isLoadingShared) {
            return [EHOMEUserModel shareInstance].sharedDeviceArray.count > 0 ? [EHOMEUserModel shareInstance].sharedDeviceArray.count : 0;
        }else{
            return [EHOMEUserModel shareInstance].sharedDeviceArray.count > 0 ? [EHOMEUserModel shareInstance].sharedDeviceArray.count : 1;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSharedOut) {
        if ([[self.sharedOutDic allKeys] count] > 0) {
            NSArray *users = [self.sharedOutDic allValues][section];
            return [users count];
        }else{
            return 1;
        }

    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSharedOut) {
        
        if ([[self.sharedOutDic allKeys] count] > 0) {
            
            EHOMESharedOutUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EHOMESharedOutUserTableViewCellId forIndexPath:indexPath];
            
            if (!cell) {
                cell = [[EHOMESharedOutUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EHOMESharedOutUserTableViewCellId];
            }
            
            EHOMEDeviceModel *model = [self.sharedOutDic allValues][indexPath.section][indexPath.row];
            
            cell.userNameLabel.text = model.customer.email;
            [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.customer.portraitThumb.path] placeholderImage:[UIImage imageNamed:@"avatar"]];
            
            return cell;
        }else{
            EHOMEDefaultEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EHOMEDefaultEmptyTableViewCellId];
            if (!cell) {
                cell = [[EHOMEDefaultEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EHOMEDefaultEmptyTableViewCellId];
            }
            
            cell.emptyTitleLabel.text = NSLocalizedStringFromTable(@"NoSharedOutEmptyTitle", @"Empty", @"没有设备");
            cell.emptyDescriptionLabel.text = NSLocalizedStringFromTable(@"NoSharedOutEmptyDes", @"Empty", @"没有设备");
            
            return cell;
        }

    }else{
        
        if ([EHOMEUserModel shareInstance].sharedDeviceArray.count > 0) {
            
            EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            if (!cell) {
                cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            
            cell.deviceModel = [EHOMEUserModel shareInstance].sharedDeviceArray[indexPath.section];
            
            return cell;
        }else{
            EHOMEDefaultEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EHOMEDefaultEmptyTableViewCellId];
            if (!cell) {
                cell = [[EHOMEDefaultEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EHOMEDefaultEmptyTableViewCellId];
            }
            
            cell.emptyTitleLabel.text = NSLocalizedStringFromTable(@"NoSharedDevicesEmptyTitle", @"Empty", @"没有分享");
            cell.emptyDescriptionLabel.text = NSLocalizedStringFromTable(@"NoSharedDevicesEmptyDes", @"Empty", @"没有设备");
            
            return cell;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.isSharedOut) {
        
        if ([[self.sharedOutDic allKeys] count] > 0) {
            
            EHOMEDeviceModel *model = [[self.sharedOutDic allValues][section] firstObject];
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, 60)];
            headerView.backgroundColor = GREYCOLOR;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [headerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(15);
                make.width.height.mas_equalTo(30);
                make.centerY.mas_equalTo(headerView);
            }];
            
            UILabel *deviceNameLabel = [[UILabel alloc] init];
            deviceNameLabel.font = [UIFont boldSystemFontOfSize:14];
            [headerView addSubview:deviceNameLabel];
            
            [deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(imageView.mas_right).mas_offset(8);
                make.top.bottom.mas_equalTo(imageView);
                make.trailing.mas_equalTo(-8);
            }];
            
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.device.product.pictureThumb.path] placeholderImage:nil];
            deviceNameLabel.text = model.device.name;
            
            
            return headerView;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isSharedOut) {
        if ([[self.sharedOutDic allValues] count] > 0) {
            EHOMEDeviceModel *model = [self.sharedOutDic allValues][indexPath.section][indexPath.row];
            [self recallSharing:model];
        }else{

        }
    }else{
        
        if ([EHOMEUserModel shareInstance].sharedDeviceArray.count > 0) {
            
            EHOMEDeviceModel *device = [EHOMEUserModel shareInstance].sharedDeviceArray[indexPath.section];
            
            
            NSArray *products = @[@"RgbLight",@"Plug"];
            
            NSInteger index = [products indexOfObject:device.productName];
            
            switch (index) {
                case 0:{
                    NSLog(@"Clicked RgbLight");
                    
                    EHOMERGBLightViewController *lightVC = [[EHOMERGBLightViewController alloc] initWithNibName:@"EHOMERGBLightViewController" bundle:nil];
                    
                    lightVC.device = device;
                    
                    [self.navigationController pushViewController:lightVC animated:YES];
                }
                    break;
                    
                case 1:{
                    NSLog(@"Clicked Plug");
                    
                    EHOMEOutletDetailViewController *outletVC = [[EHOMEOutletDetailViewController alloc] initWithNibName:@"EHOMEOutletDetailViewController" bundle:nil];
                    outletVC.device = device;
                    
                    [self.navigationController pushViewController:outletVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }

}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSharedOut) {
        
        if ([[self.sharedOutDic allValues] count] > 0) {
            EHOMEDeviceModel *model = [self.sharedOutDic allValues][indexPath.section][indexPath.row];
            
            NSString *title = NSLocalizedStringFromTable(@"Remove", @"Profile", nil);
            
            UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                
                [self recallSharing:model];
                
            }];
            
            return @[deleteRowAction];
        }else{
            return @[];
        }
    }else{
        
        if ([[EHOMEUserModel shareInstance].sharedDeviceArray count] > 0) {
            EHOMEDeviceModel *model = [EHOMEUserModel shareInstance].sharedDeviceArray[indexPath.section];
            
            NSString *title = NSLocalizedStringFromTable(@"Remove", @"Profile", nil);
            
            UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                
                [model removeDevice:^(id responseObject) {
                    
                    NSLog(@"remove success = %@", responseObject);
                    
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:[EHOMEUserModel shareInstance].sharedDeviceArray];
                    
                    [temp removeObjectAtIndex:indexPath.section];
                    
                    [EHOMEUserModel shareInstance].sharedDeviceArray = temp;
                    
                    [self.tableView reloadData];
                    
                } failure:^(NSError *error) {
                    NSLog(@"remove failed = %@", error);
                }];
                
            }];
            
            return @[deleteRowAction];
        }else{
            return @[];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSharedOut) {
        if ([[self.sharedOutDic allKeys] count] > 0) {
            return 44;
        }else{
            return tableView.frame.size.height;
        }
    }else{
        if ([EHOMEUserModel shareInstance].sharedDeviceArray.count > 0) {
            return 100;
        }else{
            return tableView.frame.size.height;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSharedOut) {
        if ([[self.sharedOutDic allKeys] count] > 0) {
            return 60;
        }else{
            return 0.001;
        }
    }else{
        if ([EHOMEUserModel shareInstance].sharedDeviceArray.count > 0) {
            return 10;
        }else{
            return 0.001;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(void)recallSharing:(EHOMEDeviceModel *)device{
    
    NSString *title = NSLocalizedStringFromTable(@"Alert", @"Alert", @"提示");
    NSString *message = NSLocalizedStringFromTable(@"RemoveSharingDes", @"Alert", @"确认撤回给他人的设备分享");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *cancelString = NSLocalizedStringFromTable(@"Cancel", @"Alert", @"提示");
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    NSString *deleteString = NSLocalizedStringFromTable(@"Remove", @"Alert", @"移除");
    UIAlertAction *delete = [UIAlertAction actionWithTitle:deleteString style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Removing", @"Alert", @"提示") hideAfterDelay:10];
        
        [device recallSharing:^(id responseObject) {
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"RecallSharingSuccess", @"Alert", @"提示") hideAfterDelay:1.0];
            
            [self.tableView.mj_header beginRefreshing];
            
        } failure:^(NSError *error) {
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:delete];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
