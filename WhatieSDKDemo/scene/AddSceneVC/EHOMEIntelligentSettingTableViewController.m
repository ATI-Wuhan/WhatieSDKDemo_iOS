//
//  EHOMEIntelligentSettingTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define SceneNameCellId @"EHOMESceneNameCell"
#define AddTimingCellId @"EHOMEAddTimingCell"
#define SceneTimeCellId @"EHOMESceneTimeCell"
#define AddActionCellId @"EHOMEAddActionCell"
#define SceneActionCellId @"EHOMESceneActionCell"

#import "EHOMEIntelligentSettingTableViewController.h"
#import "EHOMESceneNameCell.h"
#import "EHOMEAddTimingCell.h"
#import "EHOMESceneTimeCell.h"
#import "EHOMEAddActionCell.h"
#import "EHOMESceneActionCell.h"
#import "EHOMESceneDeviceListTableViewController.h"
#import "EHOMESelectTimeViewController.h"
#import "EHOMESceneDeviceListTableViewController.h"
#import "EHOMEOutletStatusTableViewController.h"
#import "EHOMELightModeTableViewController.h"

@interface EHOMEIntelligentSettingTableViewController ()<changeSceneNameDelegate>
//@property (nonatomic, strong) NSMutableArray *DeviceArray;
@property (nonatomic, copy) NSString *sceneName;

@property (nonatomic, copy) NSString *sceneTime;
@property (nonatomic, copy) NSString *sceneRepeat;
@property (nonatomic, strong) NSMutableArray *loopsArray;

//@property (nonatomic, strong) NSMutableArray *deviceIds;
//@property (nonatomic, strong) NSMutableArray *deviceImages;
//@property (nonatomic, strong) NSMutableArray *deviceNames;
//@property (nonatomic, strong) NSMutableArray *deviceStatus;
//@property (nonatomic, strong) NSMutableArray *deviceRooms;
//@property (nonatomic, strong) NSMutableArray *deviceDps;
//@property (nonatomic, strong) NSMutableArray *sceneDeviceId;
@property (nonatomic, strong) NSMutableArray *actionDicArray;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

@implementation EHOMEIntelligentSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Scene setting", nil);
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveSceneAction)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
//    self.deviceIds = [NSMutableArray array];
//    self.deviceImages = [NSMutableArray array];
//    self.deviceNames = [NSMutableArray array];
//    self.deviceStatus = [NSMutableArray array];
//    self.deviceRooms = [NSMutableArray array];
//    self.deviceDps = [NSMutableArray array];
    self.actionDicArray = [NSMutableArray array];
    
    if(self.isAddScene){
        self.sceneName = NSLocalizedString(@"Scene name", nil);
        self.sceneTime = @"0";
    }else{
        if(self.isManual){
            self.sceneTime = @"0";
        }
        
        self.sceneName = self.Scene.scene.name;
        if(!self.isManual){
            self.sceneTime = self.Scene.finishTimeApp;
            NSString *loopsString = self.Scene.scene.timerType;
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 0; i<self.Scene.scene.timerType.length; i++) {
                int loop = [[loopsString substringWithRange:NSMakeRange(i, 1)] intValue];
                [tempArray addObject:[NSNumber numberWithInt:loop]];
            }
            self.loopsArray = tempArray;
            NSArray *LA = self.loopsArray;
            [self showDaysWithLoops:LA];
        }
        
        for(EHOMESceneDeviceModel *model in self.Scene.sceneDeviceVos){
            NSDictionary *dic;
            if(model.device.product.productType == 2){
                if(model.dps.lightMode == 1){
                    dic = @{@"lightMode":@(1),
                            @"l":model.dps.l
                            };
                }else if (model.dps.lightMode == 2){
                    dic = @{@"lightMode":@(2),
                            @"rgb":model.dps.rgb,
                            @"l":model.dps.l
                            };
                }else if (model.dps.lightMode == 5){
                    dic = @{@"lightMode":@(5),
                            @"rgb1":model.dps.rgb1,
                            @"rgb2":model.dps.rgb2,
                            @"rgb3":model.dps.rgb3,
                            @"rgb4":model.dps.rgb4,
                            @"t":model.dps.t,
                            @"l":model.dps.l
                            };
                }else if (model.dps.lightMode == 4){
                    dic = @{@"lightMode":@(4),
                            @"status": model.dps.status
                            };
                }else{
                    dic = nil;
                }
            }else{
                NSLog(@"状态呢 = %d",model.dps.first);
                dic = @{@"1":@(model.dps.first),
                        @"2":@(model.dps.first)
                        };
            }
            
            NSDictionary *deviceDic = @{@"dps":dic,
                                        @"deviceId":@(model.device.id),
                                        @"deviceName":model.device.name,
                                        @"deviceRoom":model.roomName,
                                        @"deviceImage":model.device.product.picture.path,
                                        @"deviceStatus":model.device.status,
                                        @"sceneDeviceId":@(model.sceneDeviceId)
                                       };
            [self.actionDicArray addObject:deviceDic];
            
        }
    }
    
    [self initTableView];
    
    //注册接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSceneDevice:) name:@"AddSceneOutletToIntelligent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSceneDevice:) name:@"AddSceneWhiteLightToIntelligent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSceneDevice:) name:@"AddSceneRGBLightToIntelligent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSceneDevice:) name:@"AddSceneStreamLightToIntelligent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EditSceneDevice:) name:@"EditSceneOutletToIntelligent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EditSceneDevice:) name:@"EditSceneWhiteLightToIntelligent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EditSceneDevice:) name:@"EditSceneRgbLightToIntelligent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EditSceneDevice:) name:@"EditSceneStreamLightToIntelligent" object:nil];
}

