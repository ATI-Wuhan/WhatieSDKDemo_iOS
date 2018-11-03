//
//  EHOMEShareViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/24.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEShareViewController.h"

@interface EHOMEShareViewController ()
@property (retain, nonatomic) IBOutlet UILabel *emailLabel;
@property (retain, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation EHOMEShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapEmailLabel;
    if(self.codeType==1){
        self.title= NSLocalizedStringFromTable(@"Invite Member", @"Home", nil);
        self.emailLabel.text = NSLocalizedStringFromTable(@"Invite Member By Email", @"Home", nil);
        tapEmailLabel=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(InviteMemberWithEmail)];
    }else if (self.codeType==3){
        self.title= NSLocalizedStringFromTable(@"Transfer Home", @"Home", nil);
        self.emailLabel.text = NSLocalizedStringFromTable(@"Transfer Home By Email", @"Home", nil);
        tapEmailLabel=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TransferHomeWithEmail)];
    }else{
        self.title= NSLocalizedStringFromTable(@"Device Share", @"Home", nil);
        self.emailLabel.text = NSLocalizedStringFromTable(@"Share Device By Email", @"Home", nil);
        tapEmailLabel=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShareDeviceWithEmail)];
    }
    self.emailLabel.userInteractionEnabled=YES;
    [self.emailLabel addGestureRecognizer:tapEmailLabel];
    
    //二维码
    UIImage *OriginQRCode = [[UIImage alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    long dTime = [[NSNumber numberWithDouble:time] longValue];
    NSLog(@"时间戳=%ld",dTime);
    
    NSDictionary *shareDic;
    if(self.codeType==1){
        int homeId = self.homeModel.id;
        shareDic=@{@"infoObj":@{@"homeId":@(homeId),
                                @"timestamp":@(dTime)
                                },
                   @"usage":@(1)
                   };
    }else if (self.codeType==2){
        int devID = self.deviceModel.device.id;
        shareDic=@{@"infoObj":@{@"adminId":@([EHOMEUserModel getCurrentUser].id),
                                @"deviceId":@(devID),
                                @"timestamp":@(dTime)
                                },
                   @"usage":@(2)
                   };
    }else{
        int homeId = self.homeModel.id;
        int hostId = self.homeModel.host.id;
        shareDic=@{@"infoObj":@{@"homeId":@(homeId),
                                @"hostId":@(hostId),
                                @"timestamp":@(dTime)
                                },
                   @"usage":@(3)
                   };
    }
    
    OriginQRCode=[self createQRImageWithString:[shareDic mj_JSONString] size:CGSizeMake(200,200)];
    self.QRCodeImageView.image = [self addSmallImageForQRImage:OriginQRCode];
    
    //文本
    if(self.codeType==1){
        self.detailLabel.text= NSLocalizedStringFromTable(@"Invite Member", @"Home", nil);
    }else if (self.codeType==3){
        self.detailLabel.text= NSLocalizedStringFromTable(@"Transfer Home", @"Home", nil);
    }else{
        self.detailLabel.text = NSLocalizedStringFromTable(@"Device Share", @"Home", nil);
    }
    // Do any additional setup after loading the view from its nib.
}

/** 生成指定大小的黑白二维码 */
- (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    NSLog(@"%@",qrFilter.inputKeys);
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    //放大并绘制二维码 (上面生成的二维码很小，需要放大)
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

/** 在二维码中心加一个小图 */
- (UIImage *)addSmallImageForQRImage:(UIImage *)qrImage
{
    UIGraphicsBeginImageContext(qrImage.size);
    
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    
    UIImage *image;
    switch (CurrentApp) {
        case eHome:{
            image = [UIImage imageNamed:@"AppIcon"];
        }
            break;
        case Geek:{
            image = [UIImage imageNamed:@"aboutLogoGeekHome"];
        }
            break;
        case Ozwi:{
            image = [UIImage imageNamed:@"aboutLogoOzwiHome"];
        }
            break;
            
        default:{
            image = [UIImage imageNamed:@"AppIcon"];
        }
            break;
    }
    
    CGFloat imageW = 40;
    CGFloat imageX = (qrImage.size.width - imageW) * 0.5;
    CGFloat imgaeY = (qrImage.size.height - imageW) * 0.5;
    
    [image drawInRect:CGRectMake(imageX, imgaeY, imageW, imageW)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(void)InviteMemberWithEmail{
    NSString *title = NSLocalizedStringFromTable(@"Invitation", @"Home", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"inviting home member", @"Home", nil) hideAfterDelay:10];
            
            [self.homeModel inviteHomeMemberByEmail:name success:^(id responseObject) {
                NSLog(@"邀请成功");
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Invite successfully", @"Home", nil) hideAfterDelay:1];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                NSLog(@"inviting home failed. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper showErrorDomain:error];
            }];
            
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil) hideAfterDelay:1.0];
        }
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)TransferHomeWithEmail{
    NSString *title = NSLocalizedStringFromTable(@"Transfer", @"Home", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name = [[alertController textFields] firstObject].text;
        
        if (name.length > 0) {
            [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"transfering home", @"Home", nil) hideAfterDelay:10];
            
            [self.homeModel transferHomeWithByEmail:name success:^(id responseObject) {
                NSLog(@"转让家庭成功");
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Tranfer home sucessfully", @"Home", nil) hideAfterDelay:1];
                
                [[EHOMEUserModel shareInstance] getCurrentHomeSuccess:^(id responseObject) {
                    EHOMEHomeModel *home = responseObject;
                    NSLog(@"要删除的家庭id=%d，当前家庭id=%d",self.homeModel.id,home.id);
                    if(self.homeModel.id == home.id){
                        [[EHOMEUserModel shareInstance] removeCurrentHome];
                    }
                    
                } failure:^(NSError *error) {
                    NSLog(@"Get current home failed.error = %@", error);
                }];
                
                NSNotification *notice = [NSNotification notificationWithName:@"tranferHome" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
                
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                NSLog(@"转让家庭失败. error = %@", error);
                [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
                [HUDHelper showErrorDomain:error];
            }];
            
        }else{
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Please enter email", @"Localizable", nil) hideAfterDelay:1.0];
        }
        
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)ShareDeviceWithEmail{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", @"Device", nil) message:NSLocalizedStringFromTable(@"share by email", @"Device", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedStringFromTable(@"friends email", @"Device", nil);
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"Info", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        
        NSString *email = [alertController.textFields firstObject].text;
        
        [HUDHelper addHUDProgressInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Sharing", @"Device", nil) hideAfterDelay:10];
        
        [self.deviceModel shareDeviceByEmail:email success:^(id responseObject) {
            NSLog(@"share device success. res = %@", responseObject);
            
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Share success", @"Device", nil) hideAfterDelay:1.5];
            
        } failure:^(NSError *error) {
            NSLog(@"share device failed. error = %@", error);
            [HUDHelper hideAllHUDsForView:sharedKeyWindow animated:YES];
            [HUDHelper showErrorDomain:error];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Info", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    
    [alertController addAction:updateAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
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

- (void)dealloc {
    [_emailLabel release];
    [_QRCodeImageView release];
    [_detailLabel release];
    [super dealloc];
}
@end
