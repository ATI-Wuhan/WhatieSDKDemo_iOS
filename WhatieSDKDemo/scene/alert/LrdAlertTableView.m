//
//  LrdAlertTableView.m
//  AlertTableView
//
//  Created by 键盘上的舞者 on 3/28/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//
#define CellId @"EHOMEAlertActionTableViewCell"
#import "LrdAlertTableView.h"
#import "EHOMEAlertActionTableViewCell.h"

#define tableViewHeight [UIScreen mainScreen].bounds.size.height - 80 -100

@interface LrdAlertTableView () <UITableViewDataSource, UITableViewDelegate>
//背景
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;
//标题
@property (nonatomic, strong) UILabel *title;
//子标题
@property (nonatomic, strong) UILabel *subTitle;
//线条
@property (nonatomic, strong) UILabel *line;
//tableView
@property (nonatomic, strong) UITableView *tableView;
//关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSIndexPath *indexpath;
@end

@implementation LrdAlertTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化各种控件
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_backgroundView];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        [self addSubview:_contentView];
        
        _title = [[UILabel alloc] init];
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        _title.text = self.SceneName;
        [self.contentView addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.font = [UIFont systemFontOfSize:13];
        _subTitle.textColor = [UIColor grayColor];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.text = NSLocalizedString(@"result", nil);
        [self.contentView addSubview:_subTitle];
        
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_line];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close-btn"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeButton];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
        
        //添加布局约束
        [self initUI];
        
        [_tableView registerNib:[UINib nibWithNibName:@"EHOMEAlertActionTableViewCell" bundle:nil] forCellReuseIdentifier:CellId];
        
        
        
        
        [[EHOMEMQTTClientManager shareInstance] setMqttBlock:^(NSString *topic, NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([[dic allKeys] containsObject:@"protocol"]) {
                NSString *devId = [[dic objectForKey:@"data"] objectForKey:@"devId"];
                
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataArray];
                
                if ([[dic objectForKey:@"protocol"] intValue] == 1){
                    for(int i = 0;i<self.dataArray.count;i++){
                        EHOMESceneDeviceModel *model = self.dataArray[i];
                        if([model.device.devId isEqualToString:devId]){
                            if([[[[[dic objectForKey:@"data"] objectForKey:@"dps"] allValues] firstObject] boolValue] == model.dps.first){
                                model.executeSuccess = 1;
                                [temp replaceObjectAtIndex:i withObject:model];
                            }
                        }
                    }
                    
                }else{
                    
                    int lightmode =[[[dic objectForKey:@"data"] objectForKey:@"lightMode"] intValue];
                    if ([[dic objectForKey:@"protocol"] intValue] == 18){
                        NSLog(@"收到了协议号为18 = %@",dic);
                        NSLog(@"收到了协议号为18的lightmode = %d",lightmode);
                        
                        if(lightmode == 4){
                            for(int i = 0;i<self.dataArray.count;i++){
                                EHOMESceneDeviceModel *model = self.dataArray[i];
                                if([model.device.devId isEqualToString:devId]){
                                    if(model.dps.lightMode ==4 && [model.dps.status isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"status"]]){
                                        model.executeSuccess = 1;
                                        [temp replaceObjectAtIndex:i withObject:model];
                                    }
                                }
                            }
                        }else if (lightmode == 1){
                            for(int i = 0;i<self.dataArray.count;i++){
                                EHOMESceneDeviceModel *model = self.dataArray[i];
                                NSLog(@"hede = %d",model.dps.lightMode);
                                NSLog(@"hede = %@",model.dps.l);
                                if([model.device.devId isEqualToString:devId]){
                                    if(model.dps.lightMode ==1 && [model.dps.l isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"l"]]){
                                        model.executeSuccess = 1;
                                        [temp replaceObjectAtIndex:i withObject:model];
                                    }
                                }
                            }
                        }else if (lightmode == 2){
                            for(int i = 0;i<self.dataArray.count;i++){
                                EHOMESceneDeviceModel *model = self.dataArray[i];
                                NSLog(@"彩灯的%d   %@",model.dps.lightMode,model.dps.l);
                                if([model.device.devId isEqualToString:devId]){
                                    if(model.dps.lightMode ==2 && [model.dps.l isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"l"]] && [model.dps.rgb isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb"]]){
                                        NSLog(@"进入了彩灯哦");
                                        model.executeSuccess = 1;
                                        [temp replaceObjectAtIndex:i withObject:model];
                                    }
                                }
                            }
                        }
                        
                    }else if ([[dic objectForKey:@"protocol"] intValue] == 19){
                        for(int i = 0;i<self.dataArray.count;i++){
                            EHOMESceneDeviceModel *model = self.dataArray[i];
                            if([model.device.devId isEqualToString:devId]){
                                if([model.dps.l isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"l"]] && [model.dps.rgb1 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb1"]] && [model.dps.rgb2 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb2"]] && [model.dps.rgb3 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb3"]] && [model.dps.rgb4 isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"rgb4"]] && [model.dps.t isEqualToString:[[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"t"]]){
                                    model.executeSuccess = 1;
                                    [temp replaceObjectAtIndex:i withObject:model];
                                }
                            }
                        }
                    }
                    
                    for(int i = 0;i<self.dataArray.count;i++){
                        EHOMESceneDeviceModel *dev = self.dataArray[i];
                        if([dev.device.devId isEqualToString:devId]){
                            NSString *light = [[[dic objectForKey:@"data"] objectForKey:@"dps"] objectForKey:@"l"];
                            if(dev.dps.lightMode ==4){
                                if([dev.dps.status isEqualToString:@"true"]){
                                    if(![light isEqualToString:@"0"]){
                                        dev.executeSuccess = 1;
                                        [temp replaceObjectAtIndex:i withObject:dev];
                                    }
                                }
                                
                            }
                        }
                    }
                }
                self.dataArray = temp;
                [self.tableView reloadData];
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *arry = [NSMutableArray arrayWithArray:self.dataArray];
            for (int i = 0;i<self.dataArray.count;i++) {
                EHOMESceneDeviceModel *devModel = self.dataArray[i];
                if(devModel.executeSuccess == 0){
                    devModel.executeSuccess = -1;
                    [arry replaceObjectAtIndex:i withObject:devModel];
                }
            }
            
            self.dataArray = arry;
            [self.tableView reloadData];
        });
        
    }
    return self;
}

- (void)initUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(100);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(tableViewHeight);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(20);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitle.mas_bottom).offset(20);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
}

#pragma mark pop和dismiss

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    //动画效果入场
    self.contentView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.contentView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.contentView.alpha = 1;
    }];
}

- (void)dismiss {
    //动画效果出场
    [UIView animateWithDuration:.35 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.contentView]) {
        [self dismiss];
    }
}

#pragma mark tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EHOMEAlertActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEAlertActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.deviceModel = self.dataArray[indexPath.row];
    if([cell.deviceModel.device.status isEqualToString:@"Offline"]){
        cell.stateImageView.image = [UIImage imageNamed:@"失败"];
    }else{
        if(cell.deviceModel.executeSuccess == 0){
            cell.stateImageView.image = [UIImage imageNamed:@"等待"];
        }else if(cell.deviceModel.executeSuccess == 1){
            cell.stateImageView.image = [UIImage imageNamed:@"勾"];
        }else{
            cell.stateImageView.image = [UIImage imageNamed:@"失败"];
        }
    }
    
    cell.userInteractionEnabled = NO;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

@end
