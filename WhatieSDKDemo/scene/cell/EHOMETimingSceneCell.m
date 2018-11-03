//
//  EHOMETimingSceneCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/24.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMETimingSceneCell.h"

@implementation EHOMETimingSceneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTSceneModel:(EHOMESceneModel *)TSceneModel{
    _TSceneModel=TSceneModel;
    if(_TSceneModel != nil){
        self.timingSceneName.text = _TSceneModel.scene.name;
        self.timeLabel.text = _TSceneModel.finishTimeApp;
        self.sceneSwitch.on = _TSceneModel.scene.status;
        
        NSMutableArray *typeAry =[NSMutableArray array];
        if(_TSceneModel.sceneDeviceVos != nil && ![_TSceneModel.sceneDeviceVos isKindOfClass:[NSNull class]] && _TSceneModel.sceneDeviceVos.count != 0){
            for (EHOMESceneDeviceModel *dev in _TSceneModel.sceneDeviceVos) {
                NSString *typeStr = [NSString stringWithFormat:@"%d",dev.device.product.productType];
                [typeAry addObject:typeStr];
            }
            if([typeAry containsObject:@"3"] && [typeAry containsObject:@"2"]){
                self.DeviceImage1.hidden = NO;
                self.DeviceImage2.hidden = NO;
                self.DeviceImage3.hidden = YES;
                self.DeviceImage1.image = [UIImage imageNamed:@"bulb-Icon"];
                self.DeviceImage2.image = [UIImage imageNamed:@"socket-Icon"];
            }else{
                if ([typeAry containsObject:@"3"]){
                    self.DeviceImage1.hidden = NO;
                    self.DeviceImage2.hidden = YES;
                    self.DeviceImage3.hidden = YES;
                    self.DeviceImage1.image = [UIImage imageNamed:@"socket-Icon"];
                }else if([typeAry containsObject:@"2"]){
                    self.DeviceImage1.hidden = NO;
                    self.DeviceImage2.hidden = YES;
                    self.DeviceImage3.hidden = YES;
                    self.DeviceImage1.image = [UIImage imageNamed:@"bulb-Icon"];
                }else{
                    
                }
            }
        }else{
            NSLog(@"没有设备啊");
            self.DeviceImage1.hidden = YES;
            self.DeviceImage2.hidden = YES;
            self.DeviceImage3.hidden = YES;
        }
    }
}

- (IBAction)changeSceneStatusAction:(id)sender {
    NSLog(@"输出场景的状态 = %d",_TSceneModel.scene.status);
    BOOL sceneStatus = (_TSceneModel.scene.status == YES) ? NO : YES;
    
    [_TSceneModel updateSceneStatus:sceneStatus success:^(id responseObject) {
        NSLog(@"update scene status success. res = %@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"update scene status failed. error = %@", error);
    }];
}
@end
