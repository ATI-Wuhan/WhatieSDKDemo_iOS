//
//  EHOMEAddRoomTableViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/10.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAddRoomTableViewController.h"
#import "EHOMEBackgroundViewController.h"

@interface EHOMEAddRoomTableViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *newnameTF;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) EHOMEBackgroundModel *RIModel;
@end

@implementation EHOMEAddRoomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"NEW ROOM", @"Room", @"创建新房间");
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Done", @"Profile", nil) style:(UIBarButtonItemStylePlain) target:self action:@selector(saveAct)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.addImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    self.addImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addImageView.clipsToBounds = YES;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *cellID1 = @"cell1";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell1){
            cell1 = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID1];
        }
        self.newnameTF = [[UITextField alloc]init];
        self.newnameTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
        self.newnameTF.font = [UIFont systemFontOfSize:16];
        self.newnameTF.placeholder = @"ex.Living Room";
        self.newnameTF.delegate = self;
        self.newnameTF.backgroundColor = [UIColor whiteColor];
        [cell1.contentView addSubview:self.newnameTF];
        [self.newnameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.trailing.mas_equalTo(-15);
            make.top.bottom.mas_equalTo(cell1.contentView);
        }];
        return cell1;
    }
    else{
        static NSString *cellID2 = @"cell2";
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell2){
            cell2 = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID2];
        }
        [cell2.contentView addSubview:self.addImageView];
        [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell2.contentView).mas_offset(15);
            make.width.mas_equalTo(62);
            make.height.mas_equalTo(86);
            make.centerY.mas_equalTo(cell2.contentView);
        }];
        return cell2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 106;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *titles = @[NSLocalizedStringFromTable(@"Room Name", @"Room", nil),
                        NSLocalizedStringFromTable(@"Background", @"Room", nil)
                        ];
    return titles[section];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1){
        NSLog(@"点击选择背景图片");
        EHOMEBackgroundViewController *backVC = [[EHOMEBackgroundViewController alloc]init];
        
        backVC.tag=1;
        
        __weak typeof(self) weakSelf = self;
        [backVC setChangePictureBlock:^(EHOMEBackgroundModel *model) {
            [weakSelf.addImageView sd_setImageWithURL:[NSURL URLWithString:model.file.path] placeholderImage:[UIImage imageNamed:@""]];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            weakSelf.RIModel=model;
        }];
        [self.navigationController pushViewController:backVC animated:YES];
    }
}


-(void)saveAct{
    NSString *nameStr =self.newnameTF.text;
    
    if([nameStr isEqualToString:@""]){
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please enter room name", @"Room", nil) hideAfterDelay:1];
    }else if(self.RIModel==nil){
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please select room background", @"Room", nil) hideAfterDelay:1];
    }else{
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Creating room", @"Room", nil) hideAfterDelay:10];
        
        [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
            EHOMEHomeModel *homeModel = responseObject;
            [homeModel addNewRoomWithName:nameStr roomBackground:self.RIModel success:^(id responseObject) {
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"add room success", @"Room", nil) hideAfterDelay:1.0];
                self.refreshRLBlock(YES);
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [HUDHelper hideHUDForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Add room failure", @"Room", nil) hideAfterDelay:1];
            }];
        } failure:^(NSError *error) {
            NSLog(@"Get current home failed.error = %@", error);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.newnameTF.text isEqualToString:@"ex.Living Room"]){
        self.newnameTF.text=@"";
    }
    NSLog(@"所输入的内容为:%@",textField.text);
}

@end
