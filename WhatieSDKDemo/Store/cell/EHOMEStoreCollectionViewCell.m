//
//  EHOMEStoreCollectionViewCell.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import "EHOMEStoreCollectionViewCell.h"

@implementation EHOMEStoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setGoodsModel:(EHOMEGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    if(_goodsModel != nil){
        for(GoodsDetailModel *detail in _goodsModel.mallGoodsDetailList){
            if(detail.mallType == 0){
                [self.productImageView sd_setImageWithURL:[NSURL URLWithString:detail.pictureUrl] placeholderImage:[UIImage imageNamed:@"product1"]];
                break;
            }
        }
        self.productName.text = _goodsModel.name;
        self.productPrice.text = [NSString stringWithFormat:@"%d",_goodsModel.price];
    }
}

- (void)dealloc {
    [_productImageView release];
    [_productName release];
    [_productPrice release];
    [super dealloc];
}
@end
