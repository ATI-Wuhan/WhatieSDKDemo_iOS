//
//  EHOMEAddSceneTableViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define infoCellId @"EHOMEAddSceneInfoTableViewCell"
#define deviceCellId @"EHOMESceneDeviceTableViewCell"
#define failCellId @"EHOMEAddDeviceFailTableViewCell"

#import "EHOMEAddSceneTableViewController.h"
#import "EHOMEAddSceneInfoTableViewCell.h"
#import "EHOMESceneDeviceTableViewCell.h"
#import "EHOMEAddDeviceFailTableViewCell.h"
#import "EHOMESelectTimeViewController.h"
#import "EHOMENavigationController.h"
#import "EHOMELoopsTableViewController.h"
#import "EHOMESceneAddDeviceViewController.h"

@interface EHOMEAddSceneTableViewController ()<deleteFailDeviceDelegate,resetFailDeviceDelegate>

@property (nonatomic, copy) NSString *sceneName;
@property (nonatomic, copy) NSString *sceneTime;
@property (nonatomic, copy) NSString *sceneRepeat;
@property (nonatomic, strong) NSMutableArray *loopsArray;

@property (nonatomic, strong) NSMutableArray *DeviceWithSceneArray;
@property (nonatomic, strong) NSMutableArray *failDeviceSceneArray;
@property (nonatomic, strong) NSMutableArray *DeviceArray;

@end

