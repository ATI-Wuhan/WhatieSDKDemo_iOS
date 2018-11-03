//
//  EHOMEFamilyViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/9.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEFamilyViewController.h"

@interface EHOMEFamilyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *Transfertitle;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *Deletetitle;
@property (weak, nonatomic) IBOutlet UILabel *DeleteMember;

@end

@implementation EHOMEFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =NSLocalizedStringFromTable(@"Family Member", @"Home", nil);
    
    self.homeImageView.layer.masksToBounds = YES;
    self.homeImageView.layer.cornerRadius = 30.0;
    self.homeImageView.layer.borderWidth = 1;
    self.homeImageView.layer.borderColor=[[UIColor THEMECOLOR] CGColor];
    self.homeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.homeImageView.clipsToBounds = YES;
    [self.homeImageView sd_setImageWithURL:[NSURL URLWithString:self.memberModel.customer.portraitThumb.path] placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    self.homeNameLabel.text = self.memberModel.customer.name;
    self.detailLabel.text = self.memberModel.customer.email;
    
    self.Transfertitle.text=NSLocalizedStringFromTable(@"Transfer Home", @"Home", nil);
    
    self.setLabel.text=NSLocalizedStringFromTable(@"Set as Administrator", @"Home", nil);
    self.setLabel.backgroundColor = [UIColor THEMECOLOR];
    UITapGestureRecognizer *labelTapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickSet)];
    [self.setLabel addGestureRecognizer:labelTapGestureRecognizer1];
    self.setLabel.userInteractionEnabled = YES;
    
    self.Deletetitle.text=NSLocalizedStringFromTable(@"Delete Member", @"Home", nil);
    
    self.DeleteMember.text=NSLocalizedStringFromTable(@"Delete", @"Home", nil);
    self.DeleteMember.backgroundColor = [UIColor THEMECOLOR];
    UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickDelete)];
    [self.DeleteMember addGestureRecognizer:labelTapGestureRecognizer2];
    self.DeleteMember.userInteractionEnabled = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)ClickSet{
    //转让管理员
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"setting the administrator", @"Home", nil) hideAfterDelay:10];
    
    [self.homeModel transferAdminWithMemberModel:self.memberModel success:^(id responseObject) {
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Transfer successfully", @"Home", nil) hideAfterDelay:1];
        NSLog(@"成功%@",responseObject);
        NSNotification *notice = [NSNotification notificationWithName:@"transferAdmin" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"转让管理员失败！=%@",error);
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper showErrorDomain:error];
    }];
    
}

-(void)ClickDelete{
    //删除成员
    [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"deleting the member", @"Home", nil) hideAfterDelay:10];
    
    [self.memberModel removeMemberFromHome:self.homeModel success:^(id responseObject) {
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Delete successfully", @"Home", nil) hideAfterDelay:1];
        NSNotification *notice = [NSNotification notificationWithName:@"deleteMember" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"删除成员失败！=%@",error);
        [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
        [HUDHelper showErrorDomain:error];
    }];
    
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
