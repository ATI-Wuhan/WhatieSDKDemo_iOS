//
//  EHOMESceneNameCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeSceneNameDelegate<NSObject>

-(void)gotoChangeSceneName;

@end

@interface EHOMESceneNameCell : UITableViewCell
@property (nonatomic, assign) id<changeSceneNameDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *editSceneName;
@property (retain, nonatomic) IBOutlet UILabel *NameLabel;

- (IBAction)editNameAction:(id)sender;
@end
