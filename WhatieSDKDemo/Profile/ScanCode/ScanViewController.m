//
//  ScanViewController.m
//  QRCode
//
//  Created by lisong on 2016/11/1.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+Message.h"
#import "MaskView.h"
#import "EHOMETabBarController.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, assign) BOOL flashOpen;
@property (nonatomic, strong) MaskView *maskview;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"Scan", @"Profile", nil);
    self.maskview=[[MaskView alloc] init];
    [self.view addSubview:self.maskview];
    [self.maskview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"light", @"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidClick:)];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0)
    {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];

        NSString *messageStr=metadataObject.stringValue;
        
        NSData *jsonData = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSLog(@"扫描结果=%@",dic);
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
            [self showAlertWithTitle:NSLocalizedStringFromTable(@"Scan results", @"Profile", nil) message:NSLocalizedStringFromTable(@"Scan code failure:code does not belong to eHome", @"Profile", nil) handler:^(UIAlertAction *action) {
                //[self gotoHome];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            int resultType=[[dic objectForKey:@"usage"] intValue];
            NSDictionary *resultDic=[dic objectForKey:@"infoObj"];
            NSString *timeStr=[resultDic objectForKey:@"timestamp"];
            long dTime = [timeStr longLongValue];
            NSLog(@"时间=%ld",dTime);
            if(resultType==1){
                int homeID=[[resultDic objectForKey:@"homeId"] intValue];
                
                [EHOMEHomeModel addMemberWithMemberEmail:[EHOMEUserModel getCurrentUser].email homeId:homeID generateTimeStamp:dTime success:^(id responseObject) {
                    NSLog(@"邀请成功");
                    
                    [self showAlertWithTitle:NSLocalizedStringFromTable(@"Scan results", @"home", nil) message:@"Join home successfully!" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                } failue:^(NSError *error) {
                    NSLog(@"邀请失败");
                    NSString *errorStr=error.domain;
                    [self showAlertWithTitle:NSLocalizedStringFromTable(@"Scan results", @"home", nil) message:errorStr handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }];

            }else if (resultType==2){
                NSString *shareUerIdStr=[resultDic objectForKey:@"adminId"];
                NSString *shareDeviceIdStr=[resultDic objectForKey:@"deviceId"];
                NSLog(@"shareUerId=%d",[shareUerIdStr intValue]);
                NSLog(@"shareDeviceId=%d",[shareDeviceIdStr intValue]);
                
                [EHOMEDeviceModel sharedDeviceWithAdminUserId:[shareUerIdStr intValue] sharedUserId:[EHOMEUserModel getCurrentUser].id deviceId:[shareDeviceIdStr intValue] timestamp:dTime suucessBlock:^(id responseObject) {
                    NSLog(@"分享设备成功 = %@", responseObject);
                    NSNotification *notice = [NSNotification notificationWithName:@"AddDevice" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notice];
                    
                    [self showAlertWithTitle:NSLocalizedStringFromTable(@"Scan results", @"home", nil) message:@"Add device successfully!" handler:^(UIAlertAction *action) {
                        //[self gotoHome];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                } failBlock:^(NSError *error) {
                    NSLog(@"分享设备失败 =%@",error);
                    NSString *errorStr;
                    if([error.domain isEqualToString:@"交互失败,请重试！"]){
                        errorStr=NSLocalizedStringFromTable(@"Interaction failed. Please try again!", @"home", nil);
                    }else{
                        errorStr=error.domain;
                    }
                    [self showAlertWithTitle:NSLocalizedStringFromTable(@"Scan results", @"home", nil) message:errorStr handler:^(UIAlertAction *action) {
                        //[self gotoHome];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }];
                
            }else{
                int homeID=[[resultDic objectForKey:@"homeId"] intValue];
                int hostID=[[resultDic objectForKey:@"hostId"] intValue];
                
                [EHOMEHomeModel transferHomeWithHomeId:homeID hostId:hostID transferEmail:[EHOMEUserModel getCurrentUser].email generateTimeStamp:dTime success:^(id responseObject) {
                    NSLog(@"转让家庭成功");
                    [self showAlertWithTitle:NSLocalizedStringFromTable(@"Scan results", @"home", nil) message:@"Control Home successfully!" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"转让家庭失败= %@",error);
                    NSString *errorStr=error.domain;
                    [self showAlertWithTitle:NSLocalizedStringFromTable(@"Scan results", @"home", nil) message:errorStr handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }];
                
            }
            
        }

    }
}

-(void)gotoHome{
    EHOMETabBarController *homeTabbar = [[EHOMETabBarController alloc] initWithNibName:@"EHOMETabBarController" bundle:nil];
    [self presentViewController:homeTabbar animated:YES completion:nil];
}

#pragma mark - 开关闪光灯
- (void)rightBarButtonDidClick:(UIBarButtonItem *)item
{
    self.flashOpen = !self.flashOpen;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        
        if (self.flashOpen)
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Turn off", @"home", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidClick:)];

            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOn;
        }
        else
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Turn on", @"home", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidClick:)];

            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
        }
        
        [device unlockForConfiguration];
    }
}

#pragma mark - Getter
- (AVCaptureSession *)session
{
    if (!_session)
    {
        _session = ({
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input)
            {
                return nil;
            }
            
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            //设置代理 在主线程里刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            //设置扫描区域的比例
            CGFloat width = 300 / CGRectGetHeight(self.view.frame);
            CGFloat height = 300 / CGRectGetWidth(self.view.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];
            
            //设置扫码支持的编码格式(这里设置条形码和二维码兼容)
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            
            session;
        });
    }
    
    return _session;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
