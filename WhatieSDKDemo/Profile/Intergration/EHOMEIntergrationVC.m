//
//  EHOMEIntergrationVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEIntergrationVC.h"
#import "EHOMEUseEchoVC.h"

@interface EHOMEIntergrationVC ()
@property (nonatomic, strong)UIImageView *bgImage; //背景图片
@end

@implementation EHOMEIntergrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"Integration", @"Profile", nil);
    self.view.backgroundColor=GREYCOLOR;
    
    self.bgImage = [[UIImageView alloc]init];
    self.bgImage.image=[UIImage imageNamed:@"echo"];
    [self.view addSubview:self.bgImage];
    
    __weak typeof(self) weakSelf = self;
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).mas_offset(8);
        make.top.mas_equalTo(weakSelf.view).mas_offset(8);
        make.right.mas_equalTo(weakSelf.view).mas_offset(-8);
        make.height.mas_equalTo(200);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [self.bgImage addGestureRecognizer:tapGesture];
    self.bgImage.userInteractionEnabled = YES;
    // Do any additional setup after loading the view.
}

-(void)clickImage{
    EHOMEUseEchoVC *useVC=[[EHOMEUseEchoVC alloc] init];
    [self.navigationController pushViewController:useVC animated:YES];
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
