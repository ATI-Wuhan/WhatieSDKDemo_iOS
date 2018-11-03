//
//  EHOMEExecuteActionTableViewCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEExecuteActionTableViewCell.h"

@implementation EHOMEExecuteActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSceneDevcieModel:(EHOMESceneDeviceModel *)sceneDevcieModel{
    _sceneDevcieModel = sceneDevcieModel;
    if(_sceneDevcieModel != nil){
        [self.actionImageView sd_setImageWithURL:[NSURL URLWithString:_sceneDevcieModel.device.product.picture.path]];
        self.actionDeviceName.text = _sceneDevcieModel.device.name;
        
        if(_sceneDevcieModel.device.product.productType == 3){
            
            if([_sceneDevcieModel.device.status isEqualToString:@"Offline"]){
                self.actionType.text = NSLocalizedStringFromTable(@"Offline", @"Device", nil);
            }else if([_sceneDevcieModel.device.status isEqualToString:@"Online"]){
                NSString *str = (_sceneDevcieModel.dps.first == true) ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
                self.actionType.text = [NSString stringWithFormat:@"开关:%@",str];
            }else if ([_sceneDevcieModel.device.status isEqualToString:@"Unbind"]){
                self.actionType.text = NSLocalizedStringFromTable(@"Unbind", @"Device", nil);
            }else{
                self.actionType.text = NSLocalizedStringFromTable(@"FirmwareUpgrading", @"Device", nil);
            }
            
        }else if (_sceneDevcieModel.device.product.productType == 2){
            if([_sceneDevcieModel.device.status isEqualToString:@"Offline"]){
                self.actionType.text = NSLocalizedStringFromTable(@"Offline", @"Device", nil);
            }else if([_sceneDevcieModel.device.status isEqualToString:@"Online"]){
                if(_sceneDevcieModel.dps.lightMode == 4){
                    NSString *str = ([_sceneDevcieModel.dps.status isEqualToString:@"true"]) ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
                    self.actionType.text = [NSString stringWithFormat:@"模式:%@",str];
                }else{
                    
                    if(_sceneDevcieModel.dps.lightMode == 1){
                        self.actionType.text = @"模式:日光模式";
                    }else if(_sceneDevcieModel.dps.lightMode == 2){
                        self.actionType.text = @"模式:彩光模式";
                    }else if(_sceneDevcieModel.dps.lightMode == 5){
                        self.actionType.text = @"模式:流光模式";
                    }
                }
            }else if ([_sceneDevcieModel.device.status isEqualToString:@"Unbind"]){
                self.actionType.text = NSLocalizedStringFromTable(@"Unbind", @"Device", nil);
            }else{
                self.actionType.text = NSLocalizedStringFromTable(@"FirmwareUpgrading", @"Device", nil);
            }
        }else{
            
        }
        
    }
}

- (void)dealloc {
    [_actionImageView release];
    [_actionDeviceName release];
    [_actionType release];
    [_stateImageview release];
    [_stateSpiner release];
    [super dealloc];
}
@end
