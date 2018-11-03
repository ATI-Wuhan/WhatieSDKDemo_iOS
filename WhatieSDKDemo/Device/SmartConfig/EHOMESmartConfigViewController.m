//
//  EHOMESmartConfigViewController.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/21.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMESmartConfigViewController.h"

#import <PPNetworkHelper/PPNetworkHelper.h>
#import "EHOMEGetStartViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import <QuartzCore/QuartzCore.h>
#import <MDRadialProgress/MDRadialProgressView.h>
#import <MDRadialProgress/MDRadialProgressTheme.h>
#import "ZZCACircleProgress.h"


@interface EHOMESmartConfigViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *SSID;
@property (nonatomic, copy) NSString *BSSID;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) MDRadialProgressView *progressView;
@property (nonatomic, assign) int duration;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSDictionary *recieveDic;
@property (nonatomic, strong) NSString *RoomName;
@property (nonatomic, assign) BOOL isRegister;
@property (nonatomic, assign) BOOL isSmartconfig;

@property(nonatomic,strong) UILabel *pleaseLabel;
@property(nonatomic,strong) UILabel *yourLabel;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UILabel *progressLabel1;
@property(nonatomic,strong) UIImageView *progressImage1;
@property(nonatomic,strong) UIActivityIndicatorView *_spinner1;
@property(nonatomic,strong) UILabel *progressLabel2;
@property(nonatomic,strong) UIImageView *progressImage2;
@property(nonatomic,strong) UIActivityIndicatorView *_spinner2;
@property(nonatomic,strong) UILabel *progressLabel3;
@property(nonatomic,strong) UIImageView *progressImage3;
@property(nonatomic,strong) UIActivityIndicatorView *_spinner3;

@end

@implementation EHOMESmartConfigViewController{
    ZZCACircleProgress *circle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedStringFromTable(@"Config", @"Device", nil);
    self.isRegister = NO;
    self.isSmartconfig = NO;
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Stop", @"Device", nil) style:UIBarButtonItemStylePlain target:self action:@selector(stopSmartConfigAction)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popSmartConfig)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    //禁止侧滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    [self setupviews];
    
    __weak typeof(self) weakSelf = self;
    
    
    NSString *ssid = [[self wifiInfo] objectForKey:@"SSID"];
    NSString *bssid = [[self wifiInfo] objectForKey:@"BSSID"];
    NSString *password = self.wifiPassword;

    [[EHOMESmartConfig shareInstance] startSmartConfigWithSsid:ssid bssid:bssid password:password success:^(id responseObject) {
        NSLog(@"Smart config success = %@", responseObject);
        self.isSmartconfig = YES;
        
        //设备配网成功
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUDHelper hideAllHUDsForView:self.view animated:YES];
            
            [self._spinner1 stopAnimating];
            self.progressImage1.hidden=NO;
            [self._spinner2 startAnimating];
            self.progressLabel2.textColor = [UIColor THEMECOLOR];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"Smart config failed = %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[HUDHelper hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"配网失败");
            [self showFailAlert];
        });
    }];
    
    [[EHOMEMQTTClientManager shareInstance] setMqttBlock:^(NSString *topic, NSData *data) {
        NSDictionary *MQTTMessage = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([[MQTTMessage allKeys] containsObject:@"protocol"]) {
            NSInteger protocol = [[MQTTMessage objectForKey:@"protocol"] integerValue];
            
            if (protocol == 10) {
                
            }else if (protocol == 9) {
                //设备确认配好，通知APP
                self.isRegister = YES;
                [weakSelf._spinner2 stopAnimating];
                weakSelf.progressImage2.hidden=NO;
                [weakSelf._spinner3 startAnimating];
                weakSelf.progressLabel3.textColor = [UIColor THEMECOLOR];
                
                weakSelf.timer1 =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(action1) userInfo:nil repeats:NO];
                weakSelf.recieveDic=MQTTMessage;
                
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self._spinner1 startAnimating];
    self.progressLabel1.textColor = [UIColor THEMECOLOR];
}

-(void)viewDidAppear:(BOOL)animated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isRegister && self.isSmartconfig) {
            NSLog(@"注册失败");
            [self showFailAlert];
        }
    });
}

