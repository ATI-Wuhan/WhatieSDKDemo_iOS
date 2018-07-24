//
//  EHOMEScenesCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/12.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEScenesCell.h"

@implementation EHOMEScenesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.SceneBgView.layer.masksToBounds = YES;
    self.SceneBgView.layer.cornerRadius = 20.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSceneModel:(EHOMESceneModel *)sceneModel{
    _sceneModel=sceneModel;
    if(_sceneModel != nil){
        self.sceneName.text = _sceneModel.scene.name;
        [self.excBtn setImage:[[UIImage imageNamed:@"excute-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.timeLabel.text = _sceneModel.finishTimeApp;
        NSLog(@"时间 = %@",_sceneModel.scene.finishTime);
        self.timeTitle.text = NSLocalizedString(@"Openning time", nil);
        
        if(_sceneModel.scene.status){
            [self.SceneImageView setImage:[UIImage imageNamed:@"scenebackground1"]];
            
            [self.turnBtn setImage:[[UIImage imageNamed:@"scene-close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            
        }else{
            [self.SceneImageView setImage:[UIImage imageNamed:@"scenebackground2"]];
            
            [self.turnBtn setImage:[[UIImage imageNamed:@"scene-open"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        
        NSMutableArray *typeAry =[NSMutableArray array];
        if(_sceneModel.sceneDeviceVos.count >0){
            NSLog(@"设备啊，显示什么=%lu",(unsigned long)_sceneModel.sceneDeviceVos.count);
            for (EHOMESceneDeviceModel *dev in _sceneModel.sceneDeviceVos) {
                NSString *typeStr = [NSString stringWithFormat:@"%d",dev.device.product.productType];
                [typeAry addObject:typeStr];
            }
            if([typeAry containsObject:@"3"] && [typeAry containsObject:@"2"]){
                self.deviceImage1.image = [UIImage imageNamed:@"light-Icon"];
                self.deviceImage2.image = [UIImage imageNamed:@"outlet-Icon"];
            }else{
                if ([typeAry containsObject:@"3"]){
                    self.deviceImage1.image = [UIImage imageNamed:@"outlet-Icon"];
                }else if([typeAry containsObject:@"2"]){
                    self.deviceImage1.image = [UIImage imageNamed:@"light-Icon"];
                }else{
                    
                }
            }
        }else{
            NSLog(@"无设备啊，显示什么=%lu",(unsigned long)_sceneModel.sceneDeviceVos.count);
            self.deviceImage1.hidden = YES;
            self.deviceImage2.hidden = YES;
        }
        
        
    }
}

- (IBAction)changeSceneStatusAction:(id)sender {
    NSLog(@"输出场景的状态 = %d",_sceneModel.scene.status);
    BOOL sceneStatus;
    if(_sceneModel.scene.status){
        sceneStatus = NO;
        [self.SceneImageView setImage:[UIImage imageNamed:@"scenebackground2"]];
        
        [self.turnBtn setImage:[[UIImage imageNamed:@"scene-open"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _sceneModel.scene.status=NO;
    }else{
        sceneStatus = YES;
        [self.SceneImageView setImage:[UIImage imageNamed:@"scenebackground1"]];
        
        [self.turnBtn setImage:[[UIImage imageNamed:@"scene-close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _sceneModel.scene.status=YES;
    }
    
    [_sceneModel updateSceneStatus:sceneStatus success:^(id responseObject) {
        NSLog(@"update scene status success. res = %@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"update scene status failed. error = %@", error);
    }];
    
}
@end
