//
//  EHOMEExecuteView.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEExecuteView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *actions;//action数组

@property (nonatomic, strong) UILabel *titleLabel;//标题label
@property (nonatomic, strong) UIButton *closeButton;//确定按钮

/*!
 * @abstract 创建弹窗下拉列表类方法
 *
 * @param title 下拉框标题
 * @param actions 下拉框显示的数组
 * @param showCloseButton 显示关闭按钮则关闭点击列表外remove弹窗的功能
 *
 */
+ (EHOMEExecuteView *)showWithTitle:(NSString *)title
                            actions:(NSArray *)actions
                    showCloseButton:(BOOL)showCloseButton;
@end
