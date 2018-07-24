//
//  EHOMEUseEchoVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEUseEchoVC.h"

@interface EHOMEUseEchoVC ()
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation EHOMEUseEchoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"Use Echo", @"Profile", nil);
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.webview = [[UIWebView alloc] init];
    [self.view addSubview:self.webview];
    
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.webview.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webview.scalesPageToFit = YES ;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://users.whatie.net/jsp/index/amazonAccess.html"]];
    [self.view addSubview:self.webview];
    [self.webview loadRequest:request];
    // Do any additional setup after loading the view.
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
