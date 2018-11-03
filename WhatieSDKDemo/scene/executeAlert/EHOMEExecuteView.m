//
//  EHOMEExecuteView.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/7.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define excActionCellId @"EHOMEExecuteActionTableViewCell"

#import "EHOMEExecuteView.h"
#import "EHOMEExecuteActionTableViewCell.h"

@interface EHOMEExecuteView ()

@property (nonatomic, assign) BOOL showCloseButton;//是否显示关闭按钮
@property (nonatomic, strong) UIView *alertView;//弹框视图
@property (nonatomic, strong) UITableView *selectTableView;//选择列表

@end

@implementation EHOMEExecuteView{
    float alertHeight;//弹框整体高度，默认300
    float buttonHeight;//按钮高度，默认40
}

+ (EHOMEExecuteView *)showWithTitle:(NSString *)title
                            actions:(NSArray *)actions
                    showCloseButton:(BOOL)showCloseButton {
    EHOMEExecuteView *alert = [[EHOMEExecuteView alloc] initWithTitle:title actions:actions showCloseButton:showCloseButton];
    return alert;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 8;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor colorWithRed:0 green:127/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_selectTableView registerNib:[UINib nibWithNibName:@"EHOMEExecuteActionTableViewCell" bundle:nil] forCellReuseIdentifier:excActionCellId];
    }
    return _selectTableView;
}

- (instancetype)initWithTitle:(NSString *)title actions:(NSArray *)actions showCloseButton:(BOOL)showCloseButton {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        alertHeight = 250;
        buttonHeight = 40;
        
        self.titleLabel.text = title;
        _actions = actions;
        _showCloseButton = showCloseButton;
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLabel];
        [self.alertView addSubview:self.selectTableView];
        if (_showCloseButton) {
            [self.alertView addSubview:self.closeButton];
        }
        [self initUI];
        
        [self show];
        
        [[EHOMEMQTTClientManager shareInstance] setMqttBlock:^(NSString *topic, NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dic allKeys] containsObject:@"protocol"]) {
                NSString *devId = [[dic objectForKey:@"data"] objectForKey:@"devId"];
                
                if ([[dic objectForKey:@"protocol"] intValue] == 1) {
                    
                    for(int i = 0;i<self.actions.count;i++){
                        EHOMESceneDeviceModel *model = self.actions[i];
                        if([model.device.devId isEqualToString:devId]){
                            if(model.device.product.productType == 3){
                                if(model.dps.first == [[[[[dic objectForKey:@"data"] objectForKey:@"dps"] allValues] firstObject] boolValue]){
                                    //model.executeSuccess = YES;
                                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.actions];
                                    [temp replaceObjectAtIndex:i withObject:model];
                                    self.actions = temp;
                                    [self.selectTableView reloadData];
                                }
                            }
                        }
                    }
                }else if ([[dic objectForKey:@"protocol"] intValue] == 18){
                    int lightMode = [[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"lightMode"] intValue];
                    if (lightMode == 4) {
                        for(int i = 0;i<self.actions.count;i++){
                            EHOMESceneDeviceModel *model = self.actions[i];
                            if([model.device.devId isEqualToString:devId]){
                                if([model.dps.status isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"status"]]){
                                    //model.executeSuccess = YES;
                                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.actions];
                                    [temp replaceObjectAtIndex:i withObject:model];
                                    self.actions = temp;
                                    [self.selectTableView reloadData];
                                }
                            }
                        }
                    }else if(lightMode == 1){
                        for(int i = 0;i<self.actions.count;i++){
                            EHOMESceneDeviceModel *model = self.actions[i];
                            if([model.device.devId isEqualToString:devId]){
                                if([model.dps.l isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"l"]]){
                                    //model.executeSuccess = YES;
                                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.actions];
                                    [temp replaceObjectAtIndex:i withObject:model];
                                    self.actions = temp;
                                    [self.selectTableView reloadData];
                                }
                            }
                        }
                    }else if(lightMode == 2){
                        for(int i = 0;i<self.actions.count;i++){
                            EHOMESceneDeviceModel *model = self.actions[i];
                            if([model.device.devId isEqualToString:devId]){
                                if([model.dps.l isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"l"]] && [model.dps.rgb isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb"]]){
                                    //model.executeSuccess = YES;
                                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.actions];
                                    [temp replaceObjectAtIndex:i withObject:model];
                                    self.actions = temp;
                                    [self.selectTableView reloadData];
                                }
                            }
                        }
                    }
                    
                }else if ([[dic objectForKey:@"protocol"] intValue] == 19){
                    for(int i = 0;i<self.actions.count;i++){
                        EHOMESceneDeviceModel *model = self.actions[i];
                        if([model.device.devId isEqualToString:devId]){
                            if([model.dps.l isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"l"]] && [model.dps.t isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"t"]] && [model.dps.rgb1 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb1"]] && [model.dps.rgb2 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb2"]] && [model.dps.rgb3 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb3"]] && [model.dps.rgb4 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb4"]]){
                                model.executeSuccess = YES;
                                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.actions];
                                [temp replaceObjectAtIndex:i withObject:model];
                                //self.actions = temp;
                                [self.selectTableView reloadData];
                            }
                        }
                    }
                }
                
                
            }
        }];
    }
    return self;
}

- (void)show {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.alertView.alpha = 1;
    }];
}

- (void)initUI {
    self.alertView.frame = CGRectMake(50, ([UIScreen mainScreen].bounds.size.height-alertHeight)/2.0, [UIScreen mainScreen].bounds.size.width-100, alertHeight);
    self.titleLabel.frame = CGRectMake(0, 0, _alertView.frame.size.width, buttonHeight);
    float reduceHeight = buttonHeight;
    if (_showCloseButton) {
        self.closeButton.frame = CGRectMake(0, _alertView.frame.size.height-buttonHeight, _alertView.frame.size.width, buttonHeight);
        reduceHeight = buttonHeight*2;
    }
    self.selectTableView.frame = CGRectMake(0, buttonHeight, _alertView.frame.size.width, _alertView.frame.size.height-reduceHeight);
}


#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float real = (alertHeight - buttonHeight)/(float)_actions.count;
    if (_showCloseButton) {
        real = (alertHeight - buttonHeight*2)/(float)_actions.count;
    }
    return real<=40?40:real;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EHOMEExecuteActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:excActionCellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEExecuteActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:excActionCellId];
    }
    EHOMESceneDeviceModel *sceneDevice = _actions[indexPath.row];
    [cell.stateSpiner startAnimating];
    cell.stateImageview.hidden = YES;
    cell.sceneDevcieModel = sceneDevice;
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.alertView frame], pt) && !_showCloseButton) {
        [self closeAction];
    }
}

- (void)closeAction {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
