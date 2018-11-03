//
//  EHOMEGoodsModel.h
//  WhatieSDK
//
//  Created by clj on 2018/9/14.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
@class GoodsDetailModel;
#import <WhatieSDK/WhatieSDK.h>

@interface EHOMEGoodsModel : EHOMEBaseObject
@property (nonatomic, assign) int mallGoodsId;
@property (nonatomic, assign) int categoryId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int price;
@property (nonatomic, strong) NSArray <GoodsDetailModel *> *mallGoodsDetailList;

+(void)getMallGoodsListSuccess:(successBlock)success
                       failure:(failBlock)failure;
@end


@interface GoodsDetailModel:EHOMEBaseObject
@property (nonatomic, assign) int mallGoodsDetailId;
@property (nonatomic, assign) int goodsId;
@property (nonatomic, assign) int mallType;
@property (nonatomic, assign) int price;
@property (nonatomic, assign) int mallItemId;
@property (nonatomic, copy) NSString *goodsPath;
@property (nonatomic, copy) NSString *goodsUrl;
@property (nonatomic, copy) NSString *pictureUrl;
@end
