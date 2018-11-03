//
//  EHOMEBackgroundViewController.m
//  WhatieSDKDemo
//
//  Created by clj on 2018/7/10.
//  Copyright © 2018年 IIDreams. All rights reserved.
//
#define backcellId @"EHOMEbackgroundCell"

#import "EHOMEBackgroundViewController.h"
#import "EHOMEbackgroundCell.h"

@interface EHOMEBackgroundViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *bgCollectionView;
@property (nonatomic, strong) NSMutableArray *defaultRoomPicList;
@property (nonatomic, strong) NSMutableArray *HorizontalPicList;
@property (nonatomic, strong) NSString *picUrl;

@end

@implementation EHOMEBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"Background", @"Room", nil);
    self.view.backgroundColor = RGB(240, 240, 240);
    
    self.defaultRoomPicList = [NSMutableArray array];
    self.HorizontalPicList = [NSMutableArray array];
    [self getbgphoto];
    [self initcollectionView];
    // Do any additional setup after loading the view.
}

-(void)getbgphoto{
    NSLog(@"获取背景图");
    [EHOMERoomModel getRoomBackgroundListSuccess:^(id responseObject) {
        NSLog(@"获取默认壁纸成功！=%@",responseObject);
        for(EHOMEBackgroundModel *background in responseObject){
            if(background.vertical){
                [self.defaultRoomPicList addObject:background];
            }else{
                [self.HorizontalPicList addObject:background];
            }
        }
        NSLog(@"默认壁纸成功！=%@",self.defaultRoomPicList);
        [self.bgCollectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取默认壁纸失败");
    }];
}


-(void)initcollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.bgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.bgCollectionView];
    self.bgCollectionView.backgroundColor = [UIColor clearColor];
    [self.bgCollectionView registerClass:[EHOMEbackgroundCell class] forCellWithReuseIdentifier:backcellId];
    self.bgCollectionView.delegate = self;
    self.bgCollectionView.dataSource = self;
    self.bgCollectionView.showsHorizontalScrollIndicator = NO;
    self.bgCollectionView.showsVerticalScrollIndicator = NO;
    
    
    __weak typeof(self) weakSelf = self;
    
    [self.bgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).mas_offset(5);
        make.left.right.bottom.mas_equalTo(weakSelf.view);
    }];
    
}

#pragma mark - UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.defaultRoomPicList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EHOMEbackgroundCell *cell = (EHOMEbackgroundCell *)[collectionView dequeueReusableCellWithReuseIdentifier:backcellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[EHOMEbackgroundCell alloc] init];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    EHOMEBackgroundModel *model=self.defaultRoomPicList[indexPath.item];
    NSLog(@"壁纸=%@",model);
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.file.path] placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    EHOMEBackgroundModel *model=self.defaultRoomPicList[indexPath.item];
    
    NSMutableArray *modelArray = [NSMutableArray arrayWithObject:model];
    for(EHOMEBackgroundModel *back in self.HorizontalPicList){
        if(back.wallpaperNum == model.wallpaperNum){
            [modelArray addObject:back];
            break;
        }
    }
    NSArray *ary = modelArray;
    
    if(self.tag==0){
        [self.roommodel updateRoomBackground:model success:^(id responseObject) {
            NSLog(@"提交成功 = %@", responseObject);
            [HUDHelper addHUDInView:sharedKeyWindow text:NSLocalizedStringFromTable(@"Change backgroud Successfully", @"Room", nil) hideAfterDelay:1];
            self.changePictureBlock(ary);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"提交失败 = %@",error);
            [HUDHelper showErrorDomain:error];
        }];
        
    }else{
        self.changePictureBlock(ary);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((DEVICE_W - 30)/2, 260);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
