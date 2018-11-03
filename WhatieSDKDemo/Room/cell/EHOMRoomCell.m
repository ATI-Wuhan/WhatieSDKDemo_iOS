//
//  EHOMRoomCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/10.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMRoomCell.h"

@implementation EHOMRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.roomView.layer.masksToBounds = YES;
    self.roomView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRoomModel:(EHOMERoomModel *)roomModel{
    _roomModel = roomModel;
    if (_roomModel != nil) {
        [self.roomImageview sd_setImageWithURL:[NSURL URLWithString:_roomModel.room.backgroundThumb.path] placeholderImage:[UIImage imageNamed:@"room_bg_default"]];
        
        NSString *loneStr = NSLocalizedStringFromTable(@"online", @"Room", nil);
        self.nameLabel.text=_roomModel.room.name;
        self.stateLabel.text=[NSString stringWithFormat:@"%d/%d %@",_roomModel.onlineCount,_roomModel.allCount,loneStr];
    }
}

@end
