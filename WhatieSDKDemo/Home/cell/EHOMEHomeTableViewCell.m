//
//  EHOMEHomeTableViewCell.m
//  WhatieSDKDemo
//
//  Created by Change on 2018/4/20.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEHomeTableViewCell.h"


@implementation EHOMEHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.deviceBGView.layer.masksToBounds = YES;
    self.deviceBGView.layer.cornerRadius = 3.0;
    
    [self.deviceSwitch setOnTintColor:[UIColor THEMECOLOR]];
    
    self.myswitch = [[EHOMESwitch alloc] initWithFrame:CGRectMake(0, 0, 61, 41)];
    self.myswitch.delegate = self;
    [self addSubview:self.myswitch];
    
    [self.myswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.deviceSwitch);
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(41);
    }];
    
//    [myswitch showLoading];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeDeviceStatusSwitchAction:(id)sender {
    
    UISwitch *deviceSwitch = (UISwitch *)sender;
    
    NSLog(@"Switch status = %d, %@", deviceSwitch.on, _deviceModel.device.devId);
    
    BOOL isOn = deviceSwitch.on;

    [_deviceModel updateDeviceStatus:isOn success:^(id responseObject) {
        NSLog(@"update device status success. res = %@", responseObject);
        
    } failure:^(NSError *error) {
        NSLog(@"update device status failed. error = %@", error);
    }];
    
}

-(void)setDeviceModel:(EHOMEDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    if (_deviceModel != nil) {
        
        self.deviceNameLabel.text = _deviceModel.device.name;
        
        self.deviceLocationLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Located in", @"Home", nil), _deviceModel.roomName];
        
        if([_deviceModel.productName isEqualToString:@"RgbLight"]){
            [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:_deviceModel.device.product.picture.path] placeholderImage:[UIImage imageNamed:@"rgb_light"]];
        }else if ([_deviceModel.productName isEqualToString:@"Plug"]){
            [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:_deviceModel.device.product.picture.path] placeholderImage:[UIImage imageNamed:@"socket"]];
        }else if ([_deviceModel.productName isEqualToString:@"PowerStrips"]){
            [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:_deviceModel.device.product.picture.path] placeholderImage:[UIImage imageNamed:@"socket"]];
        }
        
        if ([self.deviceModel.device.status isEqualToString:@"Offline"]) {
            self.deviceStatusLabel.textColor = RGB(119, 119, 119);
            [self.deviceSwitch setOn:NO];
            self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"Offline", @"Device", nil);
            [self.deviceSwitch setEnabled:NO];
            
            [self.myswitch showSwitchStatus:3];
        }else{
            [self.deviceSwitch setEnabled:YES];
            
            if([_deviceModel.productName isEqualToString:@"RgbLight"]){
                if (_deviceModel.functionValuesMap.colorLight) {
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"On", @"Device", nil);
                    [self.deviceSwitch setOn:YES];
                    self.deviceStatusLabel.textColor = RGB(54, 236, 76);
                    
                    [self.myswitch showSwitchStatus:1];
                }else{
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"Off", @"Device", nil);
                    [self.deviceSwitch setOn:NO];
                    self.deviceStatusLabel.textColor = [UIColor blackColor];
                    
                    [self.myswitch showSwitchStatus:0];
                }
            }else if ([_deviceModel.productName isEqualToString:@"Plug"]){
                if (_deviceModel.functionValuesMap.power) {
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"On", @"Device", nil);
                    [self.deviceSwitch setOn:YES];
                    self.deviceStatusLabel.textColor = RGB(54, 236, 76);
                    
                    [self.myswitch showSwitchStatus:1];
                }else{
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"Off", @"Device", nil);
                    [self.deviceSwitch setOn:NO];
                    self.deviceStatusLabel.textColor = [UIColor blackColor];
                    
                    [self.myswitch showSwitchStatus:0];
                }
            }else if ([_deviceModel.productName isEqualToString:@"PowerStrips"]){
                if([_deviceModel.functionValuesMap.stripsPower isEqualToString:@"111"]){
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"On", @"Device", nil);
                    [self.deviceSwitch setOn:YES];
                    self.deviceStatusLabel.textColor = RGB(54, 236, 76);
                    
                    [self.myswitch showSwitchStatus:1];
                }else{
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"Off", @"Device", nil);
                    [self.deviceSwitch setOn:NO];
                    self.deviceStatusLabel.textColor = [UIColor blackColor];
                    
                    [self.myswitch showSwitchStatus:0];
                }
            }else if ([_deviceModel.productName isEqualToString:@"MonochromeLight"]){
                NSLog(@"是单色灯吗 =%d",_deviceModel.functionValuesMap.colorLight);
                if (_deviceModel.functionValuesMap.colorLight) {
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"On", @"Device", nil);
                    [self.deviceSwitch setOn:YES];
                    self.deviceStatusLabel.textColor = RGB(54, 236, 76);
                    
                    [self.myswitch showSwitchStatus:1];
                }else{
                    self.deviceStatusLabel.text = NSLocalizedStringFromTable(@"Off", @"Device", nil);
                    [self.deviceSwitch setOn:NO];
                    self.deviceStatusLabel.textColor = [UIColor blackColor];
                    
                    [self.myswitch showSwitchStatus:0];
                }
            }
        }
        
    }
}

-(void)clickedMySwitchWithStatus:(BOOL)isOn{
    
    [_deviceModel updateDeviceStatus:isOn success:^(id responseObject) {
        NSLog(@"update device status success. res = %@", responseObject);
        
    } failure:^(NSError *error) {
        NSLog(@"update device status failed. error = %@", error);
    }];
}


@end