@implementation EHOMEAddSceneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.DeviceWithSceneArray = [NSMutableArray array];
    self.failDeviceSceneArray = [NSMutableArray array];
    self.DeviceArray = [NSMutableArray array];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addSceneAction)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    if (self.isEditScene) {
        self.title = NSLocalizedString(@"Edit Scene", nil);
        self.sceneName = self.Scene.scene.name;
        self.sceneTime = self.Scene.finishTimeApp;
        
        NSString *loopsString = self.Scene.scene.timerType;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i<self.Scene.scene.timerType.length; i++) {
            int loop = [[loopsString substringWithRange:NSMakeRange(i, 1)] intValue];
            [tempArray addObject:[NSNumber numberWithInt:loop]];
        }
        self.loopsArray = tempArray;
        
        NSLog(@"场景的数量%lu",(unsigned long)self.Scene.sceneDeviceVos.count);
        
        for(EHOMESceneDeviceModel *model in self.Scene.sceneDeviceVos){
            if(model.success){
                [self.DeviceWithSceneArray addObject:model];
            }else{
                [self.failDeviceSceneArray addObject:model];
            }
            NSLog(@"设备的场景id=%d",model.sceneDeviceId);
            NSLog(@"设备的id=%d",model.clockId);
        }
        
    }else{
        self.title = NSLocalizedString(@"Add Scene", nil);
        self.sceneName = NSLocalizedString(@"New Scene", nil);
        self.sceneTime = @"18:00";
        self.loopsArray = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0)]];
    }
    
    NSArray *LA = self.loopsArray;
    [self showDaysWithLoops:LA];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addSceneAction{
    
    NSMutableString *loops = [NSMutableString string];
    for (NSNumber *loop in self.loopsArray) {
        [loops appendString:[loop stringValue]];
    }
    
    if(self.isEditScene){
        NSLog(@"Edit Scene...");
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Editting scene...", nil) hideAfterDelay:10.0];
        
        //deviceIds
        NSMutableArray *SceneWithDeviceIdArray = [NSMutableArray array];
        NSMutableArray *DeviceIdArray = [NSMutableArray array];
        //dps
        NSMutableArray *SceneDeviceDpsArray = [NSMutableArray array];
        NSMutableArray *DeviceDpsArray = [NSMutableArray array];
        //sceneDeviceId
        NSMutableArray *SceneWithSceneDevIdArray = [NSMutableArray array];
        NSMutableArray *SceneDevIdArray = [NSMutableArray array];
        
        for (EHOMESceneDeviceModel *SceneDevice in self.DeviceWithSceneArray) {
            [SceneWithDeviceIdArray addObject:@(SceneDevice.device.id)];
            [SceneDeviceDpsArray addObject:SceneDevice.dps];
            [SceneWithSceneDevIdArray addObject:@(SceneDevice.sceneDeviceId)];
        }
        
        for (EHOMEDeviceModel *model in self.DeviceArray) {
            [DeviceIdArray addObject:@(model.device.id)];
            NSString *statusStr;
            if (model.sceneActionStatus) {
                statusStr = @"true_true";
            }else{
                statusStr = @"false_false";
            }
            [DeviceDpsArray addObject:statusStr];
            [SceneDevIdArray addObject:@(-1)];
        }
        
        NSArray *array1 = SceneWithDeviceIdArray;
        NSArray *array2 = DeviceIdArray;
        NSArray *allDeviceId = [array1 arrayByAddingObjectsFromArray:array2];
        
        NSArray *array3 = SceneDeviceDpsArray;
        NSArray *array4 = DeviceDpsArray;
        NSArray *allDeviceDps = [array3 arrayByAddingObjectsFromArray:array4];
        
        NSArray *array5 = SceneWithSceneDevIdArray;
        NSArray *array6 = SceneDevIdArray;
        NSArray *allsceneDevId = [array5 arrayByAddingObjectsFromArray:array6];
        
        for(int i=0;i<allsceneDevId.count;i++){
            NSLog(@"新增设备的scenedeviceid=%@",allsceneDevId[i]);
        }
        
        for(int i=0;i<allDeviceId.count;i++){
            NSLog(@"新增设备的id=%@",allDeviceId[i]);
        }
        
        for(int i=0;i<allDeviceDps.count;i++){
            NSLog(@"新增设备的状态=%@",allDeviceDps[i]);
        }
        
        [self.Scene EditSceneWithName:self.sceneName finishTime:self.sceneTime loops:loops deviceIds:allDeviceId functionArray:allDeviceDps sceneDeviceIds:allsceneDevId success:^(id responseObject) {
            NSLog(@"Edit scene success. res = %@", responseObject);
            self.RefreshScene(YES);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Edit scene success.", nil) hideAfterDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"Edit scene failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
        
    }else{
        NSLog(@"Add Scene...");
        
        NSArray *models = self.DeviceArray;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Adding scene...", nil) hideAfterDelay:10.0];
        
        [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
            
            EHOMEHomeModel *home = responseObject;
            
            [home addSceneWithName:self.sceneName time:self.sceneTime loops:loops actionDeviceArray:models success:^(id responseObject) {
                NSLog(@"Add scene success. res = %@", responseObject);
                self.RefreshScene(YES);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Add scene success.", nil) hideAfterDelay:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            } failue:^(NSError *error) {
                NSLog(@"Add scene failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
            }];
            
            
        } failure:^(NSError *error) {
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:error.domain hideAfterDelay:1.0];
        }];
    }
}

-(void)initTableView{
    
    self.tableView.backgroundColor = GREYCOLOR;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEAddSceneInfoTableViewCell" bundle:nil] forCellReuseIdentifier:infoCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMESceneDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:deviceCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEAddDeviceFailTableViewCell" bundle:nil] forCellReuseIdentifier:failCellId];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_W, 180)];
    footer.backgroundColor = [UIColor clearColor];
    
    UIButton *addDeviceButton = [[UIButton alloc] init];
    addDeviceButton.backgroundColor = THEMECOLOR;
    addDeviceButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [addDeviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addDeviceButton setTitle:NSLocalizedStringFromTable(@"Add Device", @"Device", nil) forState:UIControlStateNormal];
    [addDeviceButton addTarget:self action:@selector(addSceneDevice) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:addDeviceButton];
    addDeviceButton.layer.masksToBounds = YES;
    addDeviceButton.layer.cornerRadius = 12.0;
    
    [addDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
        make.height.mas_equalTo(60);
        make.centerY.mas_equalTo(footer).mas_offset(-20);
    }];
    
    self.tableView.tableFooterView = footer;
}

