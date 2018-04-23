//
//  EHOMEHomeTableViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#define cellId @"EHOMEHomeTableViewCell"

#import "EHOMEHomeTableViewController.h"
#import "EHOMEHomeTableViewCell.h"
#import "EHOMEAddDeviceTableViewController.h"

@interface EHOMEHomeTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, HomeDeviceDelegate>

@property (nonatomic, assign) BOOL NoDevices;

@property (nonatomic, strong) NSMutableArray *myDevicesArray;

@end

@implementation EHOMEHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Home";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addDeviceAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.NoDevices = NO;
    self.myDevicesArray = [NSMutableArray array];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    
    self.tableView.rowHeight = 100;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEHomeTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullDownRefresh];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)pullDownRefresh{
    [EHOMEDeviceModel getMyDeviceListWithAccessId:AccessId accessKey:AccessKey startBlock:^{
        NSLog(@"Start request my devices...");
    } successBlock:^(id responseObject) {
        NSLog(@"Get my devices successful : %@", responseObject);
        
        [self.myDevicesArray removeAllObjects];
        [self.myDevicesArray addObjectsFromArray:responseObject];
        
        if (self.myDevicesArray.count == 0) {
            self.NoDevices = YES;
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failBlock:^(NSError *error) {
        NSLog(@"Get my devices failed : %@", error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.myDevicesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMEHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    if (!cell) {
        cell = [[EHOMEHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.deviceModel = self.myDevicesArray[indexPath.section];
    cell.indexpath = indexPath;
    cell.delegate = self;
    
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(void)switchDeviceStatusSuccessWithStatus:(BOOL)isOn indexPath:(NSIndexPath *)indexPath{
    
    EHOMEDeviceModel *model = self.myDevicesArray[indexPath.section];
    model.functionValuesMap.power = isOn;
    [self.myDevicesArray replaceObjectAtIndex:indexPath.section withObject:model];
    
}





-(void)addDeviceAction{
    EHOMEAddDeviceTableViewController *addDeviceVC = [[EHOMEAddDeviceTableViewController alloc] initWithNibName:@"EHOMEAddDeviceTableViewController" bundle:nil];
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}




#pragma mark - DZNEmptyDataSetSource
//空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if(!self.NoDevices){
        return nil;
    }
    UIImage *image=[UIImage imageNamed:@"nothing"];
    [self scaleImage:image toScale:0.5];
    return image;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if(!self.NoDevices){
        return nil;
    }
    NSString *title = @"No Devices";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor blackColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

//空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if(!self.NoDevices){
        return nil;
    }
    NSString *text = @"Sorry,there are no devices in your home.Please try to add a device to build your smart home.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


//设置按钮图片
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if(!self.NoDevices){
        return nil;
    }
    return [UIImage imageNamed:@"ADDDEVICE"];
}

// 垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

//组件彼此之间的上下间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 25.0f;
}

#pragma mark - DZNEmptyDataSetSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // 处理按钮点击事件...
    NSLog(@"Click the ADD DEVICE Button");
    [self addDeviceAction];
}


@end
