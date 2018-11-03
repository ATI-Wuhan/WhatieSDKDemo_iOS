//
//  EHOMEManualSceneCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/24.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEManualSceneCell.h"

@implementation EHOMEManualSceneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickExecute)];
    [self.executeImageView addGestureRecognizer:tapGesture];
    self.executeImageView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMSceneModel:(EHOMESceneModel *)MSceneModel{
    _MSceneModel = MSceneModel;
    if(_MSceneModel != nil){
        self.manualSceneName.text = _MSceneModel.scene.name;
        
        NSMutableArray *devicetypeAry =[NSMutableArray array];
        if(_MSceneModel.sceneDeviceVos != nil && ![_MSceneModel.sceneDeviceVos isKindOfClass:[NSNull class]] && _MSceneModel.sceneDeviceVos.count != 0){
            for (EHOMESceneDeviceModel *dev in _MSceneModel.sceneDeviceVos) {
                NSLog(@"打印设备的type= %d",dev.device.product.productType);
                NSString *typeStr = [NSString stringWithFormat:@"%d",dev.device.product.productType];
                [devicetypeAry addObject:typeStr];
            }
            if([devicetypeAry containsObject:@"3"] && [devicetypeAry containsObject:@"2"]){
                self.deviceImage1.hidden = NO;
                self.deviceImage2.hidden = NO;
                self.deviceImage3.hidden = YES;
                self.deviceImage1.image = [UIImage imageNamed:@"bulb-Icon"];
                self.deviceImage2.image = [UIImage imageNamed:@"socket-Icon"];
            }else{
                if ([devicetypeAry containsObject:@"3"]){
                    self.deviceImage1.hidden = NO;
                    self.deviceImage2.hidden = YES;
                    self.deviceImage3.hidden = YES;
                    self.deviceImage1.image = [UIImage imageNamed:@"socket-Icon"];
                }else if([devicetypeAry containsObject:@"2"]){
                    self.deviceImage1.hidden = NO;
                    self.deviceImage2.hidden = YES;
                    self.deviceImage3.hidden = YES;
                    self.deviceImage1.image = [UIImage imageNamed:@"bulb-Icon"];
                }else{
                    
                }
            }
        }else{
            NSLog(@"没有设备啊");
            self.deviceImage1.hidden = YES;
            self.deviceImage2.hidden = YES;
            self.deviceImage3.hidden = YES;
        }
    }
}

-(void)clickExecute{
    [self.delegate gotoExecuteSceneWithScene:self.MSceneModel];
}

- (void)dealloc {
    [_executeImageView release];
    [super dealloc];
}
@end