-(void)addSceneDevice{
    EHOMESceneAddDeviceViewController *addDeviceVC = [[EHOMESceneAddDeviceViewController alloc] initWithNibName:@"EHOMESceneAddDeviceViewController" bundle:nil];
    
    __weak typeof(self) weakSelf = self;
    
    [addDeviceVC setAddSceneDeviceBlock:^(EHOMEDeviceModel *deviceModel) {
        NSLog(@"当前选择的场景设备 %d状态为 = %d",deviceModel.device.id, deviceModel.sceneActionStatus);
        
        [weakSelf.DeviceArray addObject:deviceModel];
        for(EHOMEDeviceModel *model in weakSelf.DeviceArray){
            NSLog(@"场景设备%d状态为 = %d和clockId= %d ",model.device.id,model.sceneActionStatus,model.sceneClockId);
        }
        [weakSelf.tableView reloadData];
        
        
    }];
    
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if(self.isEditScene){
        return 4;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else{
        if(self.isEditScene){
            if(section == 1){
                return self.failDeviceSceneArray.count;
            }else if(section == 2){
                return self.DeviceWithSceneArray.count;
            }else{
                return self.DeviceArray.count;
            }
            
        }else{
            return self.DeviceArray.count;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        EHOMEAddSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[EHOMEAddSceneInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellId];
        }
        
        cell.sceneTitleLabel.text = @[NSLocalizedStringFromTable(@"Name", @"Info", nil),NSLocalizedStringFromTable(@"Time", @"DeviceFunction", nil),NSLocalizedString(@"Repeat", nil)][indexPath.row];
        if(indexPath.row == 0){
            cell.sceneContentLabel.text = self.sceneName;
        }else if (indexPath.row == 1){
            cell.sceneContentLabel.text = self.sceneTime;
        }else{
            cell.sceneContentLabel.text = self.sceneRepeat;
        }
        
        return cell;
    }else{
        
        EHOMESceneDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceCellId];
        
        if (!cell) {
            cell = [[EHOMESceneDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deviceCellId];
        }

        if(self.isEditScene){
            if(indexPath.section == 1){
                EHOMEAddDeviceFailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:failCellId];
                
                if (!cell1) {
                    cell1 = [[EHOMEAddDeviceFailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:failCellId];
                }
                
                EHOMESceneDeviceModel *failmodel = self.failDeviceSceneArray[indexPath.row];
                [cell1.sceneDeviceImageView sd_setImageWithURL:[NSURL URLWithString:failmodel.device.product.picture.path]];
                cell1.deviceNameLabel.text = failmodel.device.name;
                cell1.delegate1 = self;
                cell1.delegate2 = self;
                cell1.indexPath = indexPath;
                return cell1;
            }else{
                
                if(indexPath.section == 2){
                    EHOMESceneDeviceModel *model1 = self.DeviceWithSceneArray[indexPath.row];
                    [cell.sceneDeviceImageView sd_setImageWithURL:[NSURL URLWithString:model1.device.product.picture.path]];
                    cell.sceneDeviceNameLabel.text = model1.device.name;
                    if ([model1.dps isEqualToString:@"true_true"]) {
                        cell.sceneDeviceInfoLabel.text = NSLocalizedString(@"Turn On", nil);
                    }else{
                        cell.sceneDeviceInfoLabel.text = NSLocalizedString(@"Turn Off", nil);
                    }
                    //cell.deviceModel = self.DeviceWithSceneArray[indexPath.row];
                }else{
                    EHOMEDeviceModel *model2 = self.DeviceArray[indexPath.row];
                    [cell.sceneDeviceImageView sd_setImageWithURL:[NSURL URLWithString:model2.device.product.picture.path]];
                    cell.sceneDeviceNameLabel.text = model2.device.name;
                    if (model2.sceneActionStatus) {
                        cell.sceneDeviceInfoLabel.text = NSLocalizedString(@"Turn On", nil);
                    }else{
                        cell.sceneDeviceInfoLabel.text = NSLocalizedString(@"Turn Off", nil);
                    }
                    //cell.deviceModel = self.DeviceArray[indexPath.row];
                }
                
                return cell;
            }
        }else{
            EHOMEDeviceModel *model3 = self.DeviceArray[indexPath.row];
            [cell.sceneDeviceImageView sd_setImageWithURL:[NSURL URLWithString:model3.device.product.picture.path]];
            cell.sceneDeviceNameLabel.text = model3.device.name;
            if (model3.sceneActionStatus) {
                cell.sceneDeviceInfoLabel.text = NSLocalizedString(@"Turn On", nil);
            }else{
                cell.sceneDeviceInfoLabel.text = NSLocalizedString(@"Turn Off", nil);
            }
            //cell.deviceModel = self.DeviceArray[indexPath.row];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Set Name", nil) message:NSLocalizedString(@"Set your scene name here.", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = NSLocalizedString(@"Please key scene name", nil);
                textField.text = self.sceneName;
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *textFieldText = [[alertController textFields] firstObject].text;
                self.sceneName = textFieldText;
                [self.tableView reloadData];
            }];
            
            [alertController addAction:cancel];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (indexPath.row == 1){
            EHOMESelectTimeViewController *timeVC = [[EHOMESelectTimeViewController alloc] initWithNibName:@"EHOMESelectTimeViewController" bundle:nil];
            EHOMENavigationController *setTime = [[EHOMENavigationController alloc] initWithRootViewController:timeVC];
            
            __weak typeof(self) weakSelf = self;
            
            [timeVC setTimeblock:^(NSString *time) {
                weakSelf.sceneTime = time;
                [weakSelf.tableView reloadData];
            }];
            [self presentViewController:setTime animated:YES completion:nil];
        }else{
            EHOMELoopsTableViewController *loopsVC = [[EHOMELoopsTableViewController alloc] initWithNibName:@"EHOMELoopsTableViewController" bundle:nil];
            EHOMENavigationController *setLoops = [[EHOMENavigationController alloc] initWithRootViewController:loopsVC];
            
            __weak typeof(self) weakSelf = self;
            
            [loopsVC setLoopsblock:^(NSArray *loops) {
                NSLog(@"loops = %@", loops);
                [weakSelf showDaysWithLoops:loops];
            }];

            [self presentViewController:setLoops animated:YES completion:nil];
        }
    }
}

