//
//  EHOMEGetStartViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEGetStartViewController.h"
#import "EHOMERoomListTableViewController.h"

@interface EHOMEGetStartViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UIButton *getStartButton;
@property (nonatomic, strong) EHOMERoomModel *selectedRoom;
@property (nonatomic, strong) EHOMEHomeModel *selectedHome;
@end

@implementation EHOMEGetStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Get Started", @"Device", nil);
    
    [self.getStartBtn setTitle:NSLocalizedStringFromTable(@"GET STARTED", @"Home", nil) forState:UIControlStateNormal];
    self.getStartBtn.layer.masksToBounds = YES;
    self.getStartBtn.layer.cornerRadius = 3.0;
    
    //不显示返回上一界面按钮
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    //禁止侧滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.getStartTableview.delegate=self;
    self.getStartTableview.dataSource=self;
    
    self.getStartBtn.backgroundColor = [UIColor THEMECOLOR];
    
//    for(EHOMERoomModel *model in self.roomModelArray){
//        if([model.room.type isEqualToString:@"defaultRoom"]){
//            self.selectedRoom = model;
//            break;
//        }
//    }

    
    [self getRooms];
}

-(void)getRooms{
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedString(@"Loading", nil) hideAfterDelay:10];
    
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        EHOMEHomeModel *currenthome = responseObject;
        
        //从数据库中获取房间数据
        NSArray *localRooms = [EHOMEDataStore getRoomsFromDBWithHomeId:currenthome.id];
        
        if (localRooms.count > 0) {
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            
            self.roomModelArray = localRooms;
            for(EHOMERoomModel *model in self.roomModelArray){
                if([model.room.type isEqualToString:@"defaultRoom"]){
                    self.selectedRoom = model;
                    
                    [self.getStartTableview reloadData];
                    
                    break;
                }
            }
            
            [currenthome syncRoomByHomeSuccess:^(id responseObject) {
                self.roomModelArray = responseObject;
                [EHOMEDataStore setRoomsToDBWithRooms:self.roomModelArray inHome:currenthome.id];
            } failure:^(NSError *error) {
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            }];
        }else{
            [currenthome syncRoomByHomeSuccess:^(id responseObject) {
                
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                
                self.roomModelArray = responseObject;
                for(EHOMERoomModel *model in self.roomModelArray){
                    if([model.room.type isEqualToString:@"defaultRoom"]){
                        self.selectedRoom = model;
                        
                        [self.getStartTableview reloadData];
                        
                        break;
                    }
                }
                
                [EHOMEDataStore setRoomsToDBWithRooms:self.roomModelArray inHome:currenthome.id];
            } failure:^(NSError *error) {
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            }];
        }

    } failure:^(NSError *error) {
        NSLog(@"Get current home failed.error = %@", error);
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"defaultCell";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 0){
        cell.textLabel.text = self.deviceName;
    }else{
        cell.textLabel.text = self.selectedRoom.room.name;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self changeDeviceName];
        
    }else{
        EHOMERoomListTableViewController *roomlistVC = [[EHOMERoomListTableViewController alloc] initWithNibName:@"EHOMERoomListTableViewController" bundle:nil];
        roomlistVC.ModelArray = self.roomModelArray;
        roomlistVC.selectedmodel = self.selectedRoom;
        roomlistVC.IsChangeDeviceRoom = NO;
        
        __weak typeof(self) weakSelf = self;
        [roomlistVC setSelectedRoomBlock:^(EHOMERoomModel *model) {
            weakSelf.selectedRoom = model;
            [weakSelf.getStartTableview reloadData];
        }];
        [self.navigationController pushViewController:roomlistVC animated:YES];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSArray *titles=@[NSLocalizedStringFromTable(@"DEVICE NAME", @"Home", nil),
                      NSLocalizedStringFromTable(@"BELONG TO", @"Home", nil)];
    return titles[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changeDeviceName{
    NSString *title = NSLocalizedStringFromTable(@"update device name", @"Device", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = self.deviceName;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            
            self.deviceName = name;
            [self.getStartTableview reloadData];
            
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"please enter name", @"Info", nil) hideAfterDelay:1.0];
        }
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)getStartedButtnAction:(id)sender {
    if ([self.deviceName length] == 0) {
        self.deviceName = NSLocalizedStringFromTable(@"No Name.", @"Device", nil);
    }
    
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please Wait", @"Device", nil) hideAfterDelay:15];
    
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        self.selectedHome = responseObject;
        
    } failure:^(NSError *error) {
        NSLog(@"Get current home failed.error = %@", error);
    }];
    
    [[EHOMESmartConfig shareInstance] getStartedWithDevId:_devId deviceName:self.deviceName home:self.selectedHome room:self.selectedRoom success:^(id responseObject) {
        NSLog(@"GET STARTED Success = %@", responseObject);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GetStartedNotice" object:nil userInfo:nil]];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"GET STARTED Failed = %@", error);
        
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper showErrorDomain:error];
    }];
}
- (void)dealloc {
    [_getStartButton release];
    [super dealloc];
}
@end
