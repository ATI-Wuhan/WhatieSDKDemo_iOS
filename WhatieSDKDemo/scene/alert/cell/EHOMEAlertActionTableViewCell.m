//
//  EHOMEAlertActionTableViewCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEAlertActionTableViewCell.h"

@implementation EHOMEAlertActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDeviceModel:(EHOMESceneDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    if(_deviceModel != nil){
        [self.actionImageView sd_setImageWithURL:[NSURL URLWithString:_deviceModel.device.product.picture.path]];
        self.actionName.text = _deviceModel.device.name;
        if([_deviceModel.device.status isEqualToString:@"Offline"]){
            self.actionState.text = _deviceModel.device.status;
        }else{
            if(_deviceModel.device.product.productType == 3){
                NSString *outletStatus = (_deviceModel.dps.first == YES) ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
                self.actionState.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Switch", nil),outletStatus];
            }else{
                int lightmode = _deviceModel.dps.lightMode;
                if(lightmode == 1){
                    self.actionState.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"mode", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"sunlightmode", @"DeviceFunction", nil)];
                }else if (lightmode == 2){
                    self.actionState.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"mode", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"colorlightmode", @"DeviceFunction", nil)];
                }else if (lightmode == 5){
                    self.actionState.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"mode", @"DeviceFunction", nil),NSLocalizedStringFromTable(@"Streamermode", @"DeviceFunction", nil)];
                }else{
                    NSString *StatusStr = ([_deviceModel.dps.status isEqualToString:@"true"]) ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
                    self.actionState.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"Switch", nil),StatusStr];
                }
            }
        }
        
    }
}

- (void)dealloc {
    [_actionImageView release];
    [_actionName release];
    [_actionState release];
    [_stateImageView release];
    [super dealloc];
}
@end
