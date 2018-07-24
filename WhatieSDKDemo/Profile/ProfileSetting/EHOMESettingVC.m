//
//  EHOMESettingVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/27.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESettingVC.h"
#import "EHOMELogoView.h"
#import "EHOMEAgreementVC.h"

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
    self.bottomLabel.text=@"©2018 ATI (WUHAN) ELECTRONICS Co., Ltd All Rights Reserved";
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
    
    if (indexPath.row == 1) {
        NSLog(@"跳转到App Store");
        NSString *APPID = @"1367100039";
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review", APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else{
        EHOMEAgreementVC *agreementVC=[[EHOMEAgreementVC alloc] init];
        agreementVC.fromWhere = indexPath.row;
        [self.navigationController pushViewController:agreementVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
