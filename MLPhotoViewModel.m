//
//  MLPhotoViewModel.m
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import "MLPhotoViewModel.h"
#import "MLPhotoManager.h"

@interface MLPhotoViewModel ()<MLCollectionViewCellDelegate>
/*
 照片ID
 */

@property(nonatomic,strong)NSMutableArray * phssetArray;
@property(nonatomic,strong)UILabel * previewLable;
@property(nonatomic,strong)UILabel * completeLable;
@end

@implementation MLPhotoViewModel

- (void)setSelectedPhssetArray:(NSMutableArray *)selectedPhssetArray{
    _selectedPhssetArray = selectedPhssetArray;
    if (_selectedPhssetArray.count == 0 && self.previewLable){
        self.previewLable.alpha = 0.0;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (UIView *)basisUI{
    CGFloat interval = 2;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - interval * 5)/4;
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 1, 1, 1);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 2;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 10 - 49) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    [self.collectionView  registerClass:[MLCollectionViewCell class] forCellWithReuseIdentifier:@"MLCollectionViewCell"];
    [self getPhoto];
    
    return self.collectionView;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imagesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MLCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLCollectionViewCell" forIndexPath:indexPath];
    cell.selecedImageView.image = [UIImage imageNamed:@"未选中"];
    cell.isSelected = NO;
    PHAsset * subSet = self.phssetArray[indexPath.item];
    for (PHAsset * sset in self.selectedPhssetArray){
        if ([sset isEqual:subSet]){
            cell.selecedImageView.image = [UIImage imageNamed:@"a"];
            cell.isSelected = YES;
            break;
        }else{
            cell.selecedImageView.image = [UIImage imageNamed:@"未选中"];
            cell.isSelected = NO;
        }
    }
    UIImage * image = self.imagesArray[indexPath.item];
    cell.subImageView.image = image;
    cell.sset = subSet;
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)selectedImage:(UIImage *)image andCell:(id)cell{
    if (self.selectedImageArray.count >= self.maxIndex){
        if (_delegate){
            [_delegate createAlert:[NSString stringWithFormat:@"最多可选择%ld张图片",self.maxIndex]];
        }
        return;
    }
    MLCollectionViewCell * subCell = (MLCollectionViewCell *)cell;
    subCell.selecedImageView.image = [UIImage imageNamed:@"a"];
    subCell.isSelected = YES;
    if (!self.selectedImageArray){
        self.selectedImageArray = [[NSMutableArray alloc] init];
    }
    if (!self.selectedPhssetArray){
        self.selectedPhssetArray = [[NSMutableArray alloc] init];
    }
    [self.selectedImageArray addObject:image];
    [self.selectedPhssetArray addObject:subCell.sset];
    if (self.selectedPhssetArray.count > 0){
        self.previewLable.alpha = 1.0;
    }
}
- (void)deleteImage:(UIImage *)image andCell:(id)cell{
     MLCollectionViewCell * subCell = (MLCollectionViewCell *)cell;
    if ([self.selectedImageArray containsObject:image]){
        [self.selectedImageArray removeObject:image];
    }
    if ([self.selectedPhssetArray containsObject:subCell.sset]){
        [self.selectedPhssetArray removeObject:subCell.sset];
    }
    subCell.isSelected = NO;
    subCell.selecedImageView.image = [UIImage imageNamed:@"未选中"];
    if (self.selectedPhssetArray.count == 0){
        self.previewLable.alpha = 0.0;
    }
}
- (void)getPhoto{
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        return;
    }
    [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *assetArr = [NSMutableArray array];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    NSLog(@"系统相册的数目 = %ld",smartAlbums.count);
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        NSLog(@"相册名:%@，有%ld张图片",collection.localizedTitle,results.count);
        if (results.count != 0){
            [nameArr addObject:collection.localizedTitle];
            [assetArr addObject:results];
        }
        if (self.albumName){
            if ([collection.localizedTitle isEqualToString:self.albumName]){
                self.CameraResult = results;
                [self requestImage];
            }
        }else{
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"]){
                self.CameraResult = results;
                [self requestImage];
            }
        }
    }
    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customCollections) {
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assets.count != 0 ){
            [nameArr addObject:collection.localizedTitle];
            [assetArr addObject:assets];
        }
        if (self.albumName){
            if ([collection.localizedTitle isEqualToString:self.albumName]){
                self.CameraResult = assets;
                [self requestImage];
            }
        }
    }
    self.albumArray = nameArr;
    self.setArray = assetArr;

}
- (UIView *)createFooterView{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49)];
    UIColor * backColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    footerView.backgroundColor = backColor;
    self.previewLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 49)];
    self.previewLable.text = @"预览";
    self.previewLable = [self createLable:self.previewLable];
    self.previewLable.alpha = 0.0;
    [footerView addSubview:self.previewLable];
    
    self.completeLable = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 40, 49)];
    
    self.completeLable.text = @"完成";
    self.completeLable = [self createLable:self.completeLable];
    [footerView addSubview:self.completeLable];
    
    UITapGestureRecognizer * completeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeTapAction:)];
    [self.completeLable addGestureRecognizer:completeTap];
    UITapGestureRecognizer * previewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewTapAction:)];
    [self.previewLable addGestureRecognizer:previewTap];
    return footerView;
}
- (UILabel * )createLable:(UILabel *)lable{
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = self.btnColor?self.btnColor:[UIColor whiteColor];
    lable.userInteractionEnabled = YES;
    return lable;
}
- (void)previewTapAction:(UIGestureRecognizer *)ges{
    if (_delegate){
        [_delegate preview  ];
    }
}
- (void)completeTapAction:(UIGestureRecognizer *)ges{
    if (_delegate){
        [_delegate complete];
    }
}
- (void)requestImage{
    CGSize  size = CGSizeMake(300, 300);
    dispatch_queue_t mlQueue = dispatch_queue_create("mlqueue", NULL);
    
    
    for (PHAsset * sset in self.CameraResult){
        dispatch_async(mlQueue, ^{
            
            [MLPhotoManager MLrequestImageForAsset:sset targetSize:size resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if(result){
                    if (!_imagesArray){
                        _imagesArray = [[NSMutableArray alloc] init];
                    }
                    if ([info.allKeys containsObject:PHImageResultIsDegradedKey]){
                        NSMutableArray <NSIndexPath *>* indexPathArray = [[NSMutableArray alloc] init];
                        BOOL downloadFinined = ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                        if (downloadFinined){
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (!_phssetArray){
                                    _phssetArray = [[NSMutableArray alloc] init];
                                }
                                [_phssetArray addObject:sset];
                                [_imagesArray addObject:result];
                                NSIndexPath * indexPath = [NSIndexPath indexPathForItem:_imagesArray.count - 1 inSection:0];
                                [indexPathArray addObject:indexPath];
                                [self.collectionView insertItemsAtIndexPaths:indexPathArray];
                                //                            [self.collectionView reloadData];
                            });
                        }
                        
                    }
                }
            }];
            
        });
    }
}

@end
