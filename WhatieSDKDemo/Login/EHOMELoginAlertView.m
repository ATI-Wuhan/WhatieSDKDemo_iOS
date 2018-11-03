//
//  EHOMELoginAlertView.m
//  WhatieSDKDemo
//
//  Created by IIDreams_zhouwei on 2018/8/8.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMELoginAlertView.h"

@implementation EHOMELoginAlertView{
    
    UITableView *tableView;
    NSArray *users;
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        users = [EHOMEDataStore getUserDBsFromDB];
        
        NSLog(@"user = %@", users);
        
        for (EHOMEUserDB *user in users) {
            NSLog(@"email = %@", user.email);
        }
        
        UIView *tapView = [[UIView alloc] init];
        [self addSubview:tapView];
        
        [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tapView addGestureRecognizer:tap];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 5.0;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(30);
            make.trailing.mas_equalTo(-30);
            make.top.mas_equalTo(self).mas_offset(100);
            make.bottom.mas_equalTo(self).mas_offset(-100);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedStringFromTable(@"Accounts", @"Home", nil);
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView).mas_offset(30);
            make.left.right.mas_equalTo(bgView);
            make.height.mas_equalTo(30);
        }];
        
        //button
        UIButton *cancel = [[UIButton alloc] init];
        cancel.backgroundColor = GREYCOLOR;
        cancel.layer.masksToBounds = YES;
        cancel.layer.cornerRadius = 5.0;
        [cancel setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [cancel setTitle:NSLocalizedStringFromTable(@"Cancel", @"Alert", nil) forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancel];
        
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bgView).mas_offset(-30);
            make.leading.mas_equalTo(15);
            make.trailing.mas_equalTo(-15);
            make.height.mas_equalTo(44);
        }];
        
        
        
        //tableView
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        tableView.tableFooterView = [UIView new];
        [bgView addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.right.mas_equalTo(cancel);
            make.top.mas_equalTo(label.mas_bottom).mas_offset(20);
            make.bottom.mas_equalTo(cancel.mas_top).mas_offset(-20);
        }];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [tableView reloadData];

    }
    
    return self;
}

-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
}

-(void)dismiss{

    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished) {

    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return [EHOMEDataStore getUserDBsFromDB].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    EHOMEUserDB *user = [EHOMEDataStore getUserDBsFromDB][indexPath.row];
    
    cell.textLabel.text = user.email;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHOMEUserDB *user = [EHOMEDataStore getUserDBsFromDB][indexPath.row];
    
    [self dismiss];
    
    [self.delegate fastLoginWithEmail:user.email andPassword:user.password];
}



@end
