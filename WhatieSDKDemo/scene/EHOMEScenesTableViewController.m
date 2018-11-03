//
//  EHOMEScenesTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/11.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define manualSceneCellId @"EHOMEManualSceneCell"
#define timingSceneCellId @"EHOMETimingSceneCell"
#define emptyCellId @"EHOMESceneEmptyTableViewCell"

#import "EHOMEScenesTableViewController.h"
#import "EHOMEManualSceneCell.h"
#import "EHOMETimingSceneCell.h"
#import "EHOMESceneEmptyTableViewCell.h"
#import "LHCustomModalTransition.h"
#import "EHOMEAddIntelligenceVC.h"
#import "EHOMEIntelligentSettingTableViewController.h"
#import "LrdAlertTableView.h"

@interface EHOMEScenesTableViewController ()<ExecuteSceneDelegate,addSceneDelegate>
@property (nonatomic, strong) NSArray *ManualScenes;
@property (nonatomic, strong) NSArray *TimingScenes;
@property (nonatomic, strong) LHCustomModalTransition *transition;
@end

@implementation EHOMEScenesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Scene", nil);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addSceneAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    //注册接收通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSettingAction:) name:@"GotoIntelligentSetting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"RefreshScene" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSCeneList) name:@"currentHomeIsExchanged" object:nil];
    
    [self initTableView];
}

-(void)refreshTableView{
    [self.tableView.mj_header beginRefreshing];
}

-(void)gotoSettingAction:(NSNotification *)notification{
    EHOMEIntelligentSettingTableViewController *addvc = [[EHOMEIntelligentSettingTableViewController alloc] initWithNibName:@"EHOMEIntelligentSettingTableViewController" bundle:nil];
    addvc.isAddScene = YES;
    if([[notification.userInfo objectForKey:@"type"] isEqualToString:@"timing"]){
        addvc.isManual = NO;
    }else{
        addvc.isManual = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    [addvc setRefreshScene:^(BOOL isRefresh) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    
    [self.navigationController pushViewController:addvc animated:YES];
    
}

-(void)refreshSCeneList{
    [self.tableView.mj_header beginRefreshing];
    [self getScenesFromDB];
}

-(void)initTableView{
    self.tableView.backgroundColor =RGB(240, 240, 240);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEManualSceneCell" bundle:nil] forCellReuseIdentifier:manualSceneCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMETimingSceneCell" bundle:nil] forCellReuseIdentifier:timingSceneCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMESceneEmptyTableViewCell" bundle:nil] forCellReuseIdentifier:emptyCellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullScenesList];
    }];
    
//    [self.tableView.mj_header beginRefreshing];
    
    //1.从本地数据库中获取场景的列表显示
    [self getScenesFromDB];
    
    
    //2.从后台获取场景列表
    [self pullScenesList];
}

-(void)getScenesFromDB{
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        
        EHOMEHomeModel *currenthome = responseObject;
        
        NSArray *scenes = [EHOMEDataStore getScenesFromDBWithHomeId:currenthome.id];
        
        NSMutableArray *timingAry = [NSMutableArray array];
        NSMutableArray *manualAry = [NSMutableArray array];
        for(EHOMESceneModel *scenemodel in scenes){
            
            for (EHOMESceneDeviceModel *m in scenemodel.sceneDeviceVos) {
                NSLog(@"type = %@",m.mj_JSONString);
            }
            
            if(scenemodel.scene.type == 0){
                [timingAry addObject:scenemodel];
            }else if(scenemodel.scene.type == 1){
                [manualAry addObject:scenemodel];
            }
        }
        self.TimingScenes = timingAry;
        self.ManualScenes = manualAry;

//        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"Get current home failed.error = %@", error);
        [self.tableView reloadData];
    }];
}