-(void)popSmartConfig{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Device", @"提示") message:NSLocalizedStringFromTable(@"Do you want to stop SmartConfig?", @"DeviceFunction", @"返回将停止配网，你确定返回吗") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", @"取消") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self stopSmartConfigAction];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(void)action1{
    [self._spinner3 stopAnimating];
    self.progressImage3.hidden=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        
        EHOMEGetStartViewController *getStartedVC = [[EHOMEGetStartViewController alloc] initWithNibName:@"EHOMEGetStartViewController" bundle:nil];
        getStartedVC.devId = [[self.recieveDic objectForKey:@"data"] objectForKey:@"devId"];
        getStartedVC.deviceName = [[self.recieveDic objectForKey:@"data"] objectForKey:@"name"];
        [self.navigationController pushViewController:getStartedVC animated:YES];
    });
    
}

-(void)setupviews{
    //设置圆形进度条
    CGFloat xCrack = (DEVICE_W - 130)/2;
    CGFloat yCrack = 60;
    CGFloat itemWidth = 130;
    circle = [[ZZCACircleProgress alloc]initWithFrame:CGRectMake(xCrack, yCrack, itemWidth, itemWidth) pathBackColor:nil pathFillColor:[UIColor THEMECOLOR] startAngle:-90 strokeWidth:5];
    circle.showPoint = NO;
    circle.increaseFromLast = YES;
    circle.prepareToShow =YES;
    circle.duration = 60;
    circle.progress=1.0;
    [self.view addSubview:circle];
    
    self.pleaseLabel = [[UILabel alloc]init];
    self.pleaseLabel.textColor = [UIColor blackColor];
    self.pleaseLabel.text = NSLocalizedStringFromTable(@"Please Wait", @"Device", nil);
    self.pleaseLabel.font = [UIFont systemFontOfSize:18];
    self.pleaseLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pleaseLabel];
    
    self.yourLabel = [[UILabel alloc]init];
    self.yourLabel.textColor = [UIColor grayColor];
    self.yourLabel.text = NSLocalizedStringFromTable(@"willbe available", @"Device", nil);
    self.yourLabel.font = [UIFont systemFontOfSize:14];
    self.yourLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.yourLabel];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.textColor = [UIColor grayColor];
    self.tipLabel.text = NSLocalizedStringFromTable(@"Please ensure", @"Device", nil);
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.numberOfLines=0;
    [self.view addSubview:self.tipLabel];
    
    self.progressLabel1 = [[UILabel alloc]init];
    self.progressLabel1.textColor = RGB(31, 155, 230);
    self.progressLabel1.text = NSLocalizedStringFromTable(@"progress1", @"Device", nil);
    self.progressLabel1.font = [UIFont systemFontOfSize:14];
    self.progressLabel1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.progressLabel1];
    
    UIImage *okImage;
    if (CurrentApp == Geek) {
        okImage = [UIImage imageNamed:@"geek+progress_ok"];
    }else if (CurrentApp == Ozwi){
        okImage = [UIImage imageNamed:@"ozwi_progress_ok"];
    }else{
        okImage = [UIImage imageNamed:@"progress_ok"];
    }
    self.progressImage1 = [[UIImageView alloc]initWithImage:okImage];
    self._spinner1=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self._spinner1.color=[UIColor THEMECOLOR];
    [self.view addSubview:self.progressImage1];
    [self.view addSubview:self._spinner1];
    self.progressImage1.hidden=YES;
    
    self.progressLabel2 = [[UILabel alloc]init];
    self.progressLabel2.textColor = [UIColor grayColor];
    self.progressLabel2.text = NSLocalizedStringFromTable(@"progress2", @"Device", nil);
    self.progressLabel2.font = [UIFont systemFontOfSize:14];
    self.progressLabel2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.progressLabel2];
    
    self.progressImage2 = [[UIImageView alloc]initWithImage:okImage];
    self._spinner2=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self._spinner2.color=[UIColor THEMECOLOR];
    [self.view addSubview:self.progressImage2];
    [self.view addSubview:self._spinner2];
    self.progressImage2.hidden=YES;
    
    self.progressLabel3 = [[UILabel alloc]init];
    self.progressLabel3.textColor = [UIColor grayColor];
    self.progressLabel3.text = NSLocalizedStringFromTable(@"progress3", @"Device", nil);
    self.progressLabel3.font = [UIFont systemFontOfSize:14];
    self.progressLabel3.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.progressLabel3];
    
    self.progressImage3 = [[UIImageView alloc]initWithImage:okImage];
    self._spinner3=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self._spinner3.color=[UIColor THEMECOLOR];
    [self.view addSubview:self.progressImage3];
    [self.view addSubview:self._spinner3];
    self.progressImage3.hidden=YES;
    
    [self autoLayout];
    
}

