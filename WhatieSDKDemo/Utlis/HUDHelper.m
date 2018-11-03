//
//  HUDHelper.m
//  HousePurchase
//
//  Created by Johnsonlrd on 14-5-13.
//  Copyright (c) 2014年 JXJT. All rights reserved.
//

#import "HUDHelper.h"
#import "MBProgressHUD.h"

@implementation HUDHelper

+ (MBProgressHUD *)addHUDProgressInView:(UIView *)view text:(NSString *)text
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘
    
    [self hideAllHUDsForView:view animated:NO];
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];
    progress.detailsLabelText = text;

    progress.removeFromSuperViewOnHide = YES;
    [view addSubview:progress];
    [view bringSubviewToFront:progress];
    [progress show:YES];
    return progress;
}

+ (MBProgressHUD *)addHUDProgressInView:(UIView *)view text:(NSString *)text hideAfterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self addHUDProgressInView:view text:text];
    [self hideHUD:hud afterDelay:delay animated:YES];
    return hud;
}

//+ (MBProgressHUD *)addHUDInView:(UIView *)view
//{
//    return [self addHUDInView:view text:nil fontSize:0 alpha:1.f];
//}

+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text
{
    return [self addHUDInView:view text:text fontSize:18.f alpha:1.f];
}

+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text hideAfterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self addHUDInView:view text:text];
    
   
    [self hideHUD:hud afterDelay:delay animated:YES];
    return hud;
}

+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text fontSize:(CGFloat)fontSize
{
    return [self addHUDInView:view text:text fontSize:fontSize alpha:1.f];
}

+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text fontSize:(CGFloat)fontSize alpha:(CGFloat)alpha
{
    [self hideAllHUDsForView:view animated:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘

    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];
    progress.removeFromSuperViewOnHide = YES;
    [progress setAlpha:alpha];
    if (text != nil) {
        progress.mode = MBProgressHUDModeText;
        progress.detailsLabelText = text;
        //progress.detailsLabel.font = [UIFont boldSystemFontOfSize:13];
        //progress.detailsLabel.textColor = [UIColor blackColor];
        progress.labelFont = [UIFont boldSystemFontOfSize:fontSize];
    }

    [view addSubview:progress];
    [view bringSubviewToFront:progress];
    [progress show:YES];
    return progress;
}

+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}

+ (void)hideHUD:(MBProgressHUD *)progress afterDelay:(NSTimeInterval)delay animated:(BOOL)animated
{
    [progress hide:animated afterDelay:delay];
}


+(void)showErrorDomain:(NSError *)error{
    
    NSString *code = [NSString stringWithFormat:@"%@",@(error.code)];
    //NSString *domain = error.domain;
    
    NSString *errorString = NSLocalizedStringFromTable(code, @"language", nil);
    
    if ([errorString isEqualToString:code]) {
        errorString = NSLocalizedStringFromTable(@"-999", @"language", nil);
    }
    
    [HUDHelper addHUDInView:sharedKeyWindow text:errorString hideAfterDelay:1.0];
}

@end
