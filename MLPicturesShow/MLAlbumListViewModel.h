//
//  MLAlbumListViewModel.h
//  MLPhoto
//
//  Created by 伟凯   刘 on 2017/6/5.
//  Copyright © 2017年 无敌小蚂蚱. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLAlbumListTableViewCell.h"
#import "NSString+MLNSString.h"


@protocol MLAlbumListViewModelDelegate <NSObject>

- (void)albumDetail:(NSString *)albumName;

@end
@interface MLAlbumListViewModel : NSObject

@property(nonatomic,strong)NSMutableArray  * setArray;
@property(nonatomic,strong)NSMutableArray * albumArray;
@property(nonatomic,weak)id<MLAlbumListViewModelDelegate>delegate;
@property(nonatomic,strong)NSMutableArray  * selectedImageArray;
@property(nonatomic,strong)NSMutableArray * selectedPhssetArray;
- (UITableView *)basisUI;
@end
