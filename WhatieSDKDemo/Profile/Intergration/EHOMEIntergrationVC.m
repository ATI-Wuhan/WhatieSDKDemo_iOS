//
//  EHOMEIntergrationVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEIntergrationVC.h"
#import "EHOMEUseEchoVC.h"
#import "EHOMEIntergrationTableViewCell.h"



#define cellId @"EHOMEIntergrationTableViewCell"

@interface EHOMEIntergrationVC ()
@property (nonatomic, strong)UIImageView *bgImage; //背景图片
@end

@implementation EHOMEIntergrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=NSLocalizedStringFromTable(@"Integration", @"Profile", nil);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EHOMEIntergrationTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = GREYCOLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EHOMEIntergrationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[EHOMEIntergrationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSArray *images = @[[UIImage imageNamed:@"AmazonAlexaLogo"],[UIImage imageNamed:@"GoogleHomeLogo"]];
    
    cell.intergrationImageView.image = images[indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHOMEUseEchoVC *useVC=[[EHOMEUseEchoVC alloc] init];
    useVC.intergration = indexPath.section;
    [self.navigationController pushViewController:useVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}



@end
