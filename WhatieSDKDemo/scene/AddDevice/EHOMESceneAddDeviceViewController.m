//
//  EHOMESceneAddDeviceViewController.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define itemId @"EHOMESceneAddDeviceCollectionViewCell"

#import "EHOMESceneAddDeviceViewController.h"
#import "EHOMESceneAddDeviceCollectionViewCell.h"

@interface EHOMESceneAddDeviceViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *deviceCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;


@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, strong) EHOMEDeviceModel *currentDevice;

@property (nonatomic, assign) BOOL isOn;

@end

@implementation EHOMESceneAddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Add Action", nil);
    
    [self initCollectionView];
    [self initTableView];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneAddDevice)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success. home = %@", responseObject);
        
        
        EHOMEHomeModel *home = responseObject;
        
        [home syncDeviceByHomeSuccess:^(id responseObject) {
            self.devices = responseObject;

            [self.deviceCollectionView reloadData];
            
        } failure:^(NSError *error) {

            [self.deviceCollectionView reloadData];
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Get current home failed. = %@", error);
    }];
}

-(void)initCollectionView{
    self.deviceCollectionView.delegate = self;
    self.deviceCollectionView.dataSource = self;
    [self.deviceCollectionView registerNib:[UINib nibWithNibName:@"EHOMESceneAddDeviceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:itemId];
}

-(void)initTableView{
    self.deviceTableView.delegate = self;
    self.deviceTableView.dataSource = self;
    
    self.deviceTableView.backgroundColor = GREYCOLOR;
    self.deviceTableView.tableFooterView = [UIView new];
    
    self.isOn = YES;
}

-(void)doneAddDevice{

    if (self.currentDevice != nil) {
        EHOMEDeviceModel *model = [self.currentDevice copy];
        model.sceneActionStatus = self.isOn;
        model.sceneClockId = -1;
        self.addSceneDeviceBlock(model);
    }else{
        NSLog(@"NO Device Selected");
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.devices.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMESceneAddDeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMESceneAddDeviceCollectionViewCell alloc] init];
    }
    
    EHOMEDeviceModel *device = self.devices[indexPath.item];
    
    cell.device = device;
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentDevice = self.devices[indexPath.item];
    NSLog(@"选中的家庭的id=%d",self.currentDevice.device.id);
    EHOMEDeviceModel *model = [self.currentDevice copy];
    NSLog(@"复制的家庭的id=%d",model.device.id);
    
    self.isOn = YES;
    
    [self.deviceTableView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}


#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.currentDevice == nil) {
        return 0;
    }else{
        return 2;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = @[NSLocalizedStringFromTable(@"Turn On", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Turn Off", @"DeviceFunction", nil)][indexPath.row];
    
    if (self.isOn) {
        if (indexPath.row == 0) {
            cell.textLabel.textColor = THEMECOLOR;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = THEMECOLOR;
        }else{
            cell.textLabel.textColor = [UIColor darkTextColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor darkTextColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.textLabel.textColor = THEMECOLOR;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = THEMECOLOR;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        self.isOn = YES;
    }else{
        self.isOn = NO;
    }

    
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}



@end
