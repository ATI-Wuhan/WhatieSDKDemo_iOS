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


@interface EHOMESmartConfigViewController ()

@property (nonatomic, copy) NSString *SSID;
@property (nonatomic, copy) NSString *BSSID;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) MDRadialProgressView *progressView;
@property (nonatomic, assign) int duration;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, strong) NSDictionary *recieveDic;
@property (nonatomic, strong) NSString *RoomName;
@property (nonatomic, strong) NSArray *rooms;

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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Stop", @"Device", nil) style:UIBarButtonItemStylePlain target:self action:@selector(stopSmartConfigAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self setupviews];
    
    __weak typeof(self) weakSelf = self;
    
    
    NSString *ssid = [[self wifiInfo] objectForKey:@"SSID"];
    NSString *bssid = [[self wifiInfo] objectForKey:@"BSSID"];
    NSString *password = self.wifiPassword;

    [[EHOMESmartConfig shareInstance] startSmartConfigWithSsid:ssid bssid:bssid password:password success:^(id responseObject) {
        NSLog(@"Smart config success = %@", responseObject);
        
        [HUDHelper hideAllHUDsForView:self.view animated:YES];

        
        NSString *title = NSLocalizedStringFromTable(@"Success", @"Device", nil);
        NSString *message = NSLocalizedStringFromTable(@"Config Success", @"Device", nil);
        
        NSInteger protocol = [[responseObject objectForKey:@"protocol"] integerValue];
        
        if (protocol == 10) {
            //设备配网成功
        }else if (protocol == 9) {
            //设备确认配好，通知APP
            [self._spinner1 stopAnimating];
            self.progressImage1.hidden=NO;
            [self._spinner2 startAnimating];
            self.progressLabel2.textColor = THEMECOLOR;
            
            self.timer1 =[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(action1) userInfo:nil repeats:NO];
            self.recieveDic=responseObject;
            
            [self getRooms];
            
        }else{
            //the device is other's
            title = @"Sorry";
            NSString *email = [[responseObject objectForKey:@"data"] objectForKey:@"email"];
            NSString *bindedStr = NSLocalizedStringFromTable(@"binded", @"Device", nil);
            message = [NSString stringWithFormat:@"%@ %@",bindedStr,email];
            [weakSelf showAlertViewWithTitle:title message:message];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Smart config failed = %@", error);
        
        [HUDHelper hideAllHUDsForView:self.view animated:YES];
        
        //[weakSelf showAlertViewWithTitle:@"Alert" message:error.domain];
        [self._spinner1 stopAnimating];
        self.progressImage1.hidden=NO;
        [self showFailAlert];

    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self._spinner1 startAnimating];
    self.progressLabel1.textColor = THEMECOLOR;
}

-(void)getRooms{
    [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
        NSLog(@"Get current home success.home = %@", responseObject);
        
        
        EHOMEHomeModel *currenthome = responseObject;
        
        [currenthome syncRoomByHomeSuccess:^(id responseObject) {
            
            self.rooms = responseObject;
            
        } failure:^(NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Get current home failed.error = %@", error);
    }];
}

-(void)action1{
    [self._spinner2 stopAnimating];
    self.progressImage2.hidden=NO;
    [self._spinner3 startAnimating];
    self.progressLabel3.textColor = THEMECOLOR;
    
    [self.timer1 invalidate];
    self.timer1 = nil;
    
    self.timer2 =[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(action2) userInfo:nil repeats:NO];
    
}

-(void)action2{
    [self._spinner3 stopAnimating];
    self.progressImage3.hidden=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        
        EHOMEGetStartViewController *getStartedVC = [[EHOMEGetStartViewController alloc] initWithNibName:@"EHOMEGetStartViewController" bundle:nil];
        getStartedVC.devId = [[self.recieveDic objectForKey:@"data"] objectForKey:@"devId"];
        getStartedVC.deviceName = [[self.recieveDic objectForKey:@"data"] objectForKey:@"name"];
        getStartedVC.roomModelArray = self.rooms;
        [self.navigationController pushViewController:getStartedVC animated:YES];
    });
}

-(void)setupviews{
    //设置圆形进度条
    CGFloat xCrack = (DEVICE_W - 130)/2;
    CGFloat yCrack = 60;
    CGFloat itemWidth = 130;
    circle = [[ZZCACircleProgress alloc]initWithFrame:CGRectMake(xCrack, yCrack, itemWidth, itemWidth) pathBackColor:nil pathFillColor:THEMECOLOR startAngle:-90 strokeWidth:5];
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
    
    self.progressImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"progress_ok"]];
    self._spinner1=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self._spinner1.color=THEMECOLOR;
    [self.view addSubview:self.progressImage1];
    [self.view addSubview:self._spinner1];
    self.progressImage1.hidden=YES;
    
    self.progressLabel2 = [[UILabel alloc]init];
    self.progressLabel2.textColor = [UIColor grayColor];
    self.progressLabel2.text = NSLocalizedStringFromTable(@"progress2", @"Device", nil);
    self.progressLabel2.font = [UIFont systemFontOfSize:14];
    self.progressLabel2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.progressLabel2];
    
    self.progressImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"progress_ok"]];
    self._spinner2=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self._spinner2.color=THEMECOLOR;
    [self.view addSubview:self.progressImage2];
    [self.view addSubview:self._spinner2];
    self.progressImage2.hidden=YES;
    
    self.progressLabel3 = [[UILabel alloc]init];
    self.progressLabel3.textColor = [UIColor grayColor];
    self.progressLabel3.text = NSLocalizedStringFromTable(@"progress3", @"Device", nil);
    self.progressLabel3.font = [UIFont systemFontOfSize:14];
    self.progressLabel3.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.progressLabel3];
    
    self.progressImage3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"progress_ok"]];
    self._spinner3=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self._spinner3.color=THEMECOLOR;
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
    
    [self.progressLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(188, 25));
        make.top.mas_equalTo(self.yourLabel.mas_bottom).mas_offset(36);
        make.left.mas_equalTo(self.view).mas_offset(15);
    }];
    
    [self.progressImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.progressLabel1.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.progressLabel1);
    }];
    
    [self._spinner1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.progressLabel1.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.progressLabel1);
    }];
    
    [self.progressLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(153, 25));
        make.top.mas_equalTo(self.progressLabel1.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.view).mas_offset(15);
    }];
    
    [self.progressImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.progressLabel2.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.progressLabel2);
    }];
    
    [self._spinner2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.progressLabel2.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.progressLabel2);
    }];
    
    [self.progressLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(147, 25));
        make.top.mas_equalTo(self.progressLabel2.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.view).mas_offset(15);
    }];
    
    [self.progressImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.progressLabel3.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.progressLabel3);
    }];
    
    [self._spinner3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(self.progressLabel3.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.progressLabel3);
    }];

}

-(void)showFailAlert{
    [self._spinner1 stopAnimating];
    
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
    [ReconnetAction setValue:THEMECOLOR forKey:@"titleTextColor"];
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
