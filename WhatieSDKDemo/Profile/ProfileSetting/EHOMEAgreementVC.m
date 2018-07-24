//
//  EHOMEAgreementVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/27.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAgreementVC.h"

@interface EHOMEAgreementVC ()
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation EHOMEAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=GREYCOLOR;
    
    self.webview = [[UIWebView alloc] init];
    [self.view addSubview:self.webview];
    
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.webview.dataDetectorTypes = UIDataDetectorTypeAll;
    
    if (self.fromWhere == 0) {
        self.title=NSLocalizedStringFromTable(@"Features", @"Profile", nil);
    }else if (self.fromWhere == 2){
        self.title=NSLocalizedStringFromTable(@"Service Agreement", @"Profile", nil);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *filePath;
        if (self.fromWhere == 0) {
            filePath = [[NSBundle mainBundle] pathForResource:@"features" ofType:@"html"];
        }else if (self.fromWhere == 2){
            filePath = [[NSBundle mainBundle] pathForResource:@"TermsOfUse" ofType:@"html"];
        }
        
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSURL *url = [[NSURL alloc] initWithString:filePath];
        [self.webview loadHTMLString:htmlString baseURL:url];
    });
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