-(void)pullScenesList{
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        
        EHOMEHomeModel *currenthome = responseObject;
        
        [currenthome syncSceneByHomeSuccess:^(id responseObject) {
            NSLog(@"Get cscenes success. = %@", responseObject);
            
            
            //当前家庭下面的场景列表获取成功,存档至数据库
            [EHOMEDataStore setScenesToDBWithScenes:responseObject inHome:currenthome.id];
            
            
            NSMutableArray *timingAry = [NSMutableArray array];
            NSMutableArray *manualAry = [NSMutableArray array];
            for(EHOMESceneModel *scenemodel in responseObject){
                if(scenemodel.scene.type == 0){
                    [timingAry addObject:scenemodel];
                }else if(scenemodel.scene.type == 1){
                    [manualAry addObject:scenemodel];
                }
            }
            self.TimingScenes = timingAry;
            self.ManualScenes = manualAry;
            
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
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        //空的场景
        return 1;
    }else{
        if(section == 0){
            return self.ManualScenes.count;
        }else{
            return self.TimingScenes.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        
        EHOMESceneEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCellId];
        
        if (!cell) {
            cell = [[EHOMESceneEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellId];
        }
        
        cell.delegate = self;
        
        return cell;
        
    }else{
        if(indexPath.section == 0){
            EHOMEManualSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:manualSceneCellId forIndexPath:indexPath];
            
            if (!cell) {
                cell = [[EHOMEManualSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manualSceneCellId];
            }
            cell.MSceneModel = self.ManualScenes[indexPath.row];
            cell.delegate = self;
            return cell;
        }else{
            EHOMETimingSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:timingSceneCellId forIndexPath:indexPath];
            
            if (!cell) {
                cell = [[EHOMETimingSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timingSceneCellId];
            }
            cell.TSceneModel = self.TimingScenes[indexPath.row];
            return cell;
        }
    }
    
}


#pragma mark - Table view delegate

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        return @[];
    }else{
        
        NSString *title = NSLocalizedStringFromTable(@"Remove", @"Profile", nil);
        
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Remove Scene", nil) message:NSLocalizedString(@"sure remove scene", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Remove", @"Profile", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Removing", @"Device", nil) hideAfterDelay:10];
                
                EHOMESceneModel *model;
                if(indexPath.section == 0){
                    model = self.ManualScenes[indexPath.row];
                }else{
                    model = self.TimingScenes[indexPath.row];
                }
                
                [model removeScenesuccess:^(id responseObject) {
                    [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                    [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Removing scene successfully", nil) hideAfterDelay:1.0];
                    
                    NSLog(@"remove success = %@", model.scene.name);
                    
                    //从数据库中删除当前的场景
                    [EHOMEDataStore removeSceneFromDB:model InHomeId:model.scene.homeId];
                    
                    NSMutableArray *currentArray;
                    if(indexPath.section == 0){
                        currentArray = [NSMutableArray arrayWithArray:self.ManualScenes];
                        [currentArray removeObject:model];
                        self.ManualScenes = currentArray;
                    }else{
                        currentArray = [NSMutableArray arrayWithArray:self.TimingScenes];
                        [currentArray removeObject:model];
                        self.TimingScenes = currentArray;
                    }
                    [self.tableView reloadData];
                } failure:^(NSError *error) {
                    NSLog(@"remove failed = %@", error);
                    [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                    [HUDHelper showErrorDomain:error];
                }];
                
            }];
            
            [alertView addAction:cancel];
            [alertView addAction:ok];
            
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        deleteRowAction.backgroundColor =RGB(255, 56, 38);
        
        return @[deleteRowAction];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        return NO;
    }else{
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        
    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EHOMEIntelligentSettingTableViewController *editSceneVC = [[EHOMEIntelligentSettingTableViewController alloc] initWithNibName:@"EHOMEIntelligentSettingTableViewController" bundle:nil];
        editSceneVC.isAddScene = NO;
        if(indexPath.section == 0){
            editSceneVC.Scene = self.ManualScenes[indexPath.row];
            editSceneVC.isManual = YES;
        }else{
            editSceneVC.Scene = self.TimingScenes[indexPath.row];
            editSceneVC.isManual = NO;
        }
        NSLog(@"到底有多少个啊！！=%lu",(unsigned long)editSceneVC.Scene.sceneDeviceVos.count);
        __weak typeof(self) weakSelf = self;
        [editSceneVC setRefreshScene:^(BOOL isRefresh) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        [self.navigationController pushViewController:editSceneVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        return tableView.frame.size.height - 49;
    }else{
        return 200.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 44.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;;
    headerLabel.highlightedTextColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.frame = CGRectMake(15, 16.0, 300.0, 20.0);
    if(section == 0){
        headerLabel.text = NSLocalizedString(@"Manual execution", nil);
    }else{
        headerLabel.text = NSLocalizedString(@"Timing execution", nil);
    }
    [customView addSubview:headerLabel];
    
    if (section == 0) {
        if(self.ManualScenes.count == 0){
            return nil;
        }else{
            return customView;
        }
    }else{
        if(self.TimingScenes.count == 0){
            return nil;
        }else{
            return customView;
        }
    }

    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.ManualScenes.count == 0 && self.TimingScenes.count == 0) {
        return 0.001;
    }else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(void)addSceneAction{
//    EHOMEAddSceneTableViewController *addSceneVC = [[EHOMEAddSceneTableViewController alloc] initWithNibName:@"EHOMEAddSceneTableViewController" bundle:nil];
//    addSceneVC.isEditScene = NO;
//
//    __weak typeof(self) weakSelf = self;
//    [addSceneVC setRefreshScene:^(BOOL isRefresh) {
//        [weakSelf.tableView.mj_header beginRefreshing];
//    }];
//    [self.navigationController pushViewController:addSceneVC animated:YES];
    
    
    //---初始化要弹出跳转的视图控制器
    EHOMEAddIntelligenceVC *addVC = [[EHOMEAddIntelligenceVC alloc] initWithNibName:@"EHOMEAddIntelligenceVC" bundle:nil];
//    //---必须强引用，否则会被释放，自定义dismiss的转场无效
//    self.transition = [[LHCustomModalTransition alloc]initWithModalViewController:addVC];
//    self.transition.dragable = YES;//---是否可下拉收起
//    addVC.transitioningDelegate = self.transition;
//    //---必须添加这句.自定义转场动画
//    addVC.modalPresentationStyle = UIModalPresentationCustom;
    
    EHOMENavigationController *addSceneNav = [[EHOMENavigationController alloc] initWithRootViewController:addVC];

    [self presentViewController:addSceneNav animated:YES completion:nil];
}

-(void)gotoExecuteSceneWithScene:(EHOMESceneModel *)model{
    if(model.sceneDeviceVos != nil && ![model.sceneDeviceVos isKindOfClass:[NSNull class]] && model.sceneDeviceVos.count != 0){
        [model executeManualScene:^(id responseObject) {
            NSLog(@"立即执行成功");
            
            NSMutableArray *mutableDevices = [NSMutableArray array];
            for(EHOMESceneDeviceModel *scenedevice in model.sceneDeviceVos){
                EHOMESceneDeviceModel *model = [scenedevice copy];
                model.executeSuccess = 0;
                [mutableDevices addObject:model];
            }
            NSArray *sceneDeviceArray = mutableDevices;
            LrdAlertTableView *view = [[LrdAlertTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H)];
            //传入数据
            view.dataArray = sceneDeviceArray;
            view.SceneName = model.scene.name;
            
            [view pop];
        } failure:^(NSError *error) {
            NSLog(@"立即执行失败");
        }];
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"No device in this scene", nil) hideAfterDelay:1];
    }
    
}


-(void)addSceneCellAction{
    [self addSceneAction];
}

@end