-(void)initTableView{
    self.tableView.backgroundColor =RGB(240, 240, 240);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMESceneNameCell" bundle:nil] forCellReuseIdentifier:SceneNameCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEAddTimingCell" bundle:nil] forCellReuseIdentifier:AddTimingCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMESceneTimeCell" bundle:nil] forCellReuseIdentifier:SceneTimeCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEAddActionCell" bundle:nil] forCellReuseIdentifier:AddActionCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMESceneActionCell" bundle:nil] forCellReuseIdentifier:SceneActionCellId];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isManual){
        return 2;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        if(self.isManual){
            if(self.actionDicArray.count >0){
                return self.actionDicArray.count;
            }else{
                return 1;
            }
            
        }else{
            if(section == 1){
                return 1;
            }else{
                if(self.actionDicArray.count >0){
                    return self.actionDicArray.count;
                }else{
                    return 1;
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        EHOMESceneNameCell *cell = [tableView dequeueReusableCellWithIdentifier:SceneNameCellId forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[EHOMESceneNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SceneNameCellId];
        }
        cell.delegate = self;
        cell.NameLabel.text = self.sceneName;
        return cell;
    }else{
        
        if(self.isManual){
            if(self.actionDicArray.count >0){
                EHOMESceneActionCell *cell = [tableView dequeueReusableCellWithIdentifier:SceneActionCellId forIndexPath:indexPath];
                
                if (!cell) {
                    cell = [[EHOMESceneActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SceneActionCellId];
                }
                
                NSDictionary *dic = self.actionDicArray[indexPath.row];
                
                NSString *url = [dic objectForKey:@"deviceImage"];
                [cell.deviceImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                
                cell.deviceNameLabel.text = [dic objectForKey:@"deviceName"];
                
                if ([[dic objectForKey:@"deviceStatus"] isEqualToString:@"Offline"]) {
                    cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"Offline", @"Device", nil)];
                }else if([[dic objectForKey:@"deviceStatus"] isEqualToString:@"Online"]){
                    cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"online", @"Room", nil)];
                }else if ([[dic objectForKey:@"deviceStatus"] isEqualToString:@"Unbind"]){
                    cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"Unbind", @"Device", nil)];
                }else{
                    cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"FirmwareUpgrading", @"Device", nil)];
                }
                
                NSDictionary *dpsDic = [dic objectForKey:@"dps"];
                if([[dpsDic allKeys] containsObject:@"lightMode"]){
                    
                    int LightMode = [[dpsDic objectForKey:@"lightMode"] intValue];
                    if(LightMode == 4){
                        cell.deviceModeImageView.hidden = YES;
                        cell.deviceStatusLabel.hidden = NO;
                        NSString *StatusStr = ([[dpsDic objectForKey:@"status"] isEqualToString:@"true"]) ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
                        cell.deviceStatusLabel.text = StatusStr;
                    }else{
                        cell.deviceModeImageView.hidden = NO;
                        cell.deviceStatusLabel.hidden = YES;
                        if(LightMode == 1){
                            cell.deviceModeImageView.image = [UIImage imageNamed:@"light_brightness"];
                        }else if(LightMode == 2){
                            cell.deviceModeImageView.image = [UIImage imageNamed:@"colotlight"];
                        }else if(LightMode == 5){
                            cell.deviceModeImageView.image = [UIImage imageNamed:@"streamlight"];
                        }
                    }
                    
                }else{
                    cell.deviceStatusLabel.hidden = NO;
                    cell.deviceModeImageView.hidden = YES;
                    if([[[dpsDic allValues] firstObject] boolValue]){
                        cell.deviceStatusLabel.text = NSLocalizedString(@"ON", nil);
                    }else{
                        cell.deviceStatusLabel.text = NSLocalizedString(@"OFF", nil);
                    }
                }
                
                return cell;
            }else{
                EHOMEAddActionCell *cell = [tableView dequeueReusableCellWithIdentifier:AddActionCellId forIndexPath:indexPath];
                
                if (!cell) {
                    cell = [[EHOMEAddActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddActionCellId];
                }
                return cell;
            }
        }else{
            if(indexPath.section == 1){
                if([self.sceneTime isEqualToString:@"0"]){
                    EHOMEAddTimingCell *cell = [tableView dequeueReusableCellWithIdentifier:AddTimingCellId forIndexPath:indexPath];
                    
                    if (!cell) {
                        cell = [[EHOMEAddTimingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddTimingCellId];
                    }
                    return cell;
                }else{
                    EHOMESceneTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:SceneTimeCellId forIndexPath:indexPath];
                    
                    if (!cell) {
                        cell = [[EHOMESceneTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SceneTimeCellId];
                    }
                    cell.TimeLabel.text = self.sceneTime;
                    cell.daysLabel.text = self.sceneRepeat;
                    return cell;
                }
                
            }else{
                if(self.actionDicArray.count >0){
                    EHOMESceneActionCell *cell = [tableView dequeueReusableCellWithIdentifier:SceneActionCellId forIndexPath:indexPath];
                    
                    if (!cell) {
                        cell = [[EHOMESceneActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SceneActionCellId];
                    }
                    NSDictionary *dic = self.actionDicArray[indexPath.row];
                    
                    NSString *url = [dic objectForKey:@"deviceImage"];
                    [cell.deviceImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                    
                    cell.deviceNameLabel.text = [dic objectForKey:@"deviceName"];
                    
                    if ([[dic objectForKey:@"deviceStatus"] isEqualToString:@"Offline"]) {
                        cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"Offline", @"Device", nil)];
                    }else if([[dic objectForKey:@"deviceStatus"] isEqualToString:@"Online"]){
                        cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"online", @"Room", nil)];
                    }else if ([[dic objectForKey:@"deviceStatus"] isEqualToString:@"Unbind"]){
                        cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"Unbind", @"Device", nil)];
                    }else{
                        cell.devicelocalLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"deviceRoom"],NSLocalizedStringFromTable(@"FirmwareUpgrading", @"Device", nil)];
                    }
                    
                    NSDictionary *dpsDic = [dic objectForKey:@"dps"];
                    if([[dpsDic allKeys] containsObject:@"lightMode"]){

                        int LightMode = [[dpsDic objectForKey:@"lightMode"] intValue];
                        if(LightMode == 4){
                            cell.deviceModeImageView.hidden = YES;
                            cell.deviceStatusLabel.hidden = NO;
                            NSString *StatusStr = ([[dpsDic objectForKey:@"status"] isEqualToString:@"true"]) ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
                            cell.deviceStatusLabel.text = StatusStr;
                        }else{
                            cell.deviceStatusLabel.hidden = YES;
                            cell.deviceModeImageView.hidden = NO;
                            if(LightMode == 1){
                                cell.deviceModeImageView.image = [UIImage imageNamed:@"light_brightness"];
                            }else if(LightMode == 2){
                                cell.deviceModeImageView.image = [UIImage imageNamed:@"colotlight"];
                            }else if(LightMode == 5){
                                cell.deviceModeImageView.image = [UIImage imageNamed:@"streamlight"];
                            }
                        }
                        
                    }else{
                        cell.deviceStatusLabel.hidden = NO;
                        cell.deviceModeImageView.hidden = YES;
                        if([[[dpsDic allValues] firstObject] boolValue]){
                            cell.deviceStatusLabel.text = NSLocalizedString(@"ON", nil);
                        }else{
                            cell.deviceStatusLabel.text = NSLocalizedString(@"OFF", nil);
                        }
                    }
                    
                    return cell;
                }else{
                    EHOMEAddActionCell *cell = [tableView dequeueReusableCellWithIdentifier:AddActionCellId forIndexPath:indexPath];
                    
                    if (!cell) {
                        cell = [[EHOMEAddActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddActionCellId];
                    }
                    return cell;
                }
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        
    }else{
        
        if(self.isManual){
            if(self.actionDicArray.count>0){
                self.currentIndexPath = indexPath;
                NSDictionary *dic = self.actionDicArray[indexPath.row];
                NSLog(@"点击了设备的dic=%@",dic);
                if([[[dic objectForKey:@"dps"] allKeys] containsObject:@"lightMode"]){
                    NSLog(@"点击了手动执行的插座的模式");
                    EHOMELightModeTableViewController *vc = [[EHOMELightModeTableViewController alloc] initWithNibName:@"EHOMELightModeTableViewController" bundle:nil];
                    vc.isEditLight = YES;
                    vc.lighDps = [dic objectForKey:@"dps"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    NSLog(@"点击了手动执行的插座开关");
                    EHOMEOutletStatusTableViewController *vc = [[EHOMEOutletStatusTableViewController alloc] initWithNibName:@"EHOMEOutletStatusTableViewController" bundle:nil];
                    vc.isEditAction = YES;
                    vc.dpsDIC = [dic objectForKey:@"dps"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [self AddDeviceAction];
            }
            
        }else{
            if(indexPath.section == 1){
                EHOMESelectTimeViewController *timeVC = [[EHOMESelectTimeViewController alloc] initWithNibName:@"EHOMESelectTimeViewController" bundle:nil];
                EHOMENavigationController *setTime = [[EHOMENavigationController alloc] initWithRootViewController:timeVC];
                
                __weak typeof(self) weakSelf = self;
                
                [timeVC setTimeblock:^(NSString *time) {
                    weakSelf.sceneTime = time;
                    [weakSelf.tableView reloadData];
                }];
                
                [timeVC setDaysblock:^(NSArray *days) {
                    NSLog(@"loops = %@", days);
                    [weakSelf showDaysWithLoops:days];
                }];
                [self presentViewController:setTime animated:YES completion:nil];
            }else{
                if(self.actionDicArray.count>0){
                    self.currentIndexPath = indexPath;
                    NSDictionary *dic = self.actionDicArray[indexPath.row];
                    NSLog(@"点击了设备的dic=%@",dic);
                    if([[[dic objectForKey:@"dps"] allKeys] containsObject:@"lightMode"]){
                        NSLog(@"点击了定时执行的插座的模式");
                        EHOMELightModeTableViewController *vc = [[EHOMELightModeTableViewController alloc] initWithNibName:@"EHOMELightModeTableViewController" bundle:nil];
                        vc.isEditLight = YES;
                        vc.lighDps = [dic objectForKey:@"dps"];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        NSLog(@"点击了定时执行的插座开关");
                        EHOMEOutletStatusTableViewController *vc = [[EHOMEOutletStatusTableViewController alloc] initWithNibName:@"EHOMEOutletStatusTableViewController" bundle:nil];
                        vc.isEditAction = YES;
                        vc.dpsDIC = [dic objectForKey:@"dps"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }else{
                    [self AddDeviceAction];
                }
            }
        }
        
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isManual){
        if(indexPath.section == 1){
            if(self.actionDicArray.count>0){
                return YES;
            }else{
                return NO;
            }
            
        }else{
            return NO;
        }
    }else{
        if(indexPath.section == 2){
            if(self.actionDicArray.count>0){
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedStringFromTable(@"Delete", @"Home", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if(self.isManual){
            if(indexPath.section == 1){
                if(self.actionDicArray.count>0){
                    [self.actionDicArray removeObjectAtIndex:indexPath.row];
                }
            }
        }else{
            if(indexPath.section == 2){
                if(self.actionDicArray.count>0){
                    [self.actionDicArray removeObjectAtIndex:indexPath.row];
                }
            }
        }
        for(NSDictionary *dic in self.actionDicArray){
            NSLog(@"还剩余多少 = %@",dic);
        }
        [tableView reloadData];
    }];
    
    return @[deleteAction];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return 140;
    }else{
        return 76;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor clearColor];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(15, 0.0, DEVICE_W-30, 44.0)];
    bgview.backgroundColor = [UIColor whiteColor];
    [customView addSubview:bgview];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;;
    headerLabel.highlightedTextColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    headerLabel.frame = CGRectMake(15, 16.0, 100, 20.0);
    headerLabel.textColor = [UIColor grayColor];
    [bgview addSubview:headerLabel];
    
    UIButton *addbtn =[[UIButton alloc] initWithFrame:CGRectMake(DEVICE_W-80, 16.0, 25, 25.0)];
    if (CurrentApp == Geek) {
        [addbtn setImage:[UIImage imageNamed:@"add-Icon"] forState:UIControlStateNormal];
    }else if (CurrentApp == Ozwi){
        [addbtn setImage:[UIImage imageNamed:@"Ozwi-add-Icon"] forState:UIControlStateNormal];
    }else{
        [addbtn setImage:[UIImage imageNamed:@"ehome-add-Icon"] forState:UIControlStateNormal];
    }
    
    [addbtn addTarget:self action:@selector(AddDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:addbtn];
    if(section == 0){
        return nil;
    }else{
        if(self.isManual){
            headerLabel.text = NSLocalizedString(@"ACTION", nil);
            if(self.actionDicArray.count>0){
                addbtn.hidden = NO;
            }else{
                addbtn.hidden = YES;
            }
            
        }else{
            if(section == 1){
                headerLabel.text = NSLocalizedString(@"TIME", nil);
                addbtn.hidden = YES;
            }else{
                headerLabel.text = NSLocalizedString(@"ACTION", nil);
                if(self.actionDicArray.count>0){
                    addbtn.hidden = NO;
                }else{
                    addbtn.hidden = YES;
                }
            }
        }
        return customView;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0.001;
    }else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 0.001;
    }else{
        return 10.0;
    }
}

-(void)saveSceneAction{
    if(self.actionDicArray != nil && ![self.actionDicArray isKindOfClass:[NSNull class]] && self.actionDicArray.count != 0){
        NSMutableString *loops = [NSMutableString string];
        for (NSNumber *loop in self.loopsArray) {
            [loops appendString:[loop stringValue]];
        }
        
        NSMutableArray *deviceIdAry = [NSMutableArray array];
        NSMutableArray *deviceDpsAry = [NSMutableArray array];
        NSMutableArray *sceneDevIdAry = [NSMutableArray array];
        for(NSDictionary *dic in self.actionDicArray){
            [deviceIdAry addObject:[dic objectForKey:@"deviceId"]];
            [deviceDpsAry addObject:[dic objectForKey:@"dps"]];
            [sceneDevIdAry addObject:[dic objectForKey:@"sceneDeviceId"]];
        }
        
        if(self.isAddScene){
            if(!self.isManual && [self.sceneTime isEqualToString:@"0"]){
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Please select time", nil) hideAfterDelay:1.0];
            }else{
                NSLog(@"Add Scene...");
                
                [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Adding scene...", nil) hideAfterDelay:10.0];
                
                [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
                    
                    EHOMEHomeModel *home = responseObject;
                    
                    [home addSceneWithName:self.sceneName time:self.sceneTime loops:loops deviceIdArray:deviceIdAry functionArray:deviceDpsAry sceneTye:self.isManual success:^(id responseObject) {
                        NSLog(@"Add scene success. res = %@", responseObject);
                        //                    self.RefreshScene(YES);
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshScene" object:nil userInfo:nil];
                        
                        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Add scene success.", nil) hideAfterDelay:1.0];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } failure:^(NSError *error) {
                        NSLog(@"Add scene failed. error = %@", error);
                        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                        [HUDHelper showErrorDomain:error];
                    }];
                    
                    
                } failure:^(NSError *error) {
                    [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                    [HUDHelper showErrorDomain:error];
                }];
            }
            
        }else{
            NSLog(@"Edit Scene...");
            
            for(int i = 0;i<self.actionDicArray.count;i++){
                NSLog(@"deviceInfo=%@",self.actionDicArray[i]);
            }
            
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Editting scene...", nil) hideAfterDelay:10.0];
            
            [self.Scene EditSceneWithName:self.sceneName finishTime:self.sceneTime loops:loops deviceIds:deviceIdAry functionArray:deviceDpsAry sceneDeviceIds:sceneDevIdAry sceneType:self.isManual success:^(id responseObject) {
                NSLog(@"Edit scene success. res = %@", responseObject);
                //            self.RefreshScene(YES);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshScene" object:nil userInfo:nil];
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Edit scene success.", nil) hideAfterDelay:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                NSLog(@"Edit scene failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper showErrorDomain:error];
            }];
        }
    }else{
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedString(@"Action could not be empty", nil) hideAfterDelay:1.0];
    }
    
}

-(void)AddDeviceAction{
    EHOMESceneDeviceListTableViewController *addDeviceVC = [[EHOMESceneDeviceListTableViewController alloc] initWithNibName:@"EHOMESceneDeviceListTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}

-(void)AddSceneDevice:(NSNotification *)notification{
    NSDictionary *deviceInfo = [notification.userInfo objectForKey:@"deviceInfo"];
    NSLog(@"当前选择的设备 %d状态为 = %@",[[deviceInfo objectForKey:@"deviceId"] intValue], [deviceInfo objectForKey:@"dps"]);
    [self.actionDicArray addObject:deviceInfo];
    NSLog(@"新增个数=%lu",(unsigned long)self.actionDicArray.count);
    [self.tableView reloadData];
}

-(void)EditSceneDevice:(NSNotification *)notification{
    NSDictionary *deviceDic = self.actionDicArray[self.currentIndexPath.row];
    
    NSMutableDictionary *multableDic = [NSMutableDictionary dictionaryWithDictionary:deviceDic];
    [multableDic setObject:[notification.userInfo objectForKey:@"dps"] forKey:@"dps"];
    NSDictionary *Dic = multableDic;
    [self.actionDicArray replaceObjectAtIndex:self.currentIndexPath.row withObject:Dic];
    NSLog(@"当前选择编辑后的设备为 = %@",Dic);
    [self.tableView reloadData];
}

-(void)gotoChangeSceneName{
    NSLog(@"点击了编辑场景的名字");
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
}

@end
