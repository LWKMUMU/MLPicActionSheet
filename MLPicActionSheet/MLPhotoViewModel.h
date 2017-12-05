//
//  MLPhotoViewModel.h
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLCollectionViewCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSString+MLNSString.h"

@protocol MLPhotoViewModelDelegate <NSObject>

- (void)complete;
- (void)preview;
- (void)createAlert:(NSString *)code;

@end

@interface MLPhotoViewModel : NSObject <UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSMutableArray  * setArray;
@property(nonatomic,strong)NSMutableArray * albumArray;
@property(nonatomic,strong)PHFetchResult *  CameraResult;
@property(nonatomic,strong)NSMutableArray * imagesArray;
@property(nonatomic,weak)id<MLPhotoViewModelDelegate>delegate;
@property(nonatomic,strong)NSMutableArray  * selectedImageArray;
@property(nonatomic,strong)NSMutableArray * selectedPhssetArray;
@property(nonatomic,assign)NSInteger maxIndex;
@property(nonatomic,strong)UIColor * btnColor;
/*
 相册名字
 */
@property(nonatomic,strong)NSString * albumName;
- (UIView *)basisUI;
- (UIView *)createFooterView;
@end
