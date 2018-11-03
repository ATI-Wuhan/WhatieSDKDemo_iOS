//
//  EHOMEMallViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/8/25.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define storeCellId @"EHOMEStoreCollectionViewCell"
#import "EHOMEMallViewController.h"
#import "EHOMEStoreCollectionViewCell.h"

@interface EHOMEMallViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *StoreCollectionView;
@property (nonatomic, strong) NSArray *GoodsModels;
@end

@implementation EHOMEMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"Store", @"Home", nil);
    [self initcollectionView];
    [self getGoodsList];
    // Do any additional setup after loading the view from its nib.
}

-(void)initcollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.StoreCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.StoreCollectionView];
    self.StoreCollectionView.backgroundColor = [UIColor clearColor];
    [self.StoreCollectionView registerNib:[UINib nibWithNibName:@"EHOMEStoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:storeCellId];
    self.StoreCollectionView.delegate = self;
    self.StoreCollectionView.dataSource = self;
    self.StoreCollectionView.showsHorizontalScrollIndicator = NO;
    self.StoreCollectionView.showsVerticalScrollIndicator = NO;
    
    
    __weak typeof(self) weakSelf = self;
    
    [self.StoreCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).mas_offset(10);
        make.left.mas_equalTo(weakSelf.view).mas_offset(10);
        make.right.mas_equalTo(weakSelf.view).mas_offset(-10);
        make.bottom.mas_equalTo(weakSelf.view);
    }];
    
    self.StoreCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getGoodsList];
    }];
    
    [self.StoreCollectionView.mj_header beginRefreshing];
}

-(void)getGoodsList{
    [EHOMEGoodsModel getMallGoodsListSuccess:^(id responseObject) {
        NSLog(@"获取商品列表成功！");
        [self.StoreCollectionView.mj_header endRefreshing];
        self.GoodsModels=responseObject;
        [self.StoreCollectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取商品列表成功失败 = %@", error);
        [self.StoreCollectionView.mj_header endRefreshing];
        [HUDHelper addHUDInView:self.view text:error.domain hideAfterDelay:1.0];
        [self.StoreCollectionView reloadData];
    }];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.GoodsModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EHOMEStoreCollectionViewCell *cell = (EHOMEStoreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:storeCellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEStoreCollectionViewCell alloc] init];
    }
    
    cell.goodsModel = self.GoodsModels[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-30)/2;
    return CGSizeMake(width, 260);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"跳转到淘宝");
    NSString *itemId = @"577180512157";
    NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@", itemId]];
    
    NSURL *httpUrl = [NSURL URLWithString:@"https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-18820725925.2.2628100cuyINWJ&id=577180512157"];
    
    if([[UIApplication sharedApplication] canOpenURL:appUrl]) {

        [[UIApplication sharedApplication] openURL:appUrl];

    } else {

        //打开网页淘宝

        [[UIApplication sharedApplication] openURL:httpUrl];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
