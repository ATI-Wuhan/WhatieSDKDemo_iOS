//
//  EHOMEStoreCollectionViewCell.h
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHOMEStoreCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *productImageView;
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UILabel *productPrice;

@property (nonatomic, strong) EHOMEGoodsModel *goodsModel;
@end