-(void)showDaysWithLoops:(NSArray *)loops{
    
    NSArray *WEEK = @[NSLocalizedStringFromTable(@"Sun", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Sat", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Fri", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Thu", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Wed", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Tue", @"DeviceFunction", nil),
                      NSLocalizedStringFromTable(@"Mon", @"DeviceFunction", nil)];
    
    NSMutableString *loopsShow = [NSMutableString string];
    
    if ([loops isEqualToArray:@[@(0),@(0),@(0),@(0),@(0),@(0),@(0)]]) {
        loopsShow = [NSMutableString stringWithString:NSLocalizedString(@"Never", nil)];
    }else if ([loops isEqualToArray:@[@(1),@(1),@(0),@(0),@(0),@(0),@(0)]]) {
        loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"weekend", @"DeviceFunction", nil)];
    }else if([loops isEqualToArray:@[@(0),@(0),@(1),@(1),@(1),@(1),@(1)]]){
        loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"weekday", @"DeviceFunction", nil)];
    }else if ([loops isEqualToArray:@[@(1),@(1),@(1),@(1),@(1),@(1),@(1)]]){
        loopsShow = [NSMutableString stringWithString:NSLocalizedStringFromTable(@"Everyday", @"DeviceFunction", nil)];
    }else{
        for (int i = 0; i < loops.count; i++) {
            if ([loops[i] isEqualToNumber:@(1)]) {
                [loopsShow appendString:[NSString stringWithFormat:@"%@ ",WEEK[i]]];
            }
        }
    }
    
    self.sceneRepeat = loopsShow;
    
    self.loopsArray = [loops mutableCopy];
    
    [self.tableView reloadData];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isEditScene){
        if (indexPath.section == 3) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedStringFromTable(@"Delete", @"Home", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if(self.isEditScene){
            if(indexPath.section == 3){
                [self.DeviceArray removeObjectAtIndex:indexPath.row];
            }
        }else{
            [self.DeviceArray removeObjectAtIndex:indexPath.row];
        }
        
        
        [tableView reloadData];
    }];
    
    return @[deleteAction];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 134;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0;
    }else{
        if(section == 1){
            if(self.failDeviceSceneArray.count>0){
                return 5.0;
            }else{
                return 0.0;
            }
        }else if (section == 2){
            if(self.DeviceWithSceneArray.count>0){
                return 5.0;
            }else{
                return 0.0;
            }
        }else{
            if(self.DeviceArray.count>0){
                return 5.0;
            }else{
                return 0.0;
            }
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.0;
    }else{
        if(section == 1){
            if(self.failDeviceSceneArray.count>0){
                return 5.0;
            }else{
                return 0.0;
            }
        }else if (section == 2){
            if(self.DeviceWithSceneArray.count>0){
                return 5.0;
            }else{
                return 0.0;
            }
        }else{
            if(self.DeviceArray.count>0){
                return 5.0;
            }else{
                return 0.0;
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


-(void)gotoDeleteDevicePageWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"删除添加定时失败的设备");
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Deleting fail device", nil)];
    
    EHOMESceneDeviceModel *model = self.failDeviceSceneArray[indexPath.row];
    [model deleteSceneDevice:^(id responseObject) {
        [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Delete added failed device successfully", nil) hideAfterDelay:1];
        [self.failDeviceSceneArray removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Delete added failed device failure", nil) hideAfterDelay:1];
    }];
}

-(void)gotoResetDevicePageWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"重置添加定时失败的设备 =%ld",(long)indexPath.row);
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Reseting fail device", nil)];
    
    EHOMESceneDeviceModel *model = self.failDeviceSceneArray[indexPath.row];
    NSLog(@"设备=%@",model);
    NSLog(@"重置添加定时设备id =%d",model.sceneDeviceId);
    [model resetSceneDevice:^(id responseObject) {
        [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Reset added failed device successfully", nil) hideAfterDelay:1];
        
        model.success = YES;
        [self.failDeviceSceneArray removeObjectAtIndex:indexPath.row];
        [self.DeviceWithSceneArray addObject:model];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Reset added failed device failure", nil) hideAfterDelay:1];
    }];
}

@end
