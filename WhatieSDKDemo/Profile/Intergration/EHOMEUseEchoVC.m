//
//  EHOMEUseEchoVC.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/6/29.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEUseEchoVC.h"
#import <WebKit/WebKit.h>

@interface EHOMEUseEchoVC ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation EHOMEUseEchoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *urls = @[@"https://users.whatie.net/jsp/index/amazonAccess.html",
                      @"https://users.whatie.net/jsp/index/googleAccess.html"];
    
//    if (_intergration == 0) {
//        self.title=NSLocalizedStringFromTable(@"Use Amazon Alexa", @"Profile", nil);
//    }else{
//        self.title=NSLocalizedStringFromTable(@"Use Google Home", @"Profile", nil);
//    }
    
    // 第二步：初始化
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urls[_intergration]]];
    // WKWebView初始化
    // 方法一：（简单的设置）
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    
    // 方法二：（对网页进行相关的配置，下次再详细介绍）
    //    //设置网页的配置文件
    //    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    // 加载请求
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    // KVO，监听webView属性值得变化(estimatedProgress,title为特定的key)
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    // UIProgressView初始化
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, self.webView.frame.size.width, 2);
    self.progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
    if (CurrentApp == Geek) {
        self.progressView.progressTintColor = RGBA(25, 107, 162, 0.5);
    }else if (CurrentApp == Ozwi){
        self.progressView.progressTintColor = RGBA(0, 145, 152, 0.5);
    }else{
        self.progressView.progressTintColor = RGBA(38, 175, 246, 0.5);
    }
    // 设置初始的进度，防止用户进来就懵逼了（微信大概也是一开始设置的10%的默认值）
    [self.progressView setProgress:0.1 animated:YES];
    [self.webView addSubview:self.progressView];
    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    
    // 最后一步：移除监听
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

#pragma mark - KVO监听
// 第三部：完成监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条

        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"打印测试进度值：%f", newprogress);

        if (newprogress == 1) { // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });

        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    } else if ([object isEqual:self.webView] && [keyPath isEqualToString:@"title"]) { // 标题

        self.title = self.webView.title;
        NSLog(@"打印标题：%@", self.webView.title);
    } else { // 其他

        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
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