-(void)autoLayout{
    
    [self.pleaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(circle.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(180, 30));
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.tipLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_W, 50));
        make.top.mas_equalTo(self.pleaseLabel.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.yourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_W, 25));
        make.top.mas_equalTo(self.tipLabel.mas_bottom).mas_offset(16);
        make.centerX.mas_equalTo(self.view);
    }];
    

    
    [self.progressImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.mas_equalTo(self.yourLabel.mas_bottom).mas_offset(36);
        make.trailing.mas_equalTo(-30);
    }];
    
    [self._spinner1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.progressImage1);
    }];
    
    [self.progressLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.height.mas_equalTo(21);
        make.trailing.mas_equalTo(-40);
        make.centerY.mas_equalTo(self.progressImage1);
    }];

    
    [self.progressImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.mas_equalTo(self.progressLabel1.mas_bottom).mas_offset(8);
        make.trailing.mas_equalTo(-30);
    }];
    
    [self._spinner2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.progressImage2);
    }];
    
    
    [self.progressLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.progressLabel1);
        make.centerY.mas_equalTo(self.progressImage2);
    }];
    

    
    [self.progressImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.trailing.mas_equalTo(-30);
        make.top.mas_equalTo(self.progressLabel2.mas_bottom).mas_offset(8);
    }];
    
    [self._spinner3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.progressImage3);
    }];
    
    [self.progressLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.progressLabel2);
        make.centerY.mas_equalTo(self.progressImage3);
    }];

}

-(void)showFailAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Config failed", @"Device", nil) message:NSLocalizedStringFromTable(@"problems", @"Device", nil) preferredStyle:  UIAlertControllerStyleAlert];
    UIView *subView1 = alert.view.subviews[0];
    UIView *subView2 = subView1.subviews[0];
    UIView *subView3 = subView2.subviews[0];
    UIView *subView4 = subView3.subviews[0];
    UIView *subView5 = subView4.subviews[0];
    //UILabel *title = subView5.subviews[0];
    UILabel *message = subView5.subviews[1];//修改title
    message.textAlignment = NSTextAlignmentLeft;
    //title.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",NSLocalizedStringFromTable(@"Config failed", @"Device", nil)]];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
//    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedStringFromTable(@"problems", @"Device", nil)];
//    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 212)];
//    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 212)];
//    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    //修改按钮的颜色
    UIAlertAction *ReconnetAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Reconnect", @"Device", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [ReconnetAction setValue:[UIColor THEMECOLOR] forKey:@"titleTextColor"];
    [alert addAction:ReconnetAction];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)stopSmartConfigAction{
    
    [[EHOMESmartConfig shareInstance] stopSmartConfig];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)wifiInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"interfaces:%@",ifs);
    NSDictionary *info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        NSLog(@"%@ => %@",ifname,info);
    }
    return info;
}






@end
