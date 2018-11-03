//
//  EHOMESettingVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/27.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESettingVC.h"
#import "EHOMELogoView.h"
#import "EHOMENewFeatureTableViewController.h"
#import "EHOMETermsTableViewController.h"

@interface EHOMESettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *aboutTableView;
@property(nonatomic,strong)EHOMELogoView *logoview;
@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation EHOMESettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"About", @"Profile", nil);
    self.view.backgroundColor=GREYCOLOR;
    [self initTableView];
    // Do any additional setup after loading the view.
}

-(void)initTableView{
    self.aboutTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.aboutTableView.backgroundColor= GREYCOLOR;
    [self.view addSubview:self.aboutTableView];
    
    __weak typeof(self) weakSelf = self;
    [self.aboutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view).mas_offset(-40);
    }];
    
    self.aboutTableView.delegate=self;
    self.aboutTableView.dataSource=self;
    self.aboutTableView.tableFooterView=[UIView new];
    self.aboutTableView.estimatedRowHeight=100;
    self.aboutTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.logoview=[[EHOMELogoView alloc] initWithFrame:CGRectMake(0, 0,DEVICE_W ,160)];
    self.aboutTableView.tableHeaderView =self.logoview;
    
    self.bottomLabel=[[UILabel alloc] init];
    self.bottomLabel.textColor=[UIColor grayColor];
    self.bottomLabel.font=[UIFont systemFontOfSize:14];
    self.bottomLabel.minimumScaleFactor = 0.5;
    self.bottomLabel.adjustsFontSizeToFitWidth = YES;
    self.bottomLabel.textAlignment=NSTextAlignmentCenter;
    
//    NSString *rightsInfo;
//    switch (CurrentApp) {
//        case eHome:
//            rightsInfo = @"©2018 ATI (WUHAN) ELECTRONICS Co., Ltd All Rights Reserved";
//            break;
//        case Geek:
//            rightsInfo = @"©2018 Shenzhen Proxelle Co.,Ltd All Rights Reserved";
//            break;
//        case Ozwi:
//            rightsInfo = @"©2018 Ozwi Home Co., Ltd All Rights Reserved";
//            break;
//
//        default:
//            rightsInfo = @"©2018 ATI (WUHAN) ELECTRONICS Co., Ltd All Rights Reserved";
//            break;
//    }
    
    self.bottomLabel.text=@"©2018 Whatie Co., Ltd All Rights Reserved";
    [self.view addSubview:self.bottomLabel];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.view).mas_offset(-8);
        make.top.mas_equalTo(self.aboutTableView.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *textLabel=[[UILabel alloc] init];
    textLabel.font=[UIFont systemFontOfSize:17];
    
    NSArray *texts=@[NSLocalizedStringFromTable(@"Features", @"Profile", nil),
                     NSLocalizedStringFromTable(@"Rate On App Store", @"Profile", nil),
                     NSLocalizedStringFromTable(@"Service Agreement", @"Profile", nil)];
    textLabel.text=texts[indexPath.row];
    [cell.contentView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(cell.contentView).mas_offset(8);
        make.bottom.mas_equalTo(cell.contentView).mas_offset(-8);
        make.left.mas_equalTo(cell.contentView).mas_offset(14);
        make.right.mas_equalTo(cell.contentView).mas_offset(-14);
    }];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        EHOMENewFeatureTableViewController *newFeatureVC=[[EHOMENewFeatureTableViewController alloc] initWithNibName:@"EHOMENewFeatureTableViewController" bundle:nil];
        [self.navigationController pushViewController:newFeatureVC animated:YES];
    }else if (indexPath.row == 1) {
        NSLog(@"跳转到App Store");
        
        NSString *APPID = @"1367100039";
        
        switch (CurrentApp) {
            case eHome:
                APPID = @"1367100039";
                break;
            case Geek:
                APPID = @"1420362590";
                break;
            case Ozwi:
                APPID = @"1367100039";
                break;
                
            default:
                break;
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review", APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else{
        EHOMETermsTableViewController *termsVC = [[EHOMETermsTableViewController alloc] initWithNibName:@"EHOMETermsTableViewController" bundle:nil];
        [self.navigationController pushViewController:termsVC animated:YES];
    }
    
}

//隐藏最后一个cell的分割线
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
